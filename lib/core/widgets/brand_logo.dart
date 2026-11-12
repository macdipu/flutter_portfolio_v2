import 'package:flutter/material.dart';

import '../design/tokens.dart';
import 'logo_mark.dart';

export 'logo_mark.dart' show LogoMark, LogoMarkPainter;

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

  static const navy = LogoMark.navy;
  static const cyan = LogoMark.cyan;

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
