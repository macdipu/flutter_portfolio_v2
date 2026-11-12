import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/deferred_fonts.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/motion/scroll_scope.dart';
import '../../../../core/motion/tilt.dart';
import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/utils/launch.dart';
import '../../../intro/intro_gate.dart';
import '../../../../core/widgets/logo_mark.dart';
import '../../../../core/widgets/ui.dart';

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _precached = false;

  /// While the intro plays the hero is laid out but invisible, so the
  /// intro's letters can land on its name; its entrance plays afterwards.
  _HeroPhase _phase = kIsWeb ? _HeroPhase.waiting : _HeroPhase.plain;

  @override
  void initState() {
    super.initState();
    IntroSignals.finished.then((landed) {
      if (mounted) {
        setState(
            () => _phase = landed ? _HeroPhase.landed : _HeroPhase.plain);
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    // Decode what the first frame shows, then tell the intro we're ready.
    Future.wait([
      // What the first seconds show: the first screens of the montage and
      // the portrait it ends on.
      for (final a in [Profile.avatar, ..._montage.take(3)])
        precacheImage(AssetImage(a), context),
      DeferredFonts.pending, // started in main()
    ]).whenComplete(IntroSignals.markReady);
    // The montage images load in the background; they are not needed for ready.
    for (final a in _montage) {
      precacheImage(AssetImage(a), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= 900;
    final minHeight = (size.height - 64).clamp(620.0, 1100.0);
    final waiting = _phase == _HeroPhase.waiting;
    final text = _HeroText(phase: _phase);
    const stage = _HeroStage();

    // A new subtree per phase, so every entrance starts once the intro is gone.
    final hero = ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: EdgeInsets.only(
          top: 64 + fluid(context, 16, 40),
          bottom: fluid(context, 24, 48),
        ),
        child: Frame(
          child: wide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: text),
                    const SizedBox(width: Space.xl),
                    Expanded(
                      flex: 6,
                      child: waiting ? const SizedBox.shrink() : stage,
                    ),
                  ],
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    text,
                    const SizedBox(height: Space.xl),
                    if (!waiting) stage,
                  ],
                ),
        ),
      ),
    );
    return KeyedSubtree(
      key: ValueKey(_phase),
      child: waiting ? Opacity(opacity: 0, child: hero) : hero,
    );
  }
}

enum _HeroPhase {
  /// The intro is playing: laid out, invisible, nothing animating.
  waiting,

  /// The intro's letters landed on the name: show it at once, animate the rest.
  landed,

  /// No intro handed over (not web, or it fell back to a fade): animate all.
  plain,
}

class _HeroText extends StatelessWidget {
  const _HeroText({required this.phase});

  final _HeroPhase phase;

  static const _lines = ['Md. Asad', 'Chowdhury', 'Dipu'];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScrollCubit>();
    final reduced = Motion.reduced(context);
    final nameStyle = AppType.display(context).copyWith(
      fontSize: fluid(context, 52, 104),
      letterSpacing: -fluid(context, 1.6, 3.6),
    );

