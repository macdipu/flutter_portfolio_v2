import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/section_header.dart';

class SectionWrapper extends StatelessWidget {
  final Widget? mobileChild;
  final Widget? tabletChild;
  final Widget? smallLaptopChild;
  final Widget? desktopChild;
  final Widget? largeDesktopChild;
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
  final String? title;
  final String? subtitle;
  final TextAlign headerTextAlign;

  const SectionWrapper({
    super.key,
    this.mobileChild,
    this.tabletChild,
    this.smallLaptopChild,
    this.desktopChild,
    this.largeDesktopChild,
    this.sectionId,
    this.backgroundColor,
    this.backgroundGradient,
    this.padding,
    this.margin,
    this.fullHeight = false,
    this.centerContent = false,
    this.maxWidth,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.mainAxisAlignment = MainAxisAlignment.center,
    this.addTopPadding = true,
    this.addBottomPadding = true,
    this.title,
    this.subtitle,
    this.headerTextAlign = TextAlign.start,
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

    // Build the header if title or subtitle is provided
    Widget? header;
    if (title != null || subtitle != null) {
      header = SectionHeader(
        title: title ?? '',
        subtitle: subtitle,
        textAlign: headerTextAlign,
        crossAxisAlignment: CrossAxisAlignment.start,
      );
    }

    return ResponsiveBuilder(
      builder: (context, info) {
        // Select the appropriate child based on device type
        Widget content =
            _getResponsiveChild(info.deviceType) ?? const SizedBox.shrink();

        // Wrap content with constraints for better web layout
        if (centerContent) {
          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentMaxWidth,
                minHeight:
                    fullHeight ? screenHeight - effectivePadding.vertical : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (header != null) ...[
                    header,
                    const SizedBox(height: 16.0),
                  ],
                  content,
                ],
              ),
            ),
          );
        } else {
          content = Container(
            width: double.infinity,
            constraints: BoxConstraints(
              maxWidth: contentMaxWidth,
              minHeight:
                  fullHeight ? screenHeight - effectivePadding.vertical : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null) ...[
                  header,
                  const SizedBox(height: 16.0),
                ],
                content,
              ],
            ),
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
      },
    );
  }

  Widget? _getResponsiveChild(DeviceType deviceType) {
    switch (deviceType) {
      case DeviceType.mobile:
        return mobileChild;
      case DeviceType.tablet:
        return tabletChild ?? mobileChild;
      case DeviceType.smallLaptop:
        return smallLaptopChild ?? tabletChild ?? mobileChild;
      case DeviceType.desktop:
        return desktopChild ?? smallLaptopChild ?? tabletChild ?? mobileChild;
      case DeviceType.largeDesktop:
        return largeDesktopChild ??
            desktopChild ??
            smallLaptopChild ??
            tabletChild ??
            mobileChild;
    }
  }

  EdgeInsets _getDefaultPadding(BuildContext context) {
    final baseVerticalPadding = context.responsiveValue<double>(
      mobile: addTopPadding || addBottomPadding ? 32.0 : 0.0,
      tablet: addTopPadding || addBottomPadding ? 48.0 : 0.0,
      smallLaptop: addTopPadding || addBottomPadding ? 64.0 : 0.0,
      desktop: addTopPadding || addBottomPadding ? 80.0 : 0.0,
      largeDesktop: addTopPadding || addBottomPadding ? 96.0 : 0.0,
    );

    final horizontalPadding = context.responsiveValue<double>(
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
    return context.responsiveValue<double>(
      mobile: double.infinity,
      tablet: 768.0,
      smallLaptop: 1024.0,
      desktop: 1200.0,
      largeDesktop: 1400.0,
    );
  }
}
