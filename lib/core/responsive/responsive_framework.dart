import 'dart:math' as math;
import 'package:flutter/material.dart';

/// ----------------------------------------------
/// DEVICE TYPES
/// ----------------------------------------------
enum DeviceType {
  mobile,
  tablet,
  smallLaptop,
  desktop,
  largeDesktop,
}

/// ----------------------------------------------
/// BREAKPOINTS (also density-aware)
/// ----------------------------------------------
class ResponsiveBreakpoints {
  static const double mobile = 600;
  static const double tablet = 1024;
  static const double smallLaptop = 1366;
  static const double desktop = 1680;
  static const double largeDesktop = 1920;

  /// Optional custom breakpoints override
  final Map<DeviceType, double>? custom;

  const ResponsiveBreakpoints({this.custom});

  double _scaled(double base, double pixelRatio, bool useDensity) {
    if (!useDensity) return base;
    return base * math.min(pixelRatio, 2.0);
  }

  double value(DeviceType type, double pixelRatio, bool useDensity) {
    final base = custom?[type] ??
        {
          DeviceType.mobile: mobile,
          DeviceType.tablet: tablet,
          DeviceType.smallLaptop: smallLaptop,
          DeviceType.desktop: desktop,
          DeviceType.largeDesktop: largeDesktop,
        }[type]!;
    return _scaled(base, pixelRatio, useDensity);
  }
}

/// ----------------------------------------------
/// CONFIG
/// ----------------------------------------------
class ResponsiveConfig {
  final bool densityAware;
  final double maxContentWidth;
  final Map<DeviceType, EdgeInsets> defaultPadding;
  final ResponsiveBreakpoints breakpoints;
  final bool debugOverlay;

  const ResponsiveConfig({
    this.densityAware = true,
    this.maxContentWidth = 1400.0,
    this.breakpoints = const ResponsiveBreakpoints(),
    this.debugOverlay = false,
    this.defaultPadding = const {
      DeviceType.mobile: EdgeInsets.all(16),
      DeviceType.tablet: EdgeInsets.all(24),
      DeviceType.smallLaptop: EdgeInsets.all(28),
      DeviceType.desktop: EdgeInsets.all(32),
      DeviceType.largeDesktop: EdgeInsets.all(48),
    },
  });
}

/// ----------------------------------------------
/// INHERITED PROVIDER (cached for performance)
/// ----------------------------------------------
class ResponsiveProvider extends InheritedWidget {
  final ResponsiveConfig config;

  const ResponsiveProvider({
    super.key,
    required this.config,
    required super.child,
  });

  static ResponsiveConfig of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ResponsiveProvider>()?.config ??
      const ResponsiveConfig();

  @override
  bool updateShouldNotify(ResponsiveProvider oldWidget) =>
      oldWidget.config != config;
}

/// ----------------------------------------------
/// DATA MODEL (cached snapshot of layout)
/// ----------------------------------------------
class ResponsiveInfo {
  final DeviceType deviceType;
  final double width;
  final double height;
  final bool portrait;
  final double pixelRatio;
  final EdgeInsets padding;
  final EdgeInsets viewInsets;

  const ResponsiveInfo({
    required this.deviceType,
    required this.width,
    required this.height,
    required this.portrait,
    required this.pixelRatio,
    required this.padding,
    required this.viewInsets,
  });

  bool get isMobile => deviceType == DeviceType.mobile;
  bool get isTablet => deviceType == DeviceType.tablet;
  bool get isSmallLaptop => deviceType == DeviceType.smallLaptop;
  bool get isDesktop => deviceType == DeviceType.desktop;
  bool get isLargeDesktop => deviceType == DeviceType.largeDesktop;

  bool get isMobileOrTablet => isMobile || isTablet;
  bool get isDesktopOrAbove => isDesktop || isLargeDesktop;

  double get availableWidth => width - padding.horizontal;
  double get availableHeight =>
      height - padding.vertical - viewInsets.vertical;
}

/// ----------------------------------------------
/// RESPONSIVE BUILDER
/// ----------------------------------------------
class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, ResponsiveInfo info) builder;

  const ResponsiveBuilder({super.key, required this.builder});

  DeviceType _resolveType(
      double width, double pixelRatio, ResponsiveConfig config) {
    final bp = config.breakpoints;
    final d = config.densityAware;

    if (width < bp.value(DeviceType.mobile, pixelRatio, d)) {
      return DeviceType.mobile;
    } else if (width < bp.value(DeviceType.tablet, pixelRatio, d)) {
      return DeviceType.tablet;
    } else if (width < bp.value(DeviceType.smallLaptop, pixelRatio, d)) {
      return DeviceType.smallLaptop;
    } else if (width < bp.value(DeviceType.desktop, pixelRatio, d)) {
      return DeviceType.desktop;
    } else {
      return DeviceType.largeDesktop;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final config = ResponsiveProvider.of(context);

    final info = ResponsiveInfo(
      deviceType: _resolveType(mq.size.width, mq.devicePixelRatio, config),
      width: mq.size.width,
      height: mq.size.height,
      portrait: mq.orientation == Orientation.portrait,
      pixelRatio: mq.devicePixelRatio,
      padding: mq.padding,
      viewInsets: mq.viewInsets,
    );

    Widget child = builder(context, info);

    if (config.debugOverlay) {
      child = Stack(children: [
        child,
        Positioned(top: 0, right: 0, child: _DebugOverlay(info)),
      ]);
    }

    return child;
  }
}

