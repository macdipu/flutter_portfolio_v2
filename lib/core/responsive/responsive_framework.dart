import 'package:flutter/material.dart';

enum DeviceType {
  mobile,
  tablet,
  smallLaptop, // 13-14 inch laptops
  desktop,
  largeDesktop, // Added for ultra-wide screens
}

class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double smallLaptop =
      1366; // 13-14 inch laptops (1366x768, 1440x900)
  static const double desktop = 1680; // 15+ inch laptops and desktops
  static const double largeDesktop = 1920;

  // Custom breakpoints for specific use cases
  static const double smallMobile = 360;
  static const double largeMobile = 480;
}

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, DeviceType deviceType,
      BoxConstraints constraints) builder;

  const ResponsiveBuilder({
    super.key,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final deviceType = _getDeviceType(constraints.maxWidth);
        return builder(context, deviceType, constraints);
      },
    );
  }

  DeviceType _getDeviceType(double width) {
    if (width < ResponsiveBreakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < ResponsiveBreakpoints.tablet) {
      return DeviceType.tablet;
    } else if (width < ResponsiveBreakpoints.smallLaptop) {
      return DeviceType.smallLaptop;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }
}

// Enhanced responsive widget that can handle different layouts
class ResponsiveWidget extends StatelessWidget {
  final Widget? mobile;
  final Widget? tablet;
  final Widget? smallLaptop;
  final Widget? desktop;
  final Widget? largeDesktop;
  final Widget? fallback; // Fallback widget if specific device widget is null

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
      builder: (context, deviceType, constraints) {
        switch (deviceType) {
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
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < ResponsiveBreakpoints.mobile;
  }

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.mobile &&
        width < ResponsiveBreakpoints.tablet;
  }

  static bool isSmallLaptop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.tablet &&
        width < ResponsiveBreakpoints.smallLaptop;
  }

  static bool isDesktop(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= ResponsiveBreakpoints.smallLaptop &&
        width < ResponsiveBreakpoints.desktop;
  }

  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= ResponsiveBreakpoints.desktop;
  }

  static DeviceType getDeviceType(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width < ResponsiveBreakpoints.mobile) {
      return DeviceType.mobile;
    } else if (width < ResponsiveBreakpoints.tablet) {
      return DeviceType.tablet;
    } else if (width < ResponsiveBreakpoints.smallLaptop) {
      return DeviceType.smallLaptop;
    } else if (width < ResponsiveBreakpoints.desktop) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  // Generic responsive value getter with optional large desktop support
  static T getResponsiveValue<T>({
    required BuildContext context,
    required T mobile,
    T? tablet,
    T? smallLaptop,
    T? desktop,
    T? largeDesktop,
  }) {
    final deviceType = getDeviceType(context);
    switch (deviceType) {
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

  // Improved responsive padding with more granular control
  static EdgeInsets getResponsivePadding(
    BuildContext context, {
    EdgeInsets? mobile,
    EdgeInsets? tablet,
    EdgeInsets? smallLaptop,
    EdgeInsets? desktop,
    EdgeInsets? largeDesktop,
  }) {
    return getResponsiveValue<EdgeInsets>(
      context: context,
      mobile: mobile ?? const EdgeInsets.all(16.0),
      tablet: tablet ?? const EdgeInsets.all(24.0),
      smallLaptop: smallLaptop ?? const EdgeInsets.all(28.0),
      desktop: desktop ?? const EdgeInsets.all(32.0),
      largeDesktop: largeDesktop ?? const EdgeInsets.all(48.0),
    );
  }

  // Smart content width that prevents content from becoming too wide
  static double getContentWidth(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const maxContentWidth = 1200.0; // Maximum content width

    if (screenWidth > maxContentWidth + 128) {
      // 64px padding on each side
      return maxContentWidth;
    }

    return getResponsiveValue<double>(
      context: context,
      mobile: screenWidth - 32, // 16px padding on each side
      tablet: screenWidth - 64, // 32px padding on each side
      smallLaptop: screenWidth - 96, // 48px padding on each side
      desktop: screenWidth - 128, // 64px padding on each side
    );
  }

  // Grid columns helper
  static int getGridColumns(BuildContext context) {
    return getResponsiveValue<int>(
      context: context,
      mobile: 1,
      tablet: 2,
      smallLaptop: 2,
      desktop: 3,
      largeDesktop: 4,
    );
  }

  // Font size helper
  static double getFontSize(
    BuildContext context, {
    double? mobile,
    double? tablet,
    double? smallLaptop,
    double? desktop,
    double? largeDesktop,
  }) {
    return getResponsiveValue<double>(
      context: context,
      mobile: mobile ?? 14.0,
      tablet: tablet ?? 16.0,
      smallLaptop: smallLaptop ?? 16.0,
      desktop: desktop ?? 18.0,
      largeDesktop: largeDesktop ?? 20.0,
    );
  }
}

// Extension for easier access
extension ResponsiveContext on BuildContext {
  bool get isMobile => ResponsiveHelper.isMobile(this);
  bool get isTablet => ResponsiveHelper.isTablet(this);
  bool get isSmallLaptop => ResponsiveHelper.isSmallLaptop(this);
  bool get isDesktop => ResponsiveHelper.isDesktop(this);
  bool get isLargeDesktop => ResponsiveHelper.isLargeDesktop(this);
  DeviceType get deviceType => ResponsiveHelper.getDeviceType(this);

  T responsive<T>({
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
}
