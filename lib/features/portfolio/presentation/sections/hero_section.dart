import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/motion/scroll_scope.dart';
import '../../../../core/motion/tilt.dart';
import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/utils/launch.dart';
import '../../../../core/web/ready_signal.dart';
import '../../../../core/widgets/devices.dart';
import '../../../../core/widgets/ui.dart';

const _desktopShot = Shot('assets/images/projects/openreader-desktop.png',
    ShotKind.desktop, 'OpenReader on Windows');
const _browserShot = Shot('assets/images/projects/gitswitch-accounts.png',
    ShotKind.browser, 'GitSwitch accounts screen');
const _phoneShot = Shot('assets/images/projects/shell-consumer-home.webp',
    ShotKind.phone, 'Shell Consumer home screen');

class HeroSection extends StatefulWidget {
  const HeroSection({super.key});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection> {
  bool _precached = false;

  /// The hero holds back until the HTML intro has faded, so its entrance is
  /// seen and not played out behind the loader.
  bool _go = false;

  @override
  void initState() {
    super.initState();
    introFinished().then((_) {
      if (mounted) setState(() => _go = true);
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_precached) return;
    _precached = true;
    // Decode what the first frame shows, then tell the HTML loader we're ready.
    Future.wait([
      for (final s in [_desktopShot, _browserShot, _phoneShot])
        precacheImage(AssetImage(s.asset), context),
    ]).whenComplete(signalPortfolioReady);
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
    if (!_go) return SizedBox(height: minHeight);

    return ConstrainedBox(
      constraints: BoxConstraints(minHeight: minHeight),
      child: Padding(
        padding: EdgeInsets.only(
          top: 64 + fluid(context, 16, 40),
          bottom: fluid(context, 24, 48),
        ),
        child: Frame(
          child: wide
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 6, child: _HeroText()),
                    SizedBox(width: Space.xl),
                    Expanded(flex: 6, child: _HeroStage()),
                  ],
                )
              : const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _HeroText(),
                    SizedBox(height: Space.xl),
                    _HeroStage(),
                  ],
                ),
        ),
      ),
    );
  }
}

class _HeroText extends StatelessWidget {
  const _HeroText();

  static const _lines = ['Md. Asad', 'Chowdhury', 'Dipu'];

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScrollCubit>();
    final reduced = Motion.reduced(context);
    final nameStyle = AppType.display(context).copyWith(
      fontSize: fluid(context, 52, 104),
      letterSpacing: -fluid(context, 1.6, 3.6),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const _Availability(),
        const SizedBox(height: Space.l),
        for (var i = 0; i < _lines.length; i++)
          Reveal(
            kind: RevealKind.mask,
            delay: Motion.stagger * (i + 1),
            child: Semantics(
              header: i == 0,
              child: Text(_lines[i], style: nameStyle),
            ),
          ),
        SizedBox(height: fluid(context, 20, 32)),
        Reveal(
          delay: Motion.stagger * 4,
          child: Text('${Profile.role}.', style: AppType.h2(context)),
        ),
        const SizedBox(height: Space.m),
        Reveal(
          delay: Motion.stagger * 5,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Text(Profile.intro, style: AppType.lead(context)),
          ),
        ),
        const SizedBox(height: Space.l),
        Reveal(
          delay: Motion.stagger * 6,
          child: const Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [
              PlatformBadge(Platform.mobile),
              PlatformBadge(Platform.desktop),
              PlatformBadge(Platform.web),
              PlatformBadge(Platform.fullStack),
            ],
          ),
        ),
        SizedBox(height: fluid(context, 24, 36)),
        Reveal(
          delay: Motion.stagger * 7,
          child: Wrap(
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
/// slam in one on top of another, flash, and break away as three real devices
/// settle into depth. After that it leans toward the pointer, and the whole
/// stage tips back and recedes as the page scrolls.
class _HeroStage extends StatefulWidget {
  const _HeroStage();

  @override
  State<_HeroStage> createState() => _HeroStageState();
}

class _HeroStageState extends State<_HeroStage>
    with SingleTickerProviderStateMixin {
  static const _introSeconds = 2.7;

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
  static const _breakA = 1.55; // the pile breaks away from here
  static const _breakB = 2.15;
  static const _flashAt = 1.5;

  double _sm(double a, double b) {
    final x = ((introT - a) / (b - a)).clamp(0.0, 1.0);
    return x * x * (3 - 2 * x);
  }

  Widget _layer({
    required double depth,
    required double left,
    required double top,
    required double w,
    required double h,
    required Widget child,
  }) {
    // Nearer layers move more, which sells the depth.
    final shift = Offset(tilt.dx * depth * 16, tilt.dy * depth * 12);
    // During the intro each device flies out from the middle of the pile.
    final e = Curves.easeOutCubic.transform(
      ((introT - 1.45) / 0.95).clamp(0.0, 1.0),
    );
    final fromCentre = Offset(
      (0.5 - (left + w / 2)) * size * (1 - e),
      (0.46 - (top + h / 2)) * size * (1 - e),
    );
    final scale = 0.55 + 0.45 * e;
    return Positioned(
      left: left * size,
      top: top * size,
      child: Opacity(
        opacity: _sm(1.45, 2.0),
        child: Transform.translate(
          offset: shift + fromCentre,
          child: Transform.scale(scale: scale, child: child),
        ),
      ),
    );
  }

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

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
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
            _layer(
              depth: 0.3,
              left: 0.02,
              top: 0.04,
              w: 0.80,
              h: 0.55,
              child: ShotDevice(shot: _desktopShot, width: size * 0.80),
            ),
            _layer(
              depth: 0.7,
              left: 0.0,
              top: 0.50,
              w: 0.52,
              h: 0.32,
              child: ShotDevice(shot: _browserShot, width: size * 0.52),
            ),
            _layer(
              depth: 1.0,
              left: 0.70,
              top: 0.16,
              w: 0.26,
              h: 0.56,
              child: ShotDevice(shot: _phoneShot, width: size * 0.26),
            ),
            if (flash > 0)
              Positioned.fill(
                child: IgnorePointer(
                  child: Opacity(
                    opacity: flash * 0.85,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            Colors.white,
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