    final waiting = phase == _HeroPhase.waiting;
    // While waiting nothing is wrapped in a Reveal, so positions are final
    // and nothing plays its entrance behind the intro.
    Widget reveal(Widget child, int step, [RevealKind kind = RevealKind.rise]) =>
        waiting
            ? child
            : Reveal(kind: kind, delay: Motion.stagger * step, child: child);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Availability(),
        const SizedBox(height: Space.l),
        for (var i = 0; i < _lines.length; i++)
          switch (phase) {
            // The intro's letters measure these lines, then land on them.
            _HeroPhase.waiting => Text(_lines[i],
                key: IntroSignals.heroNameKeys[i], style: nameStyle),
            _HeroPhase.landed => Semantics(
                header: i == 0,
                child: Text(_lines[i], style: nameStyle),
              ),
            _HeroPhase.plain => Reveal(
                kind: RevealKind.mask,
                delay: Motion.stagger * (i + 1),
                child: Semantics(
                  header: i == 0,
                  child: Text(_lines[i], style: nameStyle),
                ),
              ),
          },
        SizedBox(height: fluid(context, 20, 32)),
        reveal(Text('${Profile.role}.', style: AppType.h2(context)), 4),
        const SizedBox(height: Space.m),
        reveal(
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(Profile.intro, style: AppType.lead(context)),
          ),
          5,
        ),
        const SizedBox(height: Space.l),
        reveal(
          const Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [
              PlatformBadge(Platform.mobile),
              PlatformBadge(Platform.desktop),
              PlatformBadge(Platform.web),
              PlatformBadge(Platform.fullStack),
            ],
          ),
          6,
        ),
        SizedBox(height: fluid(context, 24, 36)),
        reveal(
          Wrap(
            spacing: Space.m,
            runSpacing: Space.m,
            children: [
              AppButton(
                label: 'See projects',
                primary: true,
                icon: Icons.arrow_downward,
                onTap: () => cubit.scrollTo(NavigationSection.projects,
                    reduced: reduced),
              ),
              AppButton(
                label: 'Email me',
                icon: Icons.mail_outline,
                onTap: () => openUrl('mailto:${AppLinks.email}'),
              ),
            ],
          ),
          7,
        ),
      ],
    );
  }
}

class _Availability extends StatefulWidget {
  const _Availability();

  @override
  State<_Availability> createState() => _AvailabilityState();
}

class _AvailabilityState extends State<_Availability>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!Motion.reduced(context) && !_c.isAnimating && _c.value == 0) {
      _c.forward(); // pulses once, never loops
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Reveal(
      kind: RevealKind.fade,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 18,
            height: 18,
            child: AnimatedBuilder(
              animation: _c,
              builder: (context, _) =>
                  CustomPaint(painter: _DotPainter(c.live, _c.value)),
            ),
          ),
          const SizedBox(width: Space.s),
          Text('Available for work', style: AppType.caption(context)),
        ],
      ),
    );
  }
}

class _DotPainter extends CustomPainter {
  _DotPainter(this.color, this.t);
  final Color color;
  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    canvas.drawCircle(center, 4, Paint()..color = color);
    if (t > 0 && t < 1) {
      canvas.drawCircle(
        center,
        4 + 5 * t,
        Paint()..color = color.withValues(alpha: 0.5 * (1 - t)),
      );
    }
  }

  @override
  bool shouldRepaint(_DotPainter old) => old.t != t || old.color != color;
}

/// The hero's right side. On first show it plays a quick montage: screens
/// slam in one on top of another, flash, and break away as the portrait
/// settles into place. After that it leans toward the pointer, and the whole
/// stage tips back and recedes as the page scrolls.
class _HeroStage extends StatefulWidget {
  const _HeroStage();

  @override
  State<_HeroStage> createState() => _HeroStageState();
}

class _HeroStageState extends State<_HeroStage>
    with SingleTickerProviderStateMixin {
  static const _introSeconds = 2.7; // must cover _Stage._settleB

  late final AnimationController _intro = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: (_introSeconds * 1000).round()),
  );
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_started) return;
    _started = true;
    if (Motion.reduced(context)) {
      _intro.value = 1;
    } else {
      _intro.forward();
    }
  }

  @override
  void dispose() {
    _intro.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final s = box.maxWidth.clamp(280.0, 680.0);
      return Center(
        child: SizedBox(
          width: s,
          height: s * 0.92,
          child: PointerTilt(
            builder: (context, tilt) => ScrollLinked(
              builder: (context, offset, _) {
                final vh = MediaQuery.sizeOf(context).height;
                final t = (offset / vh).clamp(0.0, 1.0);
                return AnimatedBuilder(
                  animation: _intro,
                  builder: (context, _) => _Stage(
                    size: s,
                    tilt: tilt,
                    scrollT: t,
                    introT: _intro.value * _introSeconds,
                  ),
                );
              },
            ),
          ),
        ),
      );
    });
  }
}

