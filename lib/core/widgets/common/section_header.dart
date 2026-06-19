import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  final Color? titleColor;
  final TextStyle? titleStyle;

  final Color? subtitleColor;
  final TextStyle? subtitleStyle;

  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  final bool enableFadeIn;
  final Duration animationDuration;
  final Duration animationDelay;

  final VoidCallback? onTitleTap;
  final VoidCallback? onSubtitleTap;

  final String? titleSemanticsLabel;
  final String? subtitleSemanticsLabel;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.titleColor,
    this.titleStyle,
    this.subtitleColor,
    this.subtitleStyle,
    this.textAlign = TextAlign.start,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.spacing = 8.0,
    this.padding,
    this.margin,
    this.enableFadeIn = false,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationDelay = const Duration(milliseconds: 200),
    this.onTitleTap,
    this.onSubtitleTap,
    this.titleSemanticsLabel,
    this.subtitleSemanticsLabel,
  });

  CrossAxisAlignment _getCrossAxisAlignment() {
    if (crossAxisAlignment != CrossAxisAlignment.start) return crossAxisAlignment;
    return switch (textAlign) {
      TextAlign.center => CrossAxisAlignment.center,
      TextAlign.end || TextAlign.right => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.start,
    };
  }

  Widget _buildSubtitle(BuildContext context) {
    if (subtitle == null) return const SizedBox.shrink();
    final theme = Theme.of(context);
    final color = subtitleColor ?? theme.colorScheme.primary;
    final style = subtitleStyle?.copyWith(color: color) ??
        (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(color: color);
    return SelectableText(
      subtitle!,
      style: style,
      textAlign: textAlign,
      onTap: onSubtitleTap,
      semanticsLabel: subtitleSemanticsLabel,
    );
  }

  Widget _buildTitle(BuildContext context) {
    final theme = Theme.of(context);
    final style = titleStyle?.copyWith(color: titleColor) ??
        (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
          color: titleColor ?? theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        );
    return SelectableText(
      title,
      style: style,
      textAlign: textAlign,
      onTap: onTitleTap,
      semanticsLabel: titleSemanticsLabel,
    );
  }

  Widget _buildContent(BuildContext context) {
    return Column(
      crossAxisAlignment: _getCrossAxisAlignment(),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (subtitle != null) ...[
          _buildSubtitle(context),
          SizedBox(height: spacing),
        ],
        _buildTitle(context),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = _buildContent(context);

    if (padding != null) {
      content = Padding(padding: padding!, child: content);
    }
    if (margin != null) {
      content = Container(margin: margin, child: content);
    }

    return content;
  }
}

// ── Static helper patterns ────────────────────────────────────────────────────
extension SectionHeaderPatterns on SectionHeader {
  static Widget withUnderline({
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    Color? underlineColor,
    double underlineWidth = 40.0,
    double underlineHeight = 3.0,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Builder(
      builder: (context) {
        final color = underlineColor ?? Theme.of(context).colorScheme.primary;
        return Column(
          crossAxisAlignment: textAlign == TextAlign.center
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: [
            SectionHeader(
              title: title,
              subtitle: subtitle,
              titleColor: titleColor,
              subtitleColor: subtitleColor,
              textAlign: textAlign,
            ),
            const SizedBox(height: 12),
            Container(
              width: underlineWidth,
              height: underlineHeight,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(underlineHeight / 2),
              ),
            ),
          ],
        );
      },
    );
  }

  static Widget withIcon({
    required String title,
    required IconData icon,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    Color? iconColor,
    double iconSize = 24.0,
    double spacing = 12.0,
    TextAlign textAlign = TextAlign.start,
  }) {
    return Builder(
      builder: (context) {
        final color = iconColor ?? Theme.of(context).colorScheme.primary;
        return Row(
          mainAxisAlignment: textAlign == TextAlign.center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: iconSize, color: color),
            SizedBox(width: spacing),
            Expanded(
              child: SectionHeader(
                title: title,
                subtitle: subtitle,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
                textAlign: textAlign,
              ),
            ),
          ],
        );
      },
    );
  }
}
