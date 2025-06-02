import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final String? sectionId;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final bool fullHeight;

  const SectionWrapper({
    super.key,
    required this.child,
    this.sectionId,
    this.backgroundColor,
    this.padding,
    this.fullHeight = false,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      height: fullHeight ? screenHeight : null,
      color: backgroundColor,
      padding: padding ?? ResponsiveHelper.getContentPadding(context),
      child: child,
    );
  }
}
