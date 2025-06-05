import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class SectionWrapper extends StatelessWidget {
  final Widget child;
  final String? sectionId;
  final Color? backgroundColor;
  final Gradient? backgroundGradient;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final bool fullHeight;
  final bool centerContent;
  final double? maxWidth;
  final CrossAxisAlignment crossAxisAlignment;
  final MainAxisAlignment mainAxisAlignment;
  final bool addTopPadding;
  final bool addBottomPadding;

  const SectionWrapper({
    super.key,
    required this.child,
    this.sectionId,
    this.backgroundColor,
    this.backgroundGradient,
    this.padding,
    this.margin,
    this.fullHeight = false,
    this.centerContent = true,
    this.maxWidth,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.addTopPadding = true,
    this.addBottomPadding = true,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    // Get responsive padding based on device type
    final defaultPadding = _getDefaultPadding(context);
    final effectivePadding = padding ?? defaultPadding;

    // Determine content max width for better readability on large screens
    final contentMaxWidth = maxWidth ?? _getContentMaxWidth(context);

    Widget content = child;

    // Wrap content with constraints for better web layout
    if (centerContent) {
      content = Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: contentMaxWidth,
            minHeight:
                fullHeight ? screenHeight - effectivePadding.vertical : 0,
          ),
          child: child,
        ),
      );
    } else {
      content = Container(
        width: double.infinity,
        constraints: BoxConstraints(
          maxWidth: contentMaxWidth,
          minHeight: fullHeight ? screenHeight - effectivePadding.vertical : 0,
        ),
        child: child,
      );
    }

    // Add responsive column layout for better web experience
    if (centerContent && screenWidth > ResponsiveBreakpoints.tablet) {
      content = Column(
        crossAxisAlignment: crossAxisAlignment,
        mainAxisAlignment:
            fullHeight ? mainAxisAlignment : MainAxisAlignment.start,
        mainAxisSize: fullHeight ? MainAxisSize.max : MainAxisSize.min,
        children: [content],
      );
    }

    return Container(
      width: double.infinity,
      height: fullHeight ? screenHeight : null,
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        gradient: backgroundGradient,
      ),
      padding: effectivePadding,
      child: centerContent && screenWidth > ResponsiveBreakpoints.tablet
          ? Center(child: content)
          : content,
    );
  }

  EdgeInsets _getDefaultPadding(BuildContext context) {
    final baseVerticalPadding = context.responsive<double>(
      mobile: addTopPadding || addBottomPadding ? 32.0 : 0.0,
      tablet: addTopPadding || addBottomPadding ? 48.0 : 0.0,
      smallLaptop: addTopPadding || addBottomPadding ? 64.0 : 0.0,
      desktop: addTopPadding || addBottomPadding ? 80.0 : 0.0,
      largeDesktop: addTopPadding || addBottomPadding ? 96.0 : 0.0,
    );

    final horizontalPadding = context.responsive<double>(
      mobile: 16.0,
      tablet: 32.0,
      smallLaptop: 48.0,
      desktop: 64.0,
      largeDesktop: 80.0,
    );

    return EdgeInsets.only(
      left: horizontalPadding,
      right: horizontalPadding,
      top: addTopPadding ? baseVerticalPadding : 0.0,
      bottom: addBottomPadding ? baseVerticalPadding : 0.0,
    );
  }

  double _getContentMaxWidth(BuildContext context) {
    return context.responsive<double>(
      mobile: double.infinity,
      tablet: 768.0,
      smallLaptop: 1024.0,
      desktop: 1200.0,
      largeDesktop: 1400.0,
    );
  }
}

// Specialized section wrappers for common web layouts
class HeroSectionWrapper extends SectionWrapper {
  const HeroSectionWrapper({
    super.key,
    required super.child,
    super.sectionId,
    super.backgroundColor,
    super.backgroundGradient,
    super.padding,
    super.margin,
  }) : super(
          fullHeight: true,
          centerContent: true,
          mainAxisAlignment: MainAxisAlignment.center,
        );
}

class ContentSectionWrapper extends SectionWrapper {
  const ContentSectionWrapper({
    super.key,
    required super.child,
    super.sectionId,
    super.backgroundColor,
    super.backgroundGradient,
    super.padding,
    super.margin,
    super.maxWidth,
  }) : super(
          fullHeight: false,
          centerContent: true,
          crossAxisAlignment: CrossAxisAlignment.start,
        );
}

class FullWidthSectionWrapper extends SectionWrapper {
  const FullWidthSectionWrapper({
    super.key,
    required super.child,
    super.sectionId,
    super.backgroundColor,
    super.backgroundGradient,
    super.padding,
    super.margin,
  }) : super(
          fullHeight: false,
          centerContent: false,
          maxWidth: double.infinity,
        );
}

// Extension for easier section wrapper usage
extension SectionWrapperExtension on Widget {
  Widget wrapInSection({
    String? sectionId,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    EdgeInsets? padding,
    EdgeInsets? margin,
    bool fullHeight = false,
    bool centerContent = true,
    double? maxWidth,
  }) {
    return SectionWrapper(
      sectionId: sectionId,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      padding: padding,
      margin: margin,
      fullHeight: fullHeight,
      centerContent: centerContent,
      maxWidth: maxWidth,
      child: this,
    );
  }

  Widget wrapInHeroSection({
    String? sectionId,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    EdgeInsets? padding,
    EdgeInsets? margin,
  }) {
    return HeroSectionWrapper(
      sectionId: sectionId,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      padding: padding,
      margin: margin,
      child: this,
    );
  }

  Widget wrapInContentSection({
    String? sectionId,
    Color? backgroundColor,
    Gradient? backgroundGradient,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? maxWidth,
  }) {
    return ContentSectionWrapper(
      sectionId: sectionId,
      backgroundColor: backgroundColor,
      backgroundGradient: backgroundGradient,
      padding: padding,
      margin: margin,
      maxWidth: maxWidth,
      child: this,
    );
  }
}
