import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/section_header.dart';

class SectionWrapper extends StatelessWidget {
  /// Single adaptive child — use this when the section handles its own layout.
  /// When provided, device-specific children are ignored.
  final Widget? child;

  // Device-specific children (cascade fallback: largeDesktop→desktop→…→mobile)
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
    this.child,
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
    final screenHeight = MediaQuery.sizeOf(context).height;

    final defaultPad = _getDefaultPadding(context);
    final effectivePadding = padding ?? defaultPad;
    final contentMaxWidth = maxWidth ?? _getContentMaxWidth(context);

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
        Widget content = child ?? _getResponsiveChild(info.deviceType) ?? const SizedBox.shrink();

        if (centerContent) {
          content = Center(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: contentMaxWidth,
                minHeight: fullHeight ? screenHeight - effectivePadding.vertical : 0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (header != null) ...[header, const SizedBox(height: 16)],
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
              minHeight: fullHeight ? screenHeight - effectivePadding.vertical : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (header != null) ...[header, const SizedBox(height: 16)],
                content,
              ],
            ),
          );
        }

        if (centerContent && !info.isMobileOrTablet) {
          content = Column(
            crossAxisAlignment: crossAxisAlignment,
            mainAxisAlignment: fullHeight ? mainAxisAlignment : MainAxisAlignment.start,
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
          child: centerContent && !info.isMobileOrTablet ? Center(child: content) : content,
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
        return largeDesktopChild ?? desktopChild ?? smallLaptopChild ?? tabletChild ?? mobileChild;
    }
  }

  EdgeInsets _getDefaultPadding(BuildContext context) {
    final r = context.responsive;
    final baseV = (addTopPadding || addBottomPadding)
        ? (r.isMobile ? 32.0 : r.isTablet ? 48.0 : r.isSmallLaptop ? 64.0 : r.isDesktop ? 80.0 : 96.0)
        : 0.0;
    final h = r.isMobile ? 16.0 : r.isTablet ? 32.0 : r.isSmallLaptop ? 48.0 : r.isDesktop ? 64.0 : 80.0;
    return EdgeInsets.only(
      left: h, right: h,
      top: addTopPadding ? baseV : 0,
      bottom: addBottomPadding ? baseV : 0,
    );
  }

  double _getContentMaxWidth(BuildContext context) {
    final r = context.responsive;
    return r.isMobile ? double.infinity : r.isTablet ? 768 : r.isSmallLaptop ? 1024 : r.isDesktop ? 1200 : 1400;
  }
}
