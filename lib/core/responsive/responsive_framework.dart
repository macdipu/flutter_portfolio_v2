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

  final Map<DeviceType, double>? custom;

  const ResponsiveBreakpoints({this.custom});

  double _scaled(double base, double pixelRatio, bool useDensity) {
    if (!useDensity) return base;
    return base * math.min(pixelRatio, 2.0);
  }

  double value(DeviceType type, double pixelRatio, bool useDensity) {
    final base = custom?[type] ?? switch (type) {
      DeviceType.mobile       => mobile,
      DeviceType.tablet       => tablet,
      DeviceType.smallLaptop  => smallLaptop,
      DeviceType.desktop      => desktop,
      DeviceType.largeDesktop => largeDesktop,
    };
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
    this.densityAware = false,
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

/// Package-private helper — resolves DeviceType without allocating a widget.
DeviceType _resolveDeviceType(
    double width, double pixelRatio, ResponsiveConfig config) {
  final bp = config.breakpoints;
  final d = config.densityAware;
  if (width < bp.value(DeviceType.mobile, pixelRatio, d)) return DeviceType.mobile;
  if (width < bp.value(DeviceType.tablet, pixelRatio, d)) return DeviceType.tablet;
  if (width < bp.value(DeviceType.smallLaptop, pixelRatio, d)) return DeviceType.smallLaptop;
  if (width < bp.value(DeviceType.desktop, pixelRatio, d)) return DeviceType.desktop;
  return DeviceType.largeDesktop;
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

  @override
  Widget build(BuildContext context) {
    final size       = MediaQuery.sizeOf(context);
    final padding    = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final config     = ResponsiveProvider.of(context);

    final info = ResponsiveInfo(
      deviceType: _resolveDeviceType(size.width, pixelRatio, config),
      width: size.width,
      height: size.height,
      portrait: size.height >= size.width,
      pixelRatio: pixelRatio,
      padding: padding,
      viewInsets: viewInsets,
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
            return smallLaptop ?? tablet ?? mobile ?? fallback ?? const SizedBox.shrink();
          case DeviceType.desktop:
            return desktop ?? smallLaptop ?? tablet ?? mobile ?? fallback ?? const SizedBox.shrink();
          case DeviceType.largeDesktop:
            return largeDesktop ?? desktop ?? smallLaptop ?? tablet ?? mobile ?? fallback ?? const SizedBox.shrink();
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
    final size       = MediaQuery.sizeOf(context);
    final padding    = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final pixelRatio = MediaQuery.devicePixelRatioOf(context);
    final config     = ResponsiveProvider.of(context);
    return ResponsiveInfo(
      deviceType: _resolveDeviceType(size.width, pixelRatio, config),
      width: size.width,
      height: size.height,
      portrait: size.height >= size.width,
      pixelRatio: pixelRatio,
      padding: padding,
      viewInsets: viewInsets,
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
      largeDesktop: largeDesktop ?? config.defaultPadding[DeviceType.largeDesktop],
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
    final max = switch (i.deviceType) {
      DeviceType.tablet       => 720.0,
      DeviceType.smallLaptop  => 860.0,
      DeviceType.desktop      => 1024.0,
      DeviceType.largeDesktop => config.maxContentWidth,
      _                       => double.infinity,
    };
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
    return style.copyWith(fontSize: (style.fontSize ?? 14) * scale);
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
      color: Colors.black.withAlpha(178),
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
  bool get isSmallLaptop => responsive.isSmallLaptop;
  bool get isDesktop => responsive.isDesktop;
  bool get isLargeDesktop => responsive.isLargeDesktop;
  bool get isMobileOrTablet => responsive.isMobileOrTablet;
  bool get isDesktopOrAbove => responsive.isDesktopOrAbove;

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