/// Screens used in the stacking montage, in landing order.
const _montage = <String>[
  'assets/images/projects/shell-agami-home.webp',
  'assets/images/projects/openreader-desktop.png',
  'assets/images/projects/md-01-home.jpg',
  'assets/images/projects/motul-home.webp',
  'assets/images/projects/gitswitch-accounts.png',
  'assets/images/projects/wt-today.webp',
  'assets/images/projects/astro-home.webp',
  'assets/images/projects/bmi-input.webp',
  'assets/images/projects/reward-home.webp',
  'assets/images/projects/shell-consumer-home.webp',
];

// Fixed "random" pile: tilt (radians) and offset (fractions of the stage).
const _pileRot = [
  0.10,
  -0.18,
  0.26,
  -0.08,
  0.20,
  -0.28,
  0.06,
  -0.14,
  0.23,
  -0.04
];
const _pileDx = [-0.05, 0.06, -0.02, 0.04, -0.07, 0.03, 0.07, -0.04, 0.02, 0.0];
const _pileDy = [0.03, -0.04, 0.05, -0.02, 0.0, 0.04, -0.05, 0.02, -0.03, 0.0];

class _Stage extends StatelessWidget {
  const _Stage({
    required this.size,
    required this.tilt,
    required this.scrollT,
    required this.introT,
  });

  final double size;
  final Offset tilt;
  final double scrollT;

  /// Seconds into the intro montage.
  final double introT;

  static const _landEvery = 0.13; // a new screen lands this often
  static const _landFor = 0.4; // and takes this long to land
  static const _photoAt = 1.3; // the photo lands last, on top of the pile
  static const _flashAt = 1.62; // as it hits
  static const _breakA = 1.75; // the projects fly off behind it
  static const _breakB = 2.35;
  static const _settleB = 2.6; // the photo has grown into its resting pose

  // The photo's resting pose, leaning left. The stage itself is turned by
  // -0.24 about Y (see build), so +0.42 here nets a mirrored +0.18.
  static const _poseX = -0.16, _poseY = 0.42, _poseZ = 0.05;

