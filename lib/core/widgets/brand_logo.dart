import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// The MACDIPU wordmark: every letter, with the initials set heavy and the
/// rest regular, and a short accent bar anchored under "MAC".
///
/// On hover or focus the bar grows to underline the whole word and the word
/// takes the accent colour, so it reads as a link.
class BrandLogo extends StatelessWidget {
  const BrandLogo({super.key, this.active = false});

  /// Hover or focus state from the surrounding [Pressable].
  final bool active;

  static const _initials = 'MAC';
  static const _rest = 'DIPU';

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final size = fluid(context, 18, 22);

    TextStyle style(FontWeight w) => TextStyle(
          fontFamily: AppType.ui,
          fontSize: size,
          fontWeight: w,
          letterSpacing: size * 0.02,
          height: 1,
        );

    double widthOf(String s, FontWeight w) {
      final p = TextPainter(
        text: TextSpan(text: s, style: style(w)),
        textDirection: TextDirection.ltr,
      )..layout();
      return p.width;
    }

    final initialsW = widthOf(_initials, FontWeight.w800);
    final totalW = initialsW + widthOf(_rest, FontWeight.w500);
    final color = active ? c.signal : c.ink;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            style: TextStyle(color: color),
            children: [
              TextSpan(text: _initials, style: style(FontWeight.w800)),
              TextSpan(text: _rest, style: style(FontWeight.w500)),
            ],
          ),
        ),
        SizedBox(height: size * 0.26),
        AnimatedContainer(
          duration: Motion.scaled(context, Motion.hover),
          curve: Motion.easeOut,
          width: active ? totalW : initialsW,
          height: (size * 0.14).clamp(2.0, 4.0),
          decoration: BoxDecoration(
            color: c.signal,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }
}
