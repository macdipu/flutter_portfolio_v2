import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../../core/design/tokens.dart';
import '../../core/web/intro_session.dart';
import '../../core/widgets/logo_mark.dart';

/// What the page and the intro tell each other.
abstract class IntroSignals {
  static final Completer<void> _ready = Completer<void>();
  static final Completer<bool> _done = Completer<bool>();

  /// The hero's three name lines ("Md. Asad", "Chowdhury", "Dipu"). While the
  /// intro runs the hero lays them out invisibly under these keys, so the
  /// intro's letters can fly onto them.
  static final List<GlobalKey> heroNameKeys =
      List.generate(3, (_) => GlobalKey(debugLabel: 'heroName'));

  /// The page calls this once what the first screen shows is decoded.
  static void markReady() {
    if (!_ready.isCompleted) _ready.complete();
  }

  static bool get isReady => _ready.isCompleted;

  /// Completes when the intro hands over to the page. True when its letters
  /// landed on the hero's name, so the hero shows the name at once instead
  /// of animating it in. Never holds the page back for long.
  static Future<bool> get finished => kIsWeb
      ? _done.future
          .timeout(const Duration(seconds: 20), onTimeout: () => false)
      : Future<bool>.value(false);

  static void _complete(bool landed) {
    if (!_done.isCompleted) _done.complete(landed);
  }
}

/// The intro, in seconds. Every position is a pure function of time, so
/// skipping, resizing and theme changes all stay consistent.
abstract class _T {
  static const convA = 0.55, convDur = 1.45, convStagger = 0.45; // loose letters pack into the mark
  static const logoA = 2.05, logoStagger = 0.07, logoDur = 0.55; // the crisp mark sharpens over them
  static const swA = 2.45, swB = 2.95; // the swoosh draws in under "dipu"
  static const squeezeA = 3.25, squeezeB = 3.55; // the mark gathers itself
  static const breakA = 3.55, fly = 1.05, hiddenStagger = 0.55; // letters leave for the name
  static const settleA = 5.0, settleB = 5.5; // the name resolves
  static const subA = 5.2, subB = 5.7; // the role fades in
  static const end = 6.1;
  static const safety = 2.5; // never wait longer than this for the page after the end

  // The handoff, in seconds from its start: the name flies onto the hero.
  static const handFly = 1.1, handStagger = 0.03;
  static const handEnd = handFly + 18 * handStagger + 0.08;
}

/// A letter of the hero's name, measured on screen.
class _HeroLetter {
  const _HeroLetter(this.ch, this.center, this.style);
  final String ch;
  final Offset center;
  final TextStyle style;
}

/// Plays the intro over [child] on the web, then gets out of the way:
///
/// 1. loose A–Z letters drift, then swirl in and pack into the macdipu mark;
/// 2. the crisp mark sharpens over them and the swoosh draws in;
/// 3. the mark breaks: m, a, c become the initials M, A, C (Md. Asad
///    Chowdhury), d, i, p, u become DIPU, and every other letter of the name
///    slides out from behind it;
/// 4. MD. ASAD CHOWDHURY DIPU resolves, with the role beneath.
///
/// It fades once it has played and the page has called
/// [IntroSignals.markReady]. Reduced motion shows the final frame only; a
/// reload in the same tab replays only the last beat.
class IntroGate extends StatefulWidget {
  const IntroGate({super.key, required this.child});

  final Widget child;

  @override
  State<IntroGate> createState() => _IntroGateState();
}