  double _sm(double a, double b) {
    final x = ((introT - a) / (b - a)).clamp(0.0, 1.0);
    return x * x * (3 - 2 * x);
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;

  Widget _card(BuildContext context, int i) {
    final c = context.colors;
    final p = ((introT - i * _landEvery) / _landFor).clamp(0.0, 1.0);
    if (p <= 0) return const SizedBox.shrink();
    final e = Curves.easeOutCubic.transform(p);
    final away = _sm(_breakA, _breakB);
    final side = i.isEven ? 1.0 : -1.0;
    final cw = size * 0.46;
    final ch = size * 0.58;
    return Positioned(
      left: size * 0.5 - cw / 2,
      top: size * 0.46 - ch / 2,
      child: Opacity(
        opacity: (p * 4).clamp(0.0, 1.0) * (1 - away),
        child: Transform(
          alignment: Alignment.center,
          transform: perspective(
            rotateY: (1 - e) * 0.75 * side,
            rotateX: (1 - e) * -0.25,
            rotateZ: _pileRot[i] * e + side * away * 0.5,
            dx: _pileDx[i] * size * e + side * away * size * 0.55,
            dy: _pileDy[i] * size * e - away * size * 0.12,
            scale: (1.7 - 0.7 * e) * (1 + 0.2 * away),
          ),
          child: Container(
            width: cw,
            height: ch,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(color: c.line),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: AppImage(_montage[i % _montage.length], cacheWidth: 520),
          ),
        ),
      ),
    );
  }

  /// The last card to land is the photo. It stays while the projects fly
  /// off, grows to full size and turns toward the upper left.
  Widget _photo() {
    final p = ((introT - _photoAt) / _landFor).clamp(0.0, 1.0);
    if (p <= 0) return const SizedBox.shrink();
    final e = Curves.easeOutCubic.transform(p);
    final q = Curves.easeInOutCubic
        .transform(((introT - _breakA) / (_settleB - _breakA)).clamp(0.0, 1.0));
    final w = size * _lerp(0.46, 0.6, q);
    final h = size * _lerp(0.58, 0.8, q);
    final cy = size * _lerp(0.46, 0.45, q);
    return Positioned(
      left: size * 0.5 - w / 2,
      top: cy - h / 2,
      child: Opacity(
        opacity: (p * 4).clamp(0.0, 1.0),
        child: Transform(
          alignment: Alignment.center,
          transform: perspective(
            rotateY: (1 - e) * -0.75 + q * _poseY,
            rotateX: (1 - e) * -0.25 + q * _poseX,
            rotateZ: q * _poseZ,
            scale: 1.7 - 0.7 * e,
          ),
          child: _Portrait(
            width: w,
            height: h,
            interactive: introT >= _settleB,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final master = perspective(
      rotateX: 0.10 - tilt.dy * 0.07 + scrollT * 0.32,
      rotateY: -0.24 + tilt.dx * 0.12,
      dy: scrollT * 70,
      scale: 1 - scrollT * 0.14,
    );
    final montage = introT < _breakB + 0.1;
    final flash = (1 - (introT - _flashAt).abs() / 0.22).clamp(0.0, 1.0);

    return Opacity(
      opacity: (1 - scrollT * 0.7).clamp(0.0, 1.0),
      child: Transform(
        alignment: Alignment.center,
        transform: master,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            if (montage)
              for (var i = 0; i < _montage.length; i++) _card(context, i),
            _photo(),
            if (flash > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: flash * 0.6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            // A white flash on dark; an accent flash on light.
                            dark
                                ? Colors.white
                                : c.signal.withValues(alpha: 0.7),
                            c.signal.withValues(alpha: 0.45),
                            Colors.transparent,
                          ],
                          stops: const [0, 0.35, 1],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// The portrait card: soft cyan rim and glow, the macdipu tag on its corner.
///
/// Once the montage has settled, hovering lifts it toward the pointer: the
/// card tips after the cursor, a glare follows it, the photo zooms with a
/// little parallax, the rim and glow brighten and the tag pops out to read
/// "Hi! I'm macdipu".
class _Portrait extends StatefulWidget {
  const _Portrait({
    required this.width,
    required this.height,
    required this.interactive,
  });

  final double width;
  final double height;
  final bool interactive;

  @override
  State<_Portrait> createState() => _PortraitState();
}

class _PortraitState extends State<_Portrait> {
  bool _hover = false;
  Offset _pos = const Offset(0.5, 0.5); // pointer, 0..1 over the card

  @override
  Widget build(BuildContext context) {
    final on = widget.interactive && _hover && !Motion.reduced(context);
    return MouseRegion(
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() {
        _hover = false;
        _pos = const Offset(0.5, 0.5);
      }),
      onHover: (e) => setState(() => _pos = Offset(
            (e.localPosition.dx / widget.width).clamp(0.0, 1.0),
            (e.localPosition.dy / widget.height).clamp(0.0, 1.0),
          )),
      child: TweenAnimationBuilder<double>(
        tween: Tween(end: on ? 1 : 0),
        duration: const Duration(milliseconds: 420),
        curve: Motion.easeOut,
        builder: (context, hv, _) => TweenAnimationBuilder<Offset>(
          tween: Tween(end: on ? _pos : const Offset(0.5, 0.5)),
          duration: const Duration(milliseconds: 220),
          curve: Motion.easeOut,
          builder: (context, pos, _) => _card(context, hv, pos),
        ),
      ),
    );
  }

  Widget _card(BuildContext context, double hv, Offset pos) {
    final c = context.colors;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final w = widget.width, h = widget.height;
    final radius = BorderRadius.circular(w * 0.08);
    final lean = (pos - const Offset(0.5, 0.5)) * 2; // -1..1

    return Transform(
      alignment: Alignment.center,
      transform: perspective(
        rotateX: -lean.dy * 0.16 * hv,
        rotateY: lean.dx * 0.16 * hv,
        dy: -12 * hv,
        scale: 1 + 0.05 * hv,
      ),
      child: SizedBox(
        width: w,
        height: h,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // Glow behind the card; stronger on hover.
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: radius,
                  boxShadow: [
                    BoxShadow(
                      color: LogoMark.cyan.withValues(
                          alpha: (dark ? 0.28 : 0.22) + 0.3 * hv),
                      blurRadius: 60 + 30 * hv,
                      spreadRadius: -6 + 4 * hv,
                    ),
                    BoxShadow(
                      color: Colors.black.withValues(alpha: dark ? 0.5 : 0.18),
                      blurRadius: 30 + 20 * hv,
                      offset: Offset(0, 18 + 14 * hv),
                    ),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: ClipRRect(
                borderRadius: radius,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Solid backing: never see-through, even mid-decode.
                    ColoredBox(color: c.surface),
                    // The photo zooms in and drifts against the pointer.
                    Transform.translate(
                      offset: -lean * (w * 0.02) * hv,
                      child: Transform.scale(
                        scale: 1 + 0.08 * hv,
                        // Same image the hero precaches, so it is ready the
                        // moment the card lands.
                        child: Image.asset(
                          Profile.avatar,
                          fit: BoxFit.cover,
                          alignment: const Alignment(0, -0.2),
                          gaplessPlayback: true,
                          semanticLabel: 'Photo of ${Profile.name}',
                        ),
                      ),
                    ),
                    // Settles the grey studio backdrop into the page.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            c.paper.withValues(alpha: 0.35 * (1 - hv * 0.5)),
                          ],
                          stops: const [0.65, 1],
                        ),
                      ),
                    ),
                    // Glare that follows the pointer.
                    if (hv > 0.01)
                      DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(lean.dx, lean.dy),
                            radius: 0.9,
                            colors: [
                              Colors.white.withValues(alpha: 0.22 * hv),
                              Colors.white.withValues(alpha: 0),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Rim.
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    borderRadius: radius,
                    border: Border.all(
                      color: LogoMark.cyan.withValues(alpha: 0.45 + 0.5 * hv),
                      width: 1.5 + 0.8 * hv,
                    ),
                  ),
                ),
              ),
            ),
            // The tag, over the bottom-left corner; pops and says hello.
            Positioned(
              left: -w * (0.06 + 0.03 * hv),
              bottom: h * 0.07 + 6 * hv,
              child: Transform.scale(
                scale: 1 + 0.08 * hv,
                alignment: Alignment.centerLeft,
                child: _Tag(width: w, hv: hv, dark: dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.width, required this.hv, required this.dark});

  final double width;
  final double hv;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final markH = width * 0.075;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: width * 0.045,
        vertical: width * 0.03,
      ),
      decoration: BoxDecoration(
        color: dark ? c.surface : Colors.white,
        borderRadius: BorderRadius.circular(Radii.pill),
        border: Border.all(
          color: Color.lerp(c.line, LogoMark.cyan, hv)!,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.4 : 0.12),
            blurRadius: 18 + 10 * hv,
            offset: Offset(0, 8 + 4 * hv),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // On hover the tag reads "Hi! I'm macdipu": the greeting slides
          // out in front of the mark.
          ClipRect(
            child: Align(
              alignment: Alignment.centerRight,
              widthFactor: hv,
              child: Opacity(
                opacity: hv,
                child: Padding(
                  padding: EdgeInsets.only(right: width * 0.03),
                  child: Text(
                    'Hi! I’m',
                    style: AppType.ui14(context).copyWith(
                      fontSize: (markH * 0.62).clamp(11.0, 16.0),
                      fontWeight: FontWeight.w700,
                      color: c.ink,
                    ),
                  ),
                ),
              ),
            ),
          ),
          CustomPaint(
            size: Size(markH * LogoMark.aspect, markH),
            painter: LogoMarkPainter(
              macColor: dark ? c.ink : LogoMark.navy,
              dipuColor: LogoMark.cyan,
              lift: hv,
            ),
          ),
        ],
      ),
    );
  }
}
