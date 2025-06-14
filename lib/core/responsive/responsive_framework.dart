import 'dart:math' as math;

import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  smallLaptop,
  desktop,
  largeDesktop,
}

class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double smallLaptop = 1366;
  static const double desktop = 1680;
  static const double largeDesktop = 1920;

  // Custom breakpoints
  static const double smallMobile = 360;
  static const double largeMobile = 480;

  // Density-aware breakpoints (considering pixel density)
  static double getDensityAwareBreakpoint(
      double breakpoint, double pixelRatio) {
    return breakpoint *
        math.min(pixelRatio, 2.0); // Cap at 2x for reasonable scaling
  }
}

class ResponsiveConfig {
  final bool useDensityAwareBreakpoints;
  final double maxContentWidth;
  final Map<DeviceType, EdgeInsets> defaultPadding;
  final bool enableDebugMode;

  const ResponsiveConfig({
    this.useDensityAwareBreakpoints = false,
    this.maxContentWidth = 1400.0,
    this.defaultPadding = const {
      DeviceType.mobile: EdgeInsets.all(16.0),
      DeviceType.tablet: EdgeInsets.all(24.0),
      DeviceType.smallLaptop: EdgeInsets.all(28.0),
      DeviceType.desktop: EdgeInsets.all(32.0),
      DeviceType.largeDesktop: EdgeInsets.all(48.0),
    },
    this.enableDebugMode = false,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ResponsiveConfig &&
          runtimeType == other.runtimeType &&
          useDensityAwareBreakpoints == other.useDensityAwareBreakpoints &&
          maxContentWidth == other.maxContentWidth &&
          enableDebugMode == other.enableDebugMode;

  @override
  int get hashCode =>
      useDensityAwareBreakpoints.hashCode ^
      maxContentWidth.hashCode ^
      enableDebugMode.hashCode;
}

class ResponsiveProvider extends InheritedWidget {
  final ResponsiveConfig config;

  const ResponsiveProvider({
    super.key,
    required this.config,
    required super.child,
  });

  static ResponsiveProvider? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>();
  }

  static ResponsiveConfig configOf(BuildContext context) {
    return ResponsiveProvider.of(context)?.config ?? const ResponsiveConfig();
  }

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) {
    return config != oldWidget.config;
  }
}

class ResponsiveInfo {
  final DeviceType deviceType;
  final double screenWidth;
  final double screenHeight;
  final double pixelRatio;
  final EdgeInsets safeArea;
  final EdgeInsets viewInsets;

  const ResponsiveInfo({
    required this.deviceType,
    required this.screenWidth,
    required this.screenHeight,
    required this.pixelRatio,
    required this.safeArea,
    required this.viewInsets,
  });

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isSmallLaptop => deviceType == DeviceType.smallLaptop;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isLargeDesktop => deviceType == DeviceType.largeDesktop;

  // Utility getters
  bool get isMobileOrTablet => isMobile || isTablet;
  bool get isDesktopOrLarger => isDesktop || isLargeDesktop;

  double get availableWidth => screenWidth - safeArea.horizontal;
  double get availableHeight =>
      screenHeight - safeArea.vertical - viewInsets.vertical;
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final mediaQuery = MediaQuery.of(context);
        final config = ResponsiveProvider.configOf(context);

        final info = ResponsiveInfo(
          deviceType: _getDeviceType(
              constraints.maxWidth, mediaQuery.devicePixelRatio, config),
          screenWidth: constraints.maxWidth,
          screenHeight: constraints.maxHeight,
          pixelRatio: mediaQuery.devicePixelRatio,
          safeArea: mediaQuery.padding,
          viewInsets: mediaQuery.viewInsets,
        );

        Widget child = builder(context, info);

        // Add debug overlay if enabled
        if (config.enableDebugMode) {
          child = Stack(
            children: [
              child,
              Positioned(
                top: 0,
                right: 0,
                child: _DebugOverlay(info: info),
              ),
            ],
          );
        }

        return child;
      },
    );
  }

  DeviceType _getDeviceType(
      double width, double pixelRatio, ResponsiveConfig config) {
    // Adjust breakpoints based on pixel density if enabled
    final mobile = config.useDensityAwareBreakpoints
        ? ResponsiveBreakpoints.getDensityAwareBreakpoint(
            ResponsiveBreakpoints.mobile, pixelRatio)
        : ResponsiveBreakpoints.mobile;
    final tablet = config.useDensityAwareBreakpoints
        ? ResponsiveBreakpoints.getDensityAwareBreakpoint(
            ResponsiveBreakpoints.tablet, pixelRatio)
        : ResponsiveBreakpoints.tablet;
    final smallLaptop = ResponsiveBreakpoints.smallLaptop;
    final desktop = ResponsiveBreakpoints.desktop;
    final largeDesktop = ResponsiveBreakpoints.largeDesktop;

    if (width < mobile) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.tablet;
    } else if (width < smallLaptop) {
      return DeviceType.smallLaptop;
    } else if (width < desktop) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }
}

