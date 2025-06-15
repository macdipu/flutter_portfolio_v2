import 'package:flutter/material.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  // Title styling
  final Color? titleColor;
  final TextStyle? titleStyle;

  // Subtitle styling
  final Color? subtitleColor;
  final TextStyle? subtitleStyle;

  // Layout
  final TextAlign textAlign;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  // Animation
  final bool enableFadeIn;
  final bool enableTypeWriter;
  final Duration animationDuration;
  final Duration animationDelay;

  // Interaction
  final VoidCallback? onTitleTap;
  final VoidCallback? onSubtitleTap;

  // Accessibility
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
    this.enableTypeWriter = false,
    this.animationDuration = const Duration(milliseconds: 800),
    this.animationDelay = const Duration(milliseconds: 200),
    this.onTitleTap,
    this.onSubtitleTap,
    this.titleSemanticsLabel,
    this.subtitleSemanticsLabel,
  });

  // Named constructors for common use cases
  const SectionHeader.display({
    Key? key,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    TextAlign textAlign = TextAlign.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    bool enableFadeIn = false,
    VoidCallback? onTitleTap,
    String? titleSemanticsLabel,
    String? subtitleSemanticsLabel,
  }) : this(
          key: key,
          title: title,
          subtitle: subtitle,
          titleColor: titleColor,
          subtitleColor: subtitleColor,
          titleStyle:
              const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          subtitleStyle:
              const TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
          textAlign: textAlign,
          crossAxisAlignment: crossAxisAlignment,
          enableFadeIn: enableFadeIn,
          onTitleTap: onTitleTap,
          titleSemanticsLabel: titleSemanticsLabel,
          subtitleSemanticsLabel: subtitleSemanticsLabel,
        );

  const SectionHeader.headline({
    Key? key,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    TextAlign textAlign = TextAlign.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    bool enableFadeIn = false,
    VoidCallback? onTitleTap,
    String? titleSemanticsLabel,
    String? subtitleSemanticsLabel,
  }) : this(
          key: key,
          title: title,
          subtitle: subtitle,
          titleColor: titleColor,
          subtitleColor: subtitleColor,
          titleStyle:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          subtitleStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: textAlign,
          crossAxisAlignment: crossAxisAlignment,
          enableFadeIn: enableFadeIn,
          onTitleTap: onTitleTap,
          titleSemanticsLabel: titleSemanticsLabel,
          subtitleSemanticsLabel: subtitleSemanticsLabel,
        );

  const SectionHeader.centered({
    Key? key,
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    bool enableFadeIn = false,
    VoidCallback? onTitleTap,
    String? titleSemanticsLabel,
    String? subtitleSemanticsLabel,
  }) : this(
          key: key,
          title: title,
          subtitle: subtitle,
          titleColor: titleColor,
          subtitleColor: subtitleColor,
          titleStyle:
              const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          subtitleStyle:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
          textAlign: TextAlign.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          enableFadeIn: enableFadeIn,
          onTitleTap: onTitleTap,
          titleSemanticsLabel: titleSemanticsLabel,
          subtitleSemanticsLabel: subtitleSemanticsLabel,
        );

  CrossAxisAlignment _getCrossAxisAlignment() {
    if (crossAxisAlignment != CrossAxisAlignment.start) {
      return crossAxisAlignment;
    }

    return switch (textAlign) {
      TextAlign.center => CrossAxisAlignment.center,
      TextAlign.end || TextAlign.right => CrossAxisAlignment.end,
      _ => CrossAxisAlignment.start,
    };
  }

  Color _getDefaultSubtitleColor(BuildContext context) {
    final theme = Theme.of(context);
    return subtitleColor ??
        theme.colorScheme.primary.withOpacity(0.8) ??
        theme.textTheme.titleMedium?.color?.withOpacity(0.7) ??
        theme.colorScheme.onSurface.withOpacity(0.7);
  }

  Widget _buildSubtitle(BuildContext context) {
    if (subtitle == null) return const SizedBox.shrink();

    return SelectableText(
      subtitle!,
      style: subtitleStyle?.copyWith(
            color: _getDefaultSubtitleColor(context),
          ) ??
          TextStyle(
            color: _getDefaultSubtitleColor(context),
            fontSize: 16,
            fontWeight: FontWeight.normal,
          ),
      textAlign: textAlign,
      onTap: onSubtitleTap,
      semanticsLabel: subtitleSemanticsLabel,
    );
  }

  Widget _buildTitle(BuildContext context) {
    return SelectableText(
      title,
      style: titleStyle?.copyWith(
            color: titleColor,
          ) ??
          TextStyle(
            color: titleColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
      textAlign: textAlign,
      onTap: onTitleTap,
      semanticsLabel: titleSemanticsLabel,
    );
  }

  Widget _buildContent(BuildContext context) {
    final hasSubtitle = subtitle != null;
    final actualCrossAxisAlignment = _getCrossAxisAlignment();

    return Column(
      crossAxisAlignment: actualCrossAxisAlignment,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (hasSubtitle) ...[
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

    // Apply padding if provided
    if (padding != null) {
      content = Padding(
        padding: padding!,
        child: content,
      );
    }

    // Apply margin if provided
    if (margin != null) {
      content = Container(
        margin: margin,
        child: content,
      );
    }

    return content;
  }
}

// Extension for common section header patterns
extension SectionHeaderPatterns on SectionHeader {
  /// Creates a section header with a decorative underline
  static Widget withUnderline({
    required String title,
    String? subtitle,
    Color? titleColor,
    Color? subtitleColor,
    Color? underlineColor,
    double underlineWidth = 40.0,
    double underlineHeight = 3.0,
    TextAlign textAlign = TextAlign.start,
    bool enableFadeIn = false,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final actualUnderlineColor =
            underlineColor ?? theme.colorScheme.primary;

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
              enableFadeIn: enableFadeIn,
            ),
            const SizedBox(height: 12.0),
            Container(
              width: underlineWidth,
              height: underlineHeight,
              decoration: BoxDecoration(
                color: actualUnderlineColor,
                borderRadius: BorderRadius.circular(underlineHeight / 2),
              ),
            ),
          ],
        );
      },
    );
  }

  /// Creates a section header with icon
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
    bool enableFadeIn = false,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final actualIconColor = iconColor ?? theme.colorScheme.primary;

        return Row(
          mainAxisAlignment: textAlign == TextAlign.center
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: actualIconColor,
            ),
            SizedBox(width: spacing),
            Expanded(
              child: SectionHeader(
                title: title,
                subtitle: subtitle,
                titleColor: titleColor,
                subtitleColor: subtitleColor,
                textAlign: textAlign,
                enableFadeIn: enableFadeIn,
              ),
            ),
          ],
        );
      },
    );
  }
}
