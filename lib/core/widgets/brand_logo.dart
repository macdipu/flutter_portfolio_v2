import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The MACDIPU mark: an "M" drawn as one continuous stroke on an accent
/// square. The right leg stops short of the baseline and ends in a dot, the
/// signal that something is deployed and live.
///
/// Geometry is on a 64 x 64 grid and matches `web/favicon.svg`.
class BrandMark extends StatelessWidget {
  const BrandMark({super.key, this.size = 30, this.hovered = false});

  final double size;

  /// Lifts the dot slightly on hover or focus.
  final bool hovered;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return TweenAnimationBuilder<double>(
      tween: Tween(end: hovered ? 1 : 0),
      duration: Motion.scaled(context, Motion.hover),
      curve: Motion.easeOut,
      builder: (context, lift, _) => CustomPaint(
        size: Size.square(size),
        painter: _MarkPainter(bg: c.signal, fg: c.onSignal, lift: lift),
      ),
    );
  }
}

class _MarkPainter extends CustomPainter {
  _MarkPainter({required this.bg, required this.fg, required this.lift});

  final Color bg;
  final Color fg;
  final double lift;

  @override
  void paint(Canvas canvas, Size size) {
    final k = size.width / 64;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(16 * k),
      ),
      Paint()..color = bg,
    );

    final m = Path()
      ..moveTo(16 * k, 47 * k)
      ..lineTo(16 * k, 19 * k)
      ..lineTo(32 * k, 37 * k)
      ..lineTo(48 * k, 19 * k)
      ..lineTo(48 * k, 38 * k);
    canvas.drawPath(
      m,
      Paint()
        ..color = fg
        ..style = PaintingStyle.stroke
        ..strokeWidth = 6.5 * k
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );

    canvas.drawCircle(
      Offset(48 * k, (48.5 - 2 * lift) * k),
      4.2 * k,
      Paint()..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_MarkPainter old) =>
      old.bg != bg || old.fg != fg || old.lift != lift;
}

/// Mark plus wordmark. "MAC" is heavy and "DIPU" is lighter, so the name
/// reads as initials and surname.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.active = false, this.height = 30});

  /// Hover or focus state from the surrounding [Pressable].
  final bool active;
  final double height;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = fluid(context, 15, 18);
    final color = active ? c.signal : c.ink;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        BrandMark(size: height, hovered: active),
        SizedBox(width: height * 0.38),
        AnimatedDefaultTextStyle(
          duration: Motion.scaled(context, Motion.hover),
          style: TextStyle(
            fontFamily: AppType.ui,
            fontSize: size,
            letterSpacing: 1.1,
            height: 1,
            color: color,
          ),
          child: const Text.rich(
            TextSpan(children: [
              TextSpan(
                  text: 'MAC', style: TextStyle(fontWeight: FontWeight.w800)),
              TextSpan(
                  text: 'DIPU', style: TextStyle(fontWeight: FontWeight.w500)),
            ]),
          ),
        ),
      ],
    );
  }
}
