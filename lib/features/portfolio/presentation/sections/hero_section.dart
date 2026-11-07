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
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final wide = size.width >= 900;
    final minHeight = (size.height - 64).clamp(620.0, 1100.0);

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

/// Three real devices in depth. They lean toward the pointer, and the whole
/// stage tips back and recedes as the page scrolls.
class _HeroStage extends StatelessWidget {
  const _HeroStage();

  @override
  Widget build(BuildContext context) {
    return Reveal(
      delay: Motion.stagger * 3,
      child: LayoutBuilder(builder: (context, box) {
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
                  return _Stage(size: s, tilt: tilt, scrollT: t);
                },
              ),
            ),
          ),
        );
      }),
    );
  }
}

class _Stage extends StatelessWidget {
  const _Stage({required this.size, required this.tilt, required this.scrollT});

  final double size;
  final Offset tilt;
  final double scrollT;

  Widget _layer({
    required double depth,
    required double left,
    required double top,
    required Widget child,
  }) {
    // Nearer layers move more, which sells the depth.
    final shift = Offset(tilt.dx * depth * 16, tilt.dy * depth * 12);
    return Positioned(
      left: left * size,
      top: top * size,
      child: Transform.translate(offset: shift, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    final master = perspective(
      rotateX: 0.10 - tilt.dy * 0.07 + scrollT * 0.32,
      rotateY: -0.24 + tilt.dx * 0.12,
      dy: scrollT * 70,
      scale: 1 - scrollT * 0.14,
    );
    return Opacity(
      opacity: (1 - scrollT * 0.7).clamp(0.0, 1.0),
      child: Transform(
        alignment: Alignment.center,
        transform: master,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            _layer(
              depth: 0.3,
              left: 0.02,
              top: 0.04,
              child: ShotDevice(shot: _desktopShot, width: size * 0.80),
            ),
            _layer(
              depth: 0.7,
              left: 0.0,
              top: 0.50,
              child: ShotDevice(shot: _browserShot, width: size * 0.52),
            ),
            _layer(
              depth: 1.0,
              left: 0.70,
              top: 0.16,
              child: ShotDevice(shot: _phoneShot, width: size * 0.26),
            ),
          ],
        ),
      ),
    );
  }
}
