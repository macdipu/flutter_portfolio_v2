import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The macdipu wordmark: bold navy "mac", a cyan italic "dipu" and a swoosh
/// under the script.
///
/// The glyphs are the logo's own outlines (not a font), so the mark is the
/// same everywhere. "mac" follows the theme's ink on dark pages, where navy
/// would disappear; the cyan stays fixed.
///
/// On hover or focus the mark lifts slightly and the dot on the i hops up.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.active = false});

  /// Hover or focus state from the surrounding [Pressable].
  final bool active;

  static const navy = Color(0xFF072A54);
  static const cyan = Color(0xFF12B5D8);

  @override
  Widget build(BuildContext context) {
    final height = fluid(context, 30, 36);
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Semantics(
      label: 'macdipu',
      child: ExcludeSemantics(
        child: AnimatedScale(
          scale: active ? 1.04 : 1,
          duration: Motion.scaled(context, Motion.hover),
          curve: Motion.easeOut,
          child: TweenAnimationBuilder<double>(
            tween: Tween(end: active ? 1 : 0),
            duration: Motion.scaled(context, Motion.hover),
            curve: Motion.easeOut,
            builder: (context, lift, _) => CustomPaint(
              size: Size(height * LogoMark.aspect, height),
              painter: LogoMarkPainter(
                macColor: dark ? context.colors.ink : navy,
                dipuColor: cyan,
                lift: lift,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Outline data for the mark, in the logo's own 820×260 artboard units.
abstract class LogoMark {
  /// Tight box around every shape of the mark.
  static const Rect bounds = Rect.fromLTRB(42, 28, 799, 226);
  static double get aspect => bounds.width / bounds.height;

  static const mac = [
    'M 45 165 L 45 78 L 70 78 L 70 90 C 76 80 86 75 99 75 C 112 75 122 80 127 91 C 134 80 146 75 160 75 C 180 75 193 88 193 111 L 193 165 L 166 165 L 166 116 C 166 104 160 98 150 98 C 140 98 133 105 133 117 L 133 165 L 106 165 L 106 116 C 106 104 100 98 90 98 C 80 98 73 105 73 117 L 73 165 Z',
    'M 250 167 C 231 167 218 156 218 139 C 218 121 233 112 259 112 L 281 112 L 281 109 C 281 99 274 94 261 94 C 250 94 242 98 238 105 L 217 93 C 225 81 241 75 264 75 C 292 75 308 88 308 113 L 308 165 L 283 165 L 283 154 C 276 163 265 167 250 167 Z M 257 148 C 270 148 281 140 281 129 L 281 127 L 262 127 C 249 127 244 131 244 138 C 244 144 249 148 257 148 Z',
    'M 374 167 C 344 167 324 148 324 121 C 324 94 344 75 374 75 C 396 75 413 86 419 104 L 394 112 C 390 102 383 97 373 97 C 359 97 351 106 351 121 C 351 136 359 145 373 145 C 383 145 391 140 394 130 L 419 138 C 413 156 396 167 374 167 Z',
  ];

  static const dipu = [
    'M 465 166 C 443 166 430 151 433 128 C 436 104 454 86 476 86 C 489 86 498 92 502 102 L 524 38 C 526 32 532 30 538 32 L 547 35 L 509 145 C 507 151 510 154 516 151 C 522 148 528 140 533 131 L 542 136 C 534 154 521 166 505 166 C 494 166 488 159 488 149 C 481 160 474 166 465 166 Z M 469 147 C 479 147 490 135 493 119 C 495 108 489 102 480 102 C 468 102 458 114 455 130 C 453 141 459 147 469 147 Z',
    'M 556 88 L 580 88 L 562 144 C 560 150 563 153 569 150 C 575 147 581 139 586 130 L 595 135 C 587 154 574 166 558 166 C 544 166 537 157 542 141 Z',
    'M 608 88 L 631 88 L 627 101 C 636 91 647 86 660 86 C 679 86 690 101 686 124 C 682 149 663 166 641 166 C 630 166 621 161 617 153 L 599 216 C 597 222 592 224 585 222 L 575 219 Z M 638 148 C 650 148 660 136 663 120 C 665 109 659 103 650 103 C 638 103 627 115 624 131 C 622 142 628 148 638 148 Z',
    'M 704 88 L 727 88 L 713 136 C 710 145 714 149 722 149 C 732 149 742 138 747 122 L 758 88 L 781 88 L 763 144 C 761 150 764 153 770 150 C 776 147 782 139 787 128 L 796 133 C 788 153 775 166 759 166 C 748 166 742 159 743 148 C 734 160 723 166 710 166 C 693 166 685 155 691 135 Z',
  ];

  static const swoosh = [
    'M 432 206 C 472 191 520 182 569 178 L 564 193 C 518 197 473 205 435 216 C 429 218 427 209 432 206 Z',
    'M 616 176 C 675 174 735 182 788 198 C 792 199 790 205 785 204 C 732 191 675 186 612 190 Z',
  ];

  static const Offset iDot = Offset(574, 64);
  static const double iDotRadius = 12;

  static final Path macPath = _join(mac);
  static final Path dipuPath = _join([...dipu, ...swoosh]);

  static Path _join(List<String> ds) {
    final p = Path();
    for (final d in ds) {
      p.addPath(parseSvgPath(d), Offset.zero);
    }
    return p;
  }
}

/// Parses the absolute M/L/C/Z subset of SVG path data the logo uses.
Path parseSvgPath(String d) {
  final tokens = RegExp(r'[MLCZ]|-?\d*\.?\d+')
      .allMatches(d)
      .map((m) => m.group(0)!)
      .toList();
  final path = Path();
  var i = 0;
  double n() => double.parse(tokens[i++]);
  var cmd = 'M';
  while (i < tokens.length) {
    final t = tokens[i];
    if (RegExp(r'[MLCZ]').hasMatch(t)) {
      cmd = t;
      i++;
      if (cmd == 'Z') {
        path.close();
        continue;
      }
    }
    switch (cmd) {
      case 'M':
        path.moveTo(n(), n());
        cmd = 'L';
      case 'L':
        path.lineTo(n(), n());
      case 'C':
        path.cubicTo(n(), n(), n(), n(), n(), n());
    }
  }
  return path;
}

class LogoMarkPainter extends CustomPainter {
  LogoMarkPainter({
    required this.macColor,
    required this.dipuColor,
    this.lift = 0,
  });

  final Color macColor;
  final Color dipuColor;
  final double lift;

  @override
  void paint(Canvas canvas, Size size) {
    final b = LogoMark.bounds;
    final k = size.height / b.height;
    canvas.save();
    canvas.scale(k);
    canvas.translate(-b.left, -b.top);
    canvas.drawPath(LogoMark.macPath, Paint()..color = macColor);
    final cyan = Paint()..color = dipuColor;
    canvas.drawPath(LogoMark.dipuPath, cyan);
    canvas.drawCircle(
      LogoMark.iDot.translate(0, -lift * 14),
      LogoMark.iDotRadius,
      cyan,
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(LogoMarkPainter old) =>
      old.lift != lift ||
      old.macColor != macColor ||
      old.dipuColor != dipuColor;
}
