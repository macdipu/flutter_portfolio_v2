import 'dart:ui';
import 'package:flutter/material.dart';

class GlassPanel extends StatelessWidget {
  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double maxWidth;
  final double blurSigma;
  final double opacity;
  final Gradient? overlayGradient;

  const GlassPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(32),
    this.borderRadius = 32,
    this.maxWidth = 1200,
    this.blurSigma = 18,
    this.opacity = 0.08,
    this.overlayGradient,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Clamp opacity to valid range
    final clampedOpacity = opacity.clamp(0.0, 1.0);

    final baseColor = isDark
        ? Colors.white.withOpacity(clampedOpacity)
        : Colors.black.withOpacity((clampedOpacity + 0.02).clamp(0.0, 1.0));

    final highlightColor = theme.colorScheme.primary.withOpacity(
      isDark ? 0.18 : 0.12,
    );

    final overlay = overlayGradient ??
        LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            highlightColor,
            Colors.transparent,
          ],
        );

    // Calculate border and gradient opacities, ensuring they stay within valid range
    final borderOpacity = isDark
        ? (clampedOpacity * 1.2).clamp(0.0, 1.0)
        : (clampedOpacity * 0.9).clamp(0.0, 1.0);
    final gradientOpacity1 = (clampedOpacity * 1.25).clamp(0.0, 1.0);
    final gradientOpacity2 = (clampedOpacity * 0.6).clamp(0.0, 1.0);

    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(borderRadius),
                  color: baseColor,
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(borderOpacity)
                        : Colors.black.withOpacity(borderOpacity),
                    width: 1.2,
                  ),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      isDark
                          ? Colors.white.withOpacity(gradientOpacity1)
                          : Colors.black.withOpacity(gradientOpacity1),
                      isDark
                          ? Colors.white.withOpacity(gradientOpacity2)
                          : Colors.black.withOpacity(gradientOpacity2),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    gradient: overlay,
                  ),
                ),
              ),
              Padding(
                padding: padding,
                child: child,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
