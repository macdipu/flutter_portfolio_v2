import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class ResponsiveText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? mobileFontSize;
  final double? tabletFontSize;
  final double? desktopFontSize;

  const ResponsiveText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.mobileFontSize,
    this.tabletFontSize,
    this.desktopFontSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveFontSize = ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: mobileFontSize ?? style?.fontSize ?? 14.0,
      tablet: tabletFontSize ?? style?.fontSize ?? 16.0,
      desktop: desktopFontSize ?? style?.fontSize ?? 18.0,
    );

    return Text(
      text,
      style: style?.copyWith(fontSize: responsiveFontSize) ??
          TextStyle(fontSize: responsiveFontSize),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }
}
