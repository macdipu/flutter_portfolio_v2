import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The MACDIPU logo: the same tile as the app icon, drawn small.
///
/// A white squircle with big navy MAC over DIPU, a blue dot on the baseline
/// after the U, and a soft blue curve in the corner. The colours are fixed, as
/// they are in the app icon, so the logo looks the same in both themes.
///
/// On hover or focus the tile lifts slightly and the dot hops up.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.active = false});

  /// Hover or focus state from the surrounding [Pressable].
  final bool active;

  static const _navy = Color(0xFF0A1330);
  static const _blue = Color(0xFF0A5BFF);

  @override
  Widget build(BuildContext context) {
    final size = fluid(context, 40, 46);
    return Semantics(
      label: 'MACDIPU',
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: active ? 1.07 : 1,
          duration: Motion.scaled(context, Motion.hover),
          curve: Motion.easeOut,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: active ? 1 : 0),
            duration: Motion.scaled(context, Motion.hover),
            curve: Motion.easeOut,
            builder: (context, lift, _) => CustomPaint(
              size: Size.square(size),
              painter: _TilePainter(
                lift: lift,
                // A hairline keeps the white tile from dissolving on the light page.
                outline: Theme.of(context).brightness == Brightness.light,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TilePainter extends CustomPainter {
  _TilePainter({required this.lift, required this.outline});

  final double lift;
  final bool outline;

  TextPainter _text(String s, double fs) => TextPainter(
        text: TextSpan(
          text: s,
          style: TextStyle(
            fontFamily: AppType.ui,
            fontSize: fs,
            fontWeight: FontWeight.w800,
            letterSpacing: -fs * 0.02,
            height: 1,
            color: BrandLogo._navy,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width;
    final tile = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, s, s),
      Radius.circular(s * 0.225),
    );

    canvas.drawRRect(tile, Paint()..color = Colors.white);

    // Soft blue curve in the bottom-right corner.
    canvas.save();
    canvas.clipRRect(tile);
    final wave = Path()
      ..moveTo(s, s * 0.50)
      ..cubicTo(s * 0.80, s * 0.60, s * 0.66, s * 0.84, s * 0.40, s)
      ..lineTo(s, s)
      ..close();
    canvas.drawPath(
      wave,
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0x1A2BB7FF), Color(0x380A5BFF)],
        ).createShader(Rect.fromLTWH(0, 0, s, s)),
    );
    canvas.restore();

    if (outline) {
      canvas.drawRRect(
        tile.deflate(0.5),
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1
          ..color = const Color(0x2E0A1330),
      );
    }

    // One font size for both lines. DIPU takes about 66% of the tile.
    final w100 = _text('DIPU', 100).width;
    final f = (s * 0.66) / (w100 / 100);
    final mac = _text('MAC', f);
    final dipu = _text('DIPU', f);
    final cap = f * 0.7;
    final lead = f * 0.12;
    final top = (s - (cap * 2 + lead)) / 2;
    final baseMac = top + cap;
    final baseDipu = baseMac + lead + cap;
    final left = s * 0.12;

    double baselineOf(TextPainter p) =>
        p.computeDistanceToActualBaseline(TextBaseline.alphabetic);
    mac.paint(canvas, Offset(left, baseMac - baselineOf(mac)));
    dipu.paint(canvas, Offset(left, baseDipu - baselineOf(dipu)));

    // The dot, on the baseline right after the U.
    final r = f * 0.088;
    canvas.drawCircle(
      Offset(left + dipu.width + f * 0.035 + r, baseDipu - r - lift * s * 0.05),
      r,
      Paint()..color = BrandLogo._blue,
    );
  }

  @override
  bool shouldRepaint(_TilePainter old) =>
      old.lift != lift || old.outline != outline;
}