class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? smallLaptop;
  final Widget? desktop;
  final Widget? largeDesktop;
  final Widget? fallback;

  const ResponsiveWidget({
    super.key,
    this.mobile,
    this.tablet,
    this.smallLaptop,
    this.desktop,
    this.largeDesktop,
    this.fallback,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        switch (info.deviceType) {
          case DeviceType.mobile:
            return mobile ?? fallback ?? const SizedBox.shrink();
          case DeviceType.tablet:
            return tablet ?? mobile ?? fallback ?? const SizedBox.shrink();
          case DeviceType.smallLaptop:
            return smallLaptop ??
                tablet ??
                mobile ??
                fallback ??
                const SizedBox.shrink();
          case DeviceType.desktop:
            return desktop ??
                smallLaptop ??
                tablet ??
                mobile ??
                fallback ??
                const SizedBox.shrink();
          case DeviceType.largeDesktop:
            return largeDesktop ??
                desktop ??
                smallLaptop ??
                tablet ??
                mobile ??
                fallback ??
                const SizedBox.shrink();
        }
      },
    );
  }
}

class ResponsiveHelper {
  static ResponsiveInfo getInfo(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final config = ResponsiveProvider.configOf(context);

    return ResponsiveInfo(
      deviceType: _getDeviceType(
          mediaQuery.size.width, mediaQuery.devicePixelRatio, config),
      screenWidth: mediaQuery.size.width,
      screenHeight: mediaQuery.size.height,
      pixelRatio: mediaQuery.devicePixelRatio,
      safeArea: mediaQuery.padding,
      viewInsets: mediaQuery.viewInsets,
    );
  }

  static DeviceType _getDeviceType(
      double width, double pixelRatio, ResponsiveConfig config) {
    final mobile = config.useDensityAwareBreakpoints
        ? ResponsiveBreakpoints.getDensityAwareBreakpoint(
            ResponsiveBreakpoints.mobile, pixelRatio)
        : ResponsiveBreakpoints.mobile;
    final tablet = config.useDensityAwareBreakpoints
        ? ResponsiveBreakpoints.getDensityAwareBreakpoint(
            ResponsiveBreakpoints.tablet, pixelRatio)
        : ResponsiveBreakpoints.tablet;

    if (width < mobile) {
      return DeviceType.mobile;
    } else if (width < tablet) {
      return DeviceType.tablet;
    } else if (width < ResponsiveBreakpoints.smallLaptop) {
      return DeviceType.smallLaptop;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return DeviceType.desktop;
    } else if (width < ResponsiveBreakpoints.largeDesktop) {
      return DeviceType.largeDesktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  // Enhanced responsive value getter
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? smallLaptop,
    T? desktop,
    T? largeDesktop,
  }) {
    final info = getInfo(context);

    switch (info.deviceType) {
      case DeviceType.mobile:
        return mobile;
      case DeviceType.tablet:
        return tablet ?? mobile;
      case DeviceType.smallLaptop:
        return smallLaptop ?? tablet ?? mobile;
      case DeviceType.desktop:
        return desktop ?? smallLaptop ?? tablet ?? mobile;
      case DeviceType.largeDesktop:
        return largeDesktop ?? desktop ?? smallLaptop ?? tablet ?? mobile;
    }
  }

  // Get default padding for current device type
  static EdgeInsets getDefaultPadding(BuildContext context) {
    final config = ResponsiveProvider.configOf(context);
    final info = getInfo(context);
    return config.defaultPadding[info.deviceType] ?? const EdgeInsets.all(16.0);
  }