class _IntroGateState extends State<IntroGate>
    with SingleTickerProviderStateMixin {
  static const _fade = Duration(milliseconds: 520);

  final _time = ValueNotifier<double>(0);
  late final Ticker _ticker = createTicker(_tick);
  final _scene = _Scene();
  Timer? _skipTimer;

  bool _seen = false;
  bool _started = false;
  bool _fading = false;
  bool _gone = !kIsWeb;
  bool _showSkip = false;
  double _offset = 0;
  double _elapsed = 0;

  @override
  void initState() {
    super.initState();
    if (_gone) {
      IntroSignals._complete(false);
      return;
    }
    _seen = readIntroSeen();
    _Scene.buildAtlas().then<void>(
      (img) => _scene.atlas = img,
      onError: (Object _) {},
    ).whenComplete(_start);
    _skipTimer = Timer(const Duration(seconds: 1), () {
      if (mounted && !_seen && !Motion.reduced(context)) {
        setState(() => _showSkip = true);
      }
    });
  }

  void _start() {
    if (!mounted || _started) return;
    _started = true;
    _offset = Motion.reduced(context)
        ? _T.end
        : (_seen ? _T.settleA - 0.4 : 0);
    _ticker.start();
  }

  void _tick(Duration elapsed) {
    _elapsed = elapsed.inMicroseconds / 1e6;
    final t = _elapsed + _offset;
    _time.value = t;
    final hs = _scene.handoffStart;
    if (hs != null) {
      if (t - hs >= _T.handEnd) _land();
      return;
    }
    if (!_fading &&
        t >= _T.end &&
        (IntroSignals.isReady || t >= _T.end + _T.safety)) {
      _handOff(t);
    }
  }

  void _skip() {
    if (_fading || _scene.handoffStart != null) return;
    _offset = math.max(_offset, _T.settleA - 0.1 - _elapsed);
  }

  /// Fly the name onto the hero's own name, if it can be found on screen.
  void _handOff(double t) {
    final letters = Motion.reduced(context) ? null : _measureHero();
    if (letters == null || !_scene.attachHero(letters)) {
      _finish();
      return;
    }
    _scene.handoffStart = t;
    setState(() => _showSkip = false);
  }

  /// Where each letter of the hero's name sits right now, or null when the
  /// hero has not laid it out (narrow layouts, scrolled away, not built).
  List<List<_HeroLetter>>? _measureHero() {
    final view = MediaQuery.sizeOf(context);
    final lines = <List<_HeroLetter>>[];
    for (final key in IntroSignals.heroNameKeys) {
      final ro = key.currentContext?.findRenderObject();
      if (ro is! RenderParagraph || !ro.attached || !ro.hasSize) return null;
      final span = ro.text;
      final style = span.style;
      if (style == null) return null;
      final text = span.toPlainText();
      final line = <_HeroLetter>[];
      for (var i = 0; i < text.length; i++) {
        final boxes = ro.getBoxesForSelection(
            TextSelection(baseOffset: i, extentOffset: i + 1));
        if (boxes.isEmpty) return null;
        final c = ro.localToGlobal(boxes.first.toRect().center);
        if (c.dy < 0 || c.dy > view.height) return null;
        line.add(_HeroLetter(text[i], c, style));
      }
      lines.add(line);
    }
    return lines;
  }

  /// The letters are on the hero's name: show the real page.
  void _land() {
    writeIntroSeen();
    IntroSignals._complete(true);
    _ticker.stop();
    setState(() => _gone = true);
  }

  void _finish() {
    writeIntroSeen();
    IntroSignals._complete(false);
    setState(() {
      _fading = true;
      _showSkip = false;
    });
    Future<void>.delayed(_fade, () {
      if (!mounted) return;
      _ticker.stop();
      setState(() => _gone = true);
    });
  }

  @override
  void dispose() {
    _skipTimer?.cancel();
    _ticker.dispose();
    _time.dispose();
    _scene.atlas?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_gone) return widget.child;
    final c = context.colors;
    final light = Theme.of(context).brightness == Brightness.light;

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              ignoring: _fading,
              child: AnimatedOpacity(
                opacity: _fading ? 0 : 1,
                duration: _fade,
                curve: Motion.easeOut,
                child: Semantics(
                  label: 'Loading Md. Asad Chowdhury Dipu',
                  liveRegion: true,
                  child: CallbackShortcuts(
                    bindings: {
                      const SingleActivator(LogicalKeyboardKey.escape): _skip,
                    },
                    child: Focus(
                      autofocus: true,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: CustomPaint(
                              painter: _IntroPainter(
                                time: _time,
                                scene: _scene,
                                palette: _Palette.of(c, light),
                              ),
                            ),
                          ),
                          _SkipButton(visible: _showSkip, onTap: _skip),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.visible, required this.onTap});

  final bool visible;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Positioned(
      left: 0,
      right: 0,
      bottom: math.max(28, MediaQuery.paddingOf(context).bottom),
      child: Center(
        child: AnimatedOpacity(
          opacity: visible ? 0.75 : 0,
          duration: const Duration(milliseconds: 400),
          child: IgnorePointer(
            ignoring: !visible,
            child: OutlinedButton(
              onPressed: onTap,
              style: OutlinedButton.styleFrom(
                foregroundColor: c.ink,
                minimumSize: const Size(0, 44),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: const StadiumBorder(),
                side: BorderSide(color: c.line),
                textStyle: const TextStyle(
                  fontFamily: AppType.ui,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.26,
                ),
              ),
              child: const Text('Skip intro'),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _Palette {
  const _Palette({
    required this.bg,
    required this.fg,
    required this.sig,
    required this.navy,
    required this.light,
  });

  factory _Palette.of(AppColors c, bool light) => _Palette(
        bg: c.paper,
        fg: c.ink,
        sig: c.signal,
        // Navy disappears on the dark page, so "mac" takes the ink there.
        navy: light ? LogoMark.navy : c.ink,
        light: light,
      );

  final Color bg, fg, sig, navy;
  final bool light;
  Color get cyan => LogoMark.cyan;

  @override
  bool operator ==(Object other) =>
      other is _Palette &&
      other.bg == bg &&
      other.fg == fg &&
      other.sig == sig &&
      other.navy == navy;

  @override
  int get hashCode => Object.hash(bg, fg, sig, navy);
}

class _IntroPainter extends CustomPainter {
  _IntroPainter({
    required this.time,
    required this.scene,
    required this.palette,
  }) : super(repaint: time);

  final ValueListenable<double> time;
  final _Scene scene;
  final _Palette palette;

  @override
  void paint(Canvas canvas, Size size) =>
      scene.paint(canvas, size, time.value, palette);

  @override
  bool shouldRepaint(_IntroPainter old) =>
      old.palette != palette || old.scene != scene;
}

// ---------------------------------------------------------------------------
// Easing

double _clamp01(double v) => v < 0 ? 0 : (v > 1 ? 1 : v);
double _sm(double t, double a, double b) {
  final x = _clamp01((t - a) / (b - a));
  return x * x * (3 - 2 * x);
}

double _eio(double x) =>
    x < .5 ? 4 * x * x * x : 1 - math.pow(-2 * x + 2, 3) / 2;
double _eout(double x) => 1 - math.pow(1 - x, 3).toDouble();
double _lerp(double a, double b, double x) => a + (b - a) * x;

Offset _bez(Offset a, Offset c, Offset b, double u) {
  final m = 1 - u;
  return a * (m * m) + c * (2 * m * u) + b * (u * u);
}

/// Control point offset sideways by a fraction of the distance travelled.
Offset _swirl(Offset a, Offset b, double k) {
  final d = b - a;
  return (a + b) / 2 + Offset(-d.dy * k, d.dx * k);
}

// ---------------------------------------------------------------------------
// The scene

/// One loose letter of act one.
class _Sprite {
  _Sprite(math.Random r)
      : nx = r.nextDouble(),
        ny = r.nextDouble(),
        z = 0.45 + r.nextDouble() * 0.55,
        ph = r.nextDouble() * 6.28,
        ch = r.nextInt(26),
        d1 = r.nextDouble() * _T.convStagger,
        k1 = 0.28 + r.nextDouble() * 0.22,
        ts = 0.9 + r.nextDouble() * 0.25,
        out = 20 + r.nextDouble() * 40,
        r0 = r.nextDouble() * 6.28 {
    fx = (0.35 + r.nextDouble() * 0.55) * z;
    fy = (0.35 + r.nextDouble() * 0.55) * z;
    ax = (20 + r.nextDouble() * 50) * z;
    ay = (20 + r.nextDouble() * 50) * z;
    vr = (r.nextDouble() * 2 - 1) * z;
    s0 = (14 + r.nextDouble() * 26) * z; // depth: far letters are smaller
    a0 = (0.35 + r.nextDouble() * 0.55) * z; // and dimmer
  }

  final double nx, ny, z, ph, d1, k1, ts, out, r0;
  final int ch;
  late final double fx, fy, ax, ay, vr, s0, a0;

  /// Where it lands, in artboard units, and which half of the mark that is.
  Offset target = Offset.zero;
  bool cyan = false;

  Offset float(double t, Size s) => Offset(
        nx * s.width + math.sin(t * fx + ph) * ax,
        ny * s.height + math.cos(t * fy + ph * 1.3) * ay,
      );
}

/// One letter of the full name.
class _NameChar {
  _NameChar(this.ch, this.line, this.index, this.glyph, math.Random r)
      : dipu = line == 1 && index >= 10,
        rr = (r.nextDouble() * 2 - 1) * 0.6,
        k = (0.12 + r.nextDouble() * 0.18) * (r.nextBool() ? 1 : -1),
        ox = (r.nextDouble() * 2 - 1) * 0.32,
        oy = (r.nextDouble() * 2 - 1) * 0.22;

  final String ch;
  final int line, index;

  /// Index into [LogoMark.glyphs] this letter grows out of, or -1 if it was
  /// sitting behind the mark.
  final int glyph;
  final bool dipu;
  final double rr, k, ox, oy;
  double dep = 0; // when it leaves the mark
  Offset target = Offset.zero; // where it ends, on screen

  /// Its letter in the hero's name, during the handoff, and its place in
  /// reading order there.
  _HeroLetter? hero;
  int order = 0;
}

class _Dust {
  _Dust(math.Random r)
      : nx = r.nextDouble(),
        ny = r.nextDouble(),
        z = 0.3 + r.nextDouble() * 0.7,
        ph = r.nextDouble() * 6.28;
  final double nx, ny, z, ph;
}

class _Scene {
  _Scene() {
    final r = math.Random();
    _sprites = List.generate(800, (_) => _Sprite(r));
    _assignTargets(r);
    _dust = List.generate(60, (_) => _Dust(r));

    // "mac" is Md. Asad Chowdhury: its m, a and c become those initials,
    // "dipu" becomes DIPU, and every other letter slides out from behind.
    const map = {
      (0, 0): 0, (0, 4): 1, //
      (1, 0): 2, (1, 10): 3, (1, 11): 4, (1, 12): 5, (1, 13): 6,
    };
    for (var li = 0; li < _lines.length; li++) {
      final line = _lines[li];
      for (var ci = 0; ci < line.length; ci++) {
        if (line[ci] == ' ') continue;
        _chars.add(_NameChar(line[ci], li, ci, map[(li, ci)] ?? -1, r));
      }
    }
    final hidden = _chars.where((c) => c.glyph < 0).toList()..shuffle(r);
    for (var i = 0; i < hidden.length; i++) {
      hidden[i].dep =
          _T.breakA + 0.08 + i / (hidden.length - 1) * _T.hiddenStagger;
    }
    for (final c in _chars.where((c) => c.glyph >= 0)) {
      c.dep = _T.breakA + c.glyph * 0.06;
    }
  }

  static const _lines = ['MD. ASAD', 'CHOWDHURY DIPU'];
  static const _role = 'FORWARD DEPLOYED ENGINEER';
  static const _cell = 64.0;

  late final List<_Sprite> _sprites;
  late final List<_Dust> _dust;
  final _chars = <_NameChar>[];
  ui.Image? atlas;

  /// Intro time at which the name started flying onto the hero, if it has.
  double? handoffStart;

  /// Pairs every letter of the intro's name with the same letter of the
  /// hero's three lines. "CHOWDHURY DIPU" splits over the hero's last two.
  bool attachHero(List<List<_HeroLetter>> lines) {
    if (lines.length != 3) return false;
    var order = 0;
    for (final c in _chars) {
      final (line, index) = switch (c.line) {
        0 => (0, c.index),
        _ when c.index <= 8 => (1, c.index),
        _ => (2, c.index - 10),
      };
      if (index >= lines[line].length) return false;
      final h = lines[line][index];
      if (h.ch.toUpperCase() != c.ch) return false;
      c
        ..hero = h
        ..order = order++;
    }
    return true;
  }

  /// The 26 capitals, white, in one strip. Tinted per sprite when drawn.
  static Future<ui.Image> buildAtlas() {
    final rec = ui.PictureRecorder();
    final canvas = Canvas(rec);
    for (var i = 0; i < 26; i++) {
      final tp = TextPainter(
        text: TextSpan(
          text: String.fromCharCode(65 + i),
          style: const TextStyle(
            fontFamily: AppType.ui,
            fontSize: 46,
            fontWeight: FontWeight.w800,
            height: 1,
            color: Colors.white,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(
        canvas,
        Offset(i * _cell + (_cell - tp.width) / 2, (_cell - tp.height) / 2),
      );
    }
    return rec.endRecording().toImage((26 * _cell).toInt(), _cell.toInt());
  }

  /// Spread the sprites over the inside of the mark, evenly by area.
  void _assignTargets(math.Random r) {
    List<Offset> sample(Path p) {
      final b = p.getBounds();
      final pts = <Offset>[];
      const step = 2.6;
      for (var y = b.top; y <= b.bottom; y += step) {
        for (var x = b.left; x <= b.right; x += step) {
          final o = Offset(x, y);
          if (p.contains(o)) pts.add(o);
        }
      }
      return pts..shuffle(r);
    }

    final mac = sample(LogoMark.macPath);
    final dipu = sample(
      Path.from(LogoMark.dipuPath)
        ..addOval(Rect.fromCircle(
            center: LogoMark.iDot, radius: LogoMark.iDotRadius)),
    );
    final n = _sprites.length;
    final macN = (n * mac.length / math.max(1, mac.length + dipu.length)).round();
    for (var k = 0; k < n; k++) {
      final cyan = k >= macN;
      final pts = cyan ? dipu : mac;
      final i = cyan ? k - macN : k;
      _sprites[k]
        ..cyan = cyan
        ..target = pts.isEmpty ? LogoMark.bounds.center : pts[i % pts.length];
    }
  }

  // ---- Per-size layout ----
  Size? _laidOut;
  double _fs = 100, _subSize = 14, _subY = 0, _ruleY = 0;
  double _scale = 1; // artboard → screen
  Offset _center = Offset.zero;

  TextPainter _text(String s, double fs, {Color color = Colors.white}) =>
      TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(
            fontFamily: AppType.ui,
            fontSize: fs,
            fontWeight: FontWeight.w800,
            height: 1,
            color: color,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  void _layout(Size size) {
    if (size == _laidOut) return;
    _laidOut = size;
    final w = size.width, h = size.height;
    _scale = math.min(w * 0.78, 620) / LogoMark.bounds.width;
    _center = Offset(w / 2, h / 2);

    final widest = _lines
        .map((l) => _text(l, 100).width)
        .reduce(math.max);
    _fs = math.min(math.min(w * 0.115, 124), (w * 0.86) / (widest / 100));
    final lh = _fs * 1.08;
    final top = h / 2 - _fs * 0.22 - lh / 2;
    final painters = [for (final l in _lines) _text(l, _fs)];
    for (final c in _chars) {
      final tp = painters[c.line];
      final x0 = w / 2 - tp.width / 2;
      final a = tp.getOffsetForCaret(TextPosition(offset: c.index), Rect.zero).dx;
      final b = tp
          .getOffsetForCaret(TextPosition(offset: c.index + 1), Rect.zero)
          .dx;
      c.target = Offset(x0 + (a + b) / 2, top + c.line * lh);
    }
    _subSize = (_fs * 0.19).clamp(14.0, 24.0);
    _subY = top + lh * 1.5 + _fs * 0.42;
    _ruleY = _subY - _subSize * 1.9;
  }

  /// The mark gathers itself before it breaks.
  double _squeeze(double t) =>
      1 -
      0.035 * _sm(t, _T.squeezeA, _T.squeezeB) +
      0.035 * _sm(t, _T.breakA, _T.breakA + 0.25);

  /// Where a point of the artboard sits on screen at time [t].
  Offset _toScreen(Offset p, double t, {bool squeeze = true}) =>
      _center +
      (p - LogoMark.bounds.center) * (_scale * (squeeze ? _squeeze(t) : 1));

  // ---- Paint ----
  void paint(Canvas canvas, Size size, double now, _Palette pal) {
    if (size.isEmpty) return;
    _layout(size);
    final t = math.min(now, _T.end);
    final hs = handoffStart;
    if (hs != null) {
      _paintHandoff(canvas, size, t, now - hs, pal);
      return;
    }
    canvas.drawRect(Offset.zero & size, Paint()..color = pal.bg);
    _paintDust(canvas, size, t, pal);
    _paintHalo(canvas, t, pal);
    _paintSprites(canvas, size, t, pal);
    // Order matters: hidden letters first, so the mark covers them until they
    // slide out from under it.
    for (final c in _chars) {
      if (c.glyph < 0) _paintChar(canvas, c, t, pal);
    }
    _paintSwoosh(canvas, t, pal);
    for (final c in _chars) {
      if (c.glyph >= 0) _paintChar(canvas, c, t, pal);
    }
    _paintRole(canvas, size, _sm(t, _T.subA, _T.subB), pal);
  }

  /// The intro's name flies onto the hero's name while the page shows
  /// through: each capital eases to its letter there, turning into the
  /// hero's own glyph (and case) on the way, one beat after the last.
  void _paintHandoff(
      Canvas canvas, Size size, double t, double h, _Palette pal) {
    final bg = 1 - _sm(h, 0.15, 0.8);
    canvas.drawRect(
        Offset.zero & size, Paint()..color = pal.bg.withValues(alpha: bg));
    _paintDust(canvas, size, t, pal, fade: bg);
    _paintRole(canvas, size, 1 - _sm(h, 0, 0.35), pal);
    final glow = _sm(t, _T.settleA, _T.settleB) * (1 - _sm(h, 0, 0.4));

    for (final c in _chars) {
      final hero = c.hero!;
      final u = _clamp01((h - c.order * _T.handStagger) / _T.handFly);
      final e = _eio(u);
      final p = _bez(c.target, _swirl(c.target, hero.center, c.k * 0.35),
          hero.center, e);
      final ratio = (hero.style.fontSize ?? _fs) / _fs;
      final cross = _sm(u, 0.3, 0.75);
      final rot = math.sin(math.pi * e) * c.rr * 0.25;
      _paintLetter(canvas, c, p, _lerp(1, ratio, e), rot, 1 - cross, glow, pal);

      if (cross <= 0.002) continue;
      final from = c.dipu ? pal.cyan : pal.fg;
      final to = hero.style.color ?? pal.fg;
      final tp = TextPainter(
        text: TextSpan(
          text: hero.ch,
          style: hero.style.copyWith(
            color: Color.lerp(from, to, _sm(u, 0.4, 1))!
                .withValues(alpha: cross),
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      canvas.save();
      canvas.translate(p.dx, p.dy);
      canvas.rotate(rot);
      canvas.scale(_lerp(1 / ratio, 1, e));
      tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
      canvas.restore();
    }
  }

  void _paintDust(Canvas canvas, Size size, double t, _Palette pal,
      {double fade = 1}) {
    final paint = Paint();
    for (final d in _dust) {
      final x = d.nx * size.width + math.sin(t * .15 * d.z + d.ph) * 40 * d.z;
      final y = (d.ny * size.height + t * 6 * d.z) % size.height;
      paint.color = (pal.light ? pal.sig : pal.fg)
          .withValues(alpha: (pal.light ? .10 : .16) * d.z * fade);
      canvas.drawCircle(Offset(x, y), 1.6 * d.z, paint);
    }
  }

  /// A soft halo behind the mark while it holds.
  void _paintHalo(Canvas canvas, double t, _Palette pal) {
    final a = _sm(t, 0.8, 1.8) * (1 - _sm(t, _T.breakA, _T.breakA + 0.6));
    if (a <= 0.002) return;
    final r = LogoMark.bounds.width * _scale * 0.6;
    final inner = (pal.light ? LogoMark.cyan : pal.sig)
        .withValues(alpha: (pal.light ? 0.10 : 0.14) * a * (0.85 + 0.15 * math.sin(t * 3)));
    canvas.drawCircle(
      _center,
      r,
      Paint()
        ..shader = ui.Gradient.radial(
            _center, r, [inner, inner.withValues(alpha: 0)]),
    );
  }

  void _paintSprites(Canvas canvas, Size size, double t, _Palette pal) {
    final img = atlas;
    if (img == null) return;
    final under = 1 - 0.72 * _sm(t, _T.logoA, _T.logoA + 0.7); // the crisp mark takes over
    final gone = _sm(t, _T.breakA - 0.05, _T.breakA + 0.5); // the mosaic lets go
    if (gone >= 1) return;
    final tsz = (_scale * 13).clamp(5.0, 13.0);
    final k = _squeeze(t);

    final transforms = <RSTransform>[];
    final rects = <Rect>[];
    final colors = <Color>[];
    for (final s in _sprites) {
      final tStart = _T.convA + s.d1;
      final rStart = s.r0 + s.vr * tStart;
      Offset p;
      double r, size0, a;
      if (t < tStart) {
        p = s.float(t, size);
        r = s.r0 + s.vr * t;
        size0 = s.s0;
        a = s.a0 * _sm(t, 0, 0.25);
      } else {
        final e = _eio(_clamp01((t - tStart) / _T.convDur));
        final st = s.float(tStart, size);
        final target = _toScreen(s.target, t, squeeze: false);
        p = _bez(st, _swirl(st, target, s.k1), target, e);
        // Settle upright, the short way round.
        r = _lerp(rStart, math.pi * 2 * (rStart / (math.pi * 2)).roundToDouble(), e);
        size0 = _lerp(s.s0, tsz * s.ts, e);
        a = _lerp(s.a0, 1, e);
      }
      if (gone > 0) {
        final d = p - _center;
        final len = d.distance == 0 ? 1 : d.distance;
        p += d / len.toDouble() * s.out * gone;
      }
      a *= under * (1 - gone);
      if (a <= 0.01) continue;
      p = _center + (p - _center) * k;
      transforms.add(RSTransform.fromComponents(
        rotation: r,
        scale: size0 / _cell,
        anchorX: _cell / 2,
        anchorY: _cell / 2,
        translateX: p.dx,
        translateY: p.dy,
      ));
      rects.add(Rect.fromLTWH(s.ch * _cell, 0, _cell, _cell));
      colors.add((s.cyan ? pal.cyan : pal.navy).withValues(alpha: a));
    }
    if (transforms.isEmpty) return;
    canvas.drawAtlas(img, transforms, rects, colors, BlendMode.modulate, null,
        Paint()..filterQuality = FilterQuality.medium);
  }

  void _paintSwoosh(Canvas canvas, double t, _Palette pal) {
    final intro = _sm(t, _T.swA, _T.swB);
    final out = _sm(t, _T.breakA, _T.breakA + 0.45);
    if (intro <= 0 || out >= 1) return;
    final k = _scale * _squeeze(t);
    final bc = LogoMark.bounds.center;
    canvas.save();
    canvas.translate(_center.dx, _center.dy + out * 14);
    canvas.scale(k);
    canvas.translate(-bc.dx, -bc.dy);
    canvas.clipRect(Rect.fromLTWH(420, 160, 380 * intro, 70)); // left to right
    canvas.drawPath(
      LogoMark.swoosh,
      Paint()..color = pal.cyan.withValues(alpha: 1 - out),
    );
    canvas.restore();
  }

  void _paintGlyph(Canvas canvas, int g, Offset p, double scale, double rot,
      double alpha, _Palette pal) {
    if (alpha <= 0.002) return;
    final glyph = LogoMark.glyphs[g];
    canvas.save();
    canvas.translate(p.dx, p.dy);
    canvas.rotate(rot);
    canvas.scale(scale);
    canvas.translate(-glyph.center.dx, -glyph.center.dy);
    canvas.drawPath(
      glyph.path,
      Paint()
        ..color = (glyph.cyan ? pal.cyan : pal.navy)
            .withValues(alpha: _clamp01(alpha)),
    );
    canvas.restore();
  }

  void _paintLetter(Canvas canvas, _NameChar c, Offset p, double scale,
      double rot, double alpha, double settle, _Palette pal) {
    if (alpha <= 0.002) return;
    final color = (c.dipu ? pal.cyan : pal.fg).withValues(alpha: _clamp01(alpha));
    final shadows = settle <= 0
        ? null
        : pal.light
            ? [
                Shadow(
                  color: const Color(0xFF081230).withValues(alpha: 0.2 * settle),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : [
                Shadow(
                  color: (c.dipu ? pal.cyan : pal.sig).withValues(alpha: settle),
                  blurRadius: 12 * settle,
                ),
              ];
    final tp = TextPainter(
      text: TextSpan(
        text: c.ch,
        style: TextStyle(
          fontFamily: AppType.ui,
          fontSize: _fs,
          fontWeight: FontWeight.w800,
          height: 1,
          color: color,
          shadows: shadows,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    canvas.save();
    canvas.translate(p.dx, p.dy);
    canvas.rotate(rot);
    canvas.scale(scale);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  void _paintChar(Canvas canvas, _NameChar c, double t, _Palette pal) {
    final u = _clamp01((t - c.dep) / _T.fly);
    final e = _eio(u);
    final settle = _sm(t, _T.settleA, _T.settleB);
    final rot = math.sin(math.pi * e) * c.rr;

    if (c.glyph >= 0) {
      final g = LogoMark.glyphs[c.glyph];
      if (u <= 0) {
        // Still part of the mark: it sharpens in over the mosaic.
        final ui = _eout(_clamp01(
            (t - _T.logoA - c.glyph * _T.logoStagger) / _T.logoDur));
        _paintGlyph(canvas, c.glyph, _toScreen(g.center, t),
            _scale * _squeeze(t) * _lerp(1.06, 1, ui), 0, ui, pal);
        return;
      }
      final start = _toScreen(g.center, c.dep);
      final capH = _fs * 0.72;
      final p = _bez(start, _swirl(start, c.target, c.k), c.target, e);
      // The glyph hands over to the capital mid-flight.
      final hand = _sm(u, 0.25, 0.65);
      _paintGlyph(canvas, c.glyph, p, _lerp(_scale, capH / g.height, e), rot,
          1 - hand, pal);
      _paintLetter(canvas, c, p, _lerp(g.height * _scale / capH, 1, e), rot,
          hand, settle, pal);
    } else {
      if (u <= 0) return;
      final b = LogoMark.bounds;
      final start = _toScreen(
          b.center + Offset(c.ox * b.width, c.oy * b.height), c.dep);
      final p = _bez(start, _swirl(start, c.target, c.k * 1.6), c.target, e);
      _paintLetter(canvas, c, p, _lerp(0.35, 1, e), rot * 1.4,
          _sm(u, 0, 0.3), settle, pal);
    }
  }

  void _paintRole(Canvas canvas, Size size, double alpha, _Palette pal) {
    if (alpha <= 0.002) return;
    final w = size.width;
    final rw = math.min(w * 0.18, 120) * alpha;
    canvas.drawRect(
      Rect.fromLTWH(w / 2 - rw / 2, _ruleY, rw, 3),
      Paint()..color = pal.cyan.withValues(alpha: _clamp01(alpha * 1.2)),
    );
    final fs = _subSize * 1.05;
    final tp = TextPainter(
      text: TextSpan(
        text: _role,
        style: TextStyle(
          fontFamily: AppType.ui,
          fontSize: fs,
          fontWeight: FontWeight.w600,
          letterSpacing: fs * 0.18,
          height: 1,
          color: (pal.light ? pal.sig : pal.fg)
              .withValues(alpha: alpha * (pal.light ? 0.95 : 0.85)),
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    // Tracking adds space after the last letter too; centre on the ink.
    final inkW = tp.width - fs * 0.18;
    tp.paint(canvas,
        Offset(w / 2 - inkW / 2, _subY + (1 - alpha) * 6 - tp.height / 2));
  }
}
