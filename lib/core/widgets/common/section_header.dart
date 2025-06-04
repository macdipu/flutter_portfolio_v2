import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_text.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color? titleColor;
  final Color? subtitleColor;
  final TextAlign textAlign;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.subtitleColor,
    this.textAlign = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: textAlign == TextAlign.start
          ? CrossAxisAlignment.start
          : CrossAxisAlignment.start,
      children: [
        if (subtitle != null)
          ResponsiveText(
            subtitle!,
            style: theme.textTheme.titleMedium?.copyWith(
              color: subtitleColor ?? theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: textAlign,
            mobileFontSize: 14.0,
            tabletFontSize: 16.0,
            desktopFontSize: 18.0,
          ),
        if (subtitle != null) const SizedBox(height: 8.0),
        ResponsiveText(
          title,
          style: theme.textTheme.displaySmall?.copyWith(
            color: titleColor ?? theme.textTheme.displaySmall?.color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: textAlign,
          mobileFontSize: 28.0,
          tabletFontSize: 36.0,
          desktopFontSize: 48.0,
        ),
      ],
    );
  }
}
