import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_text.dart';

class ResponsiveButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isOutlined;
  final Color? backgroundColor;
  final Color? textColor;
  final double? minWidth;
  final EdgeInsets? padding;

  const ResponsiveButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isOutlined = false,
    this.backgroundColor,
    this.textColor,
    this.minWidth,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final responsivePadding = padding ??
        EdgeInsets.symmetric(
          horizontal: ResponsiveHelper.getResponsiveValue(
            context: context,
            mobile: 16.0,
            tablet: 20.0,
            desktop: 24.0,
          ),
          vertical: ResponsiveHelper.getResponsiveValue(
            context: context,
            mobile: 12.0,
            tablet: 14.0,
            desktop: 16.0,
          ),
        );

    final responsiveMinWidth = minWidth ??
        ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 120.0,
          tablet: 140.0,
          desktop: 160.0,
        );

    if (isOutlined) {
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: responsivePadding,
          minimumSize: Size(responsiveMinWidth, 0),
          side: BorderSide(
            color: backgroundColor ?? theme.colorScheme.primary,
          ),
        ),
        child: ResponsiveText(
          text,
          style: TextStyle(
            color: textColor ?? theme.colorScheme.primary,
            fontWeight: FontWeight.w600,
          ),
          mobileFontSize: 14.0,
          tabletFontSize: 15.0,
          desktopFontSize: 16.0,
        ),
      );
    }

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? theme.colorScheme.primary,
        padding: responsivePadding,
        minimumSize: Size(responsiveMinWidth, 0),
        elevation: 2,
      ),
      child: ResponsiveText(
        text,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontWeight: FontWeight.w600,
        ),
        mobileFontSize: 14.0,
        tabletFontSize: 15.0,
        desktopFontSize: 16.0,
      ),
    );
  }
}