  // Get responsive padding with optional overrides
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? smallLaptop,
    EdgeInsets? desktop,
    EdgeInsets? largeDesktop,
  }) {
    final config = ResponsiveProvider.configOf(context);
    return getResponsiveValue<EdgeInsets>(
      context: context,
      mobile: mobile ?? config.defaultPadding[DeviceType.mobile]!,
      tablet: tablet ?? config.defaultPadding[DeviceType.tablet],
      smallLaptop: smallLaptop ?? config.defaultPadding[DeviceType.smallLaptop],
      desktop: desktop ?? config.defaultPadding[DeviceType.desktop],
      largeDesktop:
          largeDesktop ?? config.defaultPadding[DeviceType.largeDesktop],
    );
  }

  // Smart content width with configurable max width
  static double getContentWidth(BuildContext context) {
    final config = ResponsiveProvider.configOf(context);
    final info = getInfo(context);

    if (info.isMobile) return double.infinity;

    final maxWidth = getResponsiveValue<double>(
      context: context,
      mobile: double.infinity,
      tablet: 720.0,
      smallLaptop: 860.0,
      desktop: 1024.0,
      largeDesktop: config.maxContentWidth,
    );

    return math.min(maxWidth, info.screenWidth * 0.9);
  }

  // Responsive spacing system
  static double getSpacing(
    BuildContext context, {
    double scale = 1.0,
  }) {
    return getResponsiveValue<double>(
      context: context,
      mobile: 8.0 * scale,
      tablet: 12.0 * scale,
      smallLaptop: 16.0 * scale,
      desktop: 20.0 * scale,
      largeDesktop: 24.0 * scale,
    );
  }

  // Typography scaling
  static TextStyle getResponsiveTextStyle(
    BuildContext context,
    TextStyle baseStyle, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    final scale = getResponsiveValue<double>(
      context: context,
      mobile: mobileScale ?? 0.9,
      tablet: tabletScale ?? 1.0,
      smallLaptop: 1.0,
      desktop: desktopScale ?? 1.1,
      largeDesktop: 1.2,
    );

    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14.0) * scale,
    );
  }
}

class _DebugOverlay extends StatelessWidget {
  final ResponsiveInfo info;

  const _DebugOverlay({required this.info});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.7),
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Device: ${info.deviceType.name}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Size: ${info.screenWidth.toInt()}x${info.screenHeight.toInt()}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
          Text(
            'Pixel Ratio: ${info.pixelRatio.toStringAsFixed(1)}',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

// Enhanced extension with all convenience methods
extension ResponsiveContext on BuildContext {
  ResponsiveInfo get responsive => ResponsiveHelper.getInfo(this);
  ResponsiveConfig get responsiveConfig => ResponsiveProvider.configOf(this);

  // Quick access to device type checks
  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isSmallLaptop => responsive.isSmallLaptop;
  bool get isDesktop => responsive.isDesktop;
  bool get isLargeDesktop => responsive.isLargeDesktop;

  // Utility checks
  bool get isMobileOrTablet => responsive.isMobileOrTablet;
  bool get isDesktopOrLarger => responsive.isDesktopOrLarger;

  // Enhanced responsiveValue method
  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? smallLaptop,
    T? desktop,
    T? largeDesktop,
  }) =>
      ResponsiveHelper.getResponsiveValue<T>(
        context: this,
        mobile: mobile,
        tablet: tablet,
        smallLaptop: smallLaptop,
        desktop: desktop,
        largeDesktop: largeDesktop,
      );

  // Padding convenience methods
  EdgeInsets get defaultPadding =>
      responsiveConfig.defaultPadding[responsive.deviceType] ??
      const EdgeInsets.all(16.0);

  EdgeInsets responsivePadding({
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? smallLaptop,
    EdgeInsets? desktop,
    EdgeInsets? largeDesktop,
  }) {
    return responsiveValue<EdgeInsets>(
      mobile: mobile ?? responsiveConfig.defaultPadding[DeviceType.mobile]!,
      tablet: tablet ?? responsiveConfig.defaultPadding[DeviceType.tablet],
      smallLaptop: smallLaptop ??
          responsiveConfig.defaultPadding[DeviceType.smallLaptop],
      desktop: desktop ?? responsiveConfig.defaultPadding[DeviceType.desktop],
      largeDesktop: largeDesktop ??
          responsiveConfig.defaultPadding[DeviceType.largeDesktop],
    );
  }

  // Spacing convenience methods
  double get spacing => ResponsiveHelper.getSpacing(this);
  double spacingScale(double scale) =>
      ResponsiveHelper.getSpacing(this, scale: scale);

  // Content width convenience
  double get contentWidth => ResponsiveHelper.getContentWidth(this);

// Get default text style with responsive scaling
  TextStyle responsiveTextStyle(
    TextStyle baseStyle, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    return ResponsiveHelper.getResponsiveTextStyle(
      this,
      baseStyle,
      mobileScale: mobileScale,
      tabletScale: tabletScale,
      desktopScale: desktopScale,
    );
  }
}