/// ----------------------------------------------
/// RESPONSIVE WIDGET (simple switch)
/// ----------------------------------------------
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

/// ----------------------------------------------
/// HELPER API
/// ----------------------------------------------
class ResponsiveHelper {
  static ResponsiveInfo info(BuildContext context) {
    final mq = MediaQuery.of(context);
    final config = ResponsiveProvider.of(context);

    final builder = ResponsiveBuilder(builder: (_, __) => const SizedBox());
    final type = builder._resolveType(
        mq.size.width, mq.devicePixelRatio, config);

    return ResponsiveInfo(
      deviceType: type,
      width: mq.size.width,
      height: mq.size.height,
      portrait: mq.orientation == Orientation.portrait,
      pixelRatio: mq.devicePixelRatio,
      padding: mq.padding,
      viewInsets: mq.viewInsets,
    );
  }

  static T value<T>(
    BuildContext context, {
    required T mobile,
    T? tablet,
    T? smallLaptop,
    T? desktop,
    T? largeDesktop,
  }) {
    final i = info(context);

    switch (i.deviceType) {
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

  static EdgeInsets padding(BuildContext context,
      {EdgeInsets? mobile,
      EdgeInsets? tablet,
      EdgeInsets? smallLaptop,
      EdgeInsets? desktop,
      EdgeInsets? largeDesktop}) {
    final config = ResponsiveProvider.of(context);

    return value(
      context,
      mobile: mobile ?? config.defaultPadding[DeviceType.mobile]!,
      tablet: tablet ?? config.defaultPadding[DeviceType.tablet],
      smallLaptop: smallLaptop ?? config.defaultPadding[DeviceType.smallLaptop],
      desktop: desktop ?? config.defaultPadding[DeviceType.desktop],
      largeDesktop: largeDesktop ??
          config.defaultPadding[DeviceType.largeDesktop],
    );
  }

  static double spacing(BuildContext context, {double scale = 1.0}) {
    return value<double>(
      context,
      mobile: 8 * scale,
      tablet: 12 * scale,
      smallLaptop: 16 * scale,
      desktop: 20 * scale,
      largeDesktop: 24 * scale,
    );
  }

  static double contentWidth(BuildContext context) {
    final config = ResponsiveProvider.of(context);
    final i = info(context);

    if (i.isMobile) return double.infinity;
    final max = value<double>(
      context,
      mobile: double.infinity,
      tablet: 720,
      smallLaptop: 860,
      desktop: 1024,
      largeDesktop: config.maxContentWidth,
    );

    return math.min(max, i.width * .9);
  }

  static TextStyle text(
    BuildContext context,
    TextStyle style, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) {
    final scale = value<double>(
      context,
      mobile: mobileScale ?? .9,
      tablet: tabletScale ?? 1,
      smallLaptop: 1,
      desktop: desktopScale ?? 1.1,
      largeDesktop: 1.2,
    );

    return style.copyWith(
      fontSize: (style.fontSize ?? 14) * scale,
    );
  }
}

/// ----------------------------------------------
/// DEBUG OVERLAY
/// ----------------------------------------------
class _DebugOverlay extends StatelessWidget {
  final ResponsiveInfo info;
  const _DebugOverlay(this.info);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      color: Colors.black.withValues(alpha: .7),
      child: Text(
        '${info.deviceType.name}\n${info.width.toInt()}x${info.height.toInt()}',
        style: const TextStyle(color: Colors.white, fontSize: 10),
      ),
    );
  }
}

/// ----------------------------------------------
/// EXTENSIONS
/// ----------------------------------------------
extension ResponsiveContext on BuildContext {
  ResponsiveInfo get responsive => ResponsiveHelper.info(this);

  bool get isMobile => responsive.isMobile;
  bool get isTablet => responsive.isTablet;
  bool get isDesktop => responsive.isDesktop;
  bool get isLargeDesktop => responsive.isLargeDesktop;
  bool get isMobileOrTablet => responsive.isMobileOrTablet;

  EdgeInsets get defaultPadding =>
      ResponsiveProvider.of(this).defaultPadding[responsive.deviceType] ??
      const EdgeInsets.all(16);

  double get spacing => ResponsiveHelper.spacing(this);
  double spacingScale(double s) => ResponsiveHelper.spacing(this, scale: s);

  double get contentWidth => ResponsiveHelper.contentWidth(this);

  T responsiveValue<T>({
    required T mobile,
    T? tablet,
    T? smallLaptop,
    T? desktop,
    T? largeDesktop,
  }) =>
      ResponsiveHelper.value(
        this,
        mobile: mobile,
        tablet: tablet,
        smallLaptop: smallLaptop,
        desktop: desktop,
        largeDesktop: largeDesktop,
      );

  TextStyle responsiveText(
    TextStyle base, {
    double? mobileScale,
    double? tabletScale,
    double? desktopScale,
  }) =>
      ResponsiveHelper.text(
        this,
        base,
        mobileScale: mobileScale,
        tabletScale: tabletScale,
        desktopScale: desktopScale,
      );
}
