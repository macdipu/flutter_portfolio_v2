import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

/// Base abstraction for responsive images that need consistent sizing,
/// hover/tap affordances, and placeholder/error handling.
abstract class BaseResponsiveImage extends StatefulWidget {
  final String imageUrl;
  final String? altText;
  final String? placeholder;
  final double? width;
  final double? height;
  final double? aspectRatio;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? mobileSize;
  final double? tabletSize;
  final double? smallLaptopSize;
  final double? desktopSize;
  final double? largeDesktopSize;
  final List<BoxShadow>? boxShadow;
  final bool enableHoverEffect;
  final bool enableLoadingAnimation;
  final Color? backgroundColor;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final VoidCallback? onTap;
  final String? heroTag;
  final bool isCircular;
  final double? maxWidth;
  final double? maxHeight;

  const BaseResponsiveImage({
    super.key,
    required this.imageUrl,
    this.altText,
    this.placeholder,
    this.width,
    this.height,
    this.aspectRatio,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.mobileSize,
    this.tabletSize,
    this.smallLaptopSize,
    this.desktopSize,
    this.largeDesktopSize,
    this.boxShadow,
    this.enableHoverEffect = false,
    this.enableLoadingAnimation = true,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.onTap,
    this.heroTag,
    this.isCircular = false,
    this.maxWidth,
    this.maxHeight,
  });
}

abstract class BaseResponsiveImageState<T extends BaseResponsiveImage>
    extends State<T> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final resolvedSize = _resolveSize(context, constraints);
        Widget imageWidget =
            _buildImageContent(resolvedSize.width, resolvedSize.height);

        if (widget.heroTag != null) {
          imageWidget = Hero(tag: widget.heroTag!, child: imageWidget);
        }

        if (widget.enableHoverEffect) {
          imageWidget = MouseRegion(
            onEnter: (_) => _onHover(true),
            onExit: (_) => _onHover(false),
            child: AnimatedBuilder(
              animation: _scaleAnimation,
              child: imageWidget,
              builder: (context, child) => Transform.scale(
                scale: _scaleAnimation.value,
                child: child,
              ),
            ),
          );
        }

        if (widget.onTap != null) {
          imageWidget = GestureDetector(
            onTap: widget.onTap,
            child: imageWidget,
          );
        }

        if (widget.margin != null) {
          imageWidget = Padding(
            padding: widget.margin!,
            child: imageWidget,
          );
        }

        return imageWidget;
      },
    );
  }

  void _onHover(bool isHovered) {
    if (isHovered) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  Size _getResponsiveSize(BuildContext context) {
    final double responsiveWidth = context.responsiveValue(
      mobile: widget.mobileSize ?? widget.width ?? 150.0,
      tablet: widget.tabletSize ?? widget.width ?? 200.0,
      smallLaptop: widget.smallLaptopSize ?? widget.width ?? 220.0,
      desktop: widget.desktopSize ?? widget.width ?? 250.0,
      largeDesktop: widget.largeDesktopSize ?? widget.width ?? 280.0,
    );

    double responsiveHeight;
    if (widget.height != null) {
      responsiveHeight = widget.height!;
    } else if (widget.aspectRatio != null) {
      responsiveHeight = responsiveWidth / widget.aspectRatio!;
    } else {
      responsiveHeight = responsiveWidth;
    }

    return Size(responsiveWidth, responsiveHeight);
  }

  Size _resolveSize(BuildContext context, BoxConstraints constraints) {
    final target = _getResponsiveSize(context);
    final width = _resolveWidth(target.width, constraints);
    final height = _resolveHeight(target.height, width, constraints);
    return Size(width, height);
  }

  double _resolveWidth(double targetWidth, BoxConstraints constraints) {
    final fallback = _fallbackDimension(
      constraints.hasBoundedWidth ? constraints.maxWidth : widget.maxWidth,
      defaultValue: 200,
    );
    double width = _sanitizeDimension(targetWidth, fallback);
    if (widget.maxWidth != null) {
      width = math.min(width, widget.maxWidth!);
    }
    if (constraints.hasBoundedWidth) {
      width = width.clamp(constraints.minWidth, constraints.maxWidth);
    }
    return width;
  }

  double _resolveHeight(
    double targetHeight,
    double resolvedWidth,
    BoxConstraints constraints,
  ) {
    final aspectHeight = _aspectRatioHeight(resolvedWidth);
    final fallback = _fallbackDimension(
      constraints.hasBoundedHeight ? constraints.maxHeight : widget.maxHeight,
      defaultValue: aspectHeight,
    );
    double height = _sanitizeDimension(targetHeight, fallback);
    if (widget.aspectRatio != null && widget.aspectRatio! > 0) {
      height = resolvedWidth / widget.aspectRatio!;
    }
    if (widget.maxHeight != null) {
      height = math.min(height, widget.maxHeight!);
    }
    if (constraints.hasBoundedHeight) {
      height = height.clamp(constraints.minHeight, constraints.maxHeight);
    }
    return height;
  }

  double _aspectRatioHeight(double width) {
    if (widget.aspectRatio != null && widget.aspectRatio! > 0) {
      return width / widget.aspectRatio!;
    }
    return width;
  }

  double _sanitizeDimension(double value, double fallback) {
    if (value.isNaN || !value.isFinite || value <= 0) {
      return fallback;
    }
    return value;
  }

  double _fallbackDimension(double? candidate, {required double defaultValue}) {
    if (candidate != null && candidate.isFinite && candidate > 0) {
      return candidate;
    }
    return defaultValue;
  }

  Widget _buildImageContent(double width, double height) {
    final borderRadius = widget.isCircular
        ? BorderRadius.circular(width / 2)
        : widget.borderRadius;
    final shape = widget.isCircular ? BoxShape.circle : BoxShape.rectangle;

    final defaultShadow = [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];

    return Container(
      width: width,
      height: height,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: borderRadius,
        boxShadow: widget.boxShadow ?? defaultShadow,
      ),
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: widget.imageUrl.isNotEmpty
          ? buildImageWidget(width, height, shape, borderRadius)
          : buildPlaceholder(width, height),
    );
  }

  @protected
  Widget buildImageWidget(
    double width,
    double height,
    BoxShape shape,
    BorderRadius? borderRadius,
  );

  @protected
  Widget buildLoadingPlaceholder(double width, double height) {
    final spinnerSize = _placeholderIconSize(width, fraction: 0.2);
    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: SizedBox(
          width: spinnerSize,
          height: spinnerSize,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            backgroundColor: Colors.grey[300],
            valueColor: AlwaysStoppedAnimation<Color>(
              Theme.of(context).primaryColor,
            ),
          ),
        ),
      ),
    );
  }

  @protected
  Widget buildPlaceholder(double width, double height) {
    final iconSize = _placeholderIconSize(width);
    final fontSize = _placeholderFontSize(width);
    return Container(
      width: width,
      height: height,
      color: Colors.grey[200],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            size: iconSize,
            color: Colors.grey[400],
          ),
          if (widget.placeholder != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.placeholder!,
              style: TextStyle(
                fontSize: fontSize,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
  }

  @protected
  Widget buildErrorPlaceholder(double width, double height) {
    final iconSize = _placeholderIconSize(width);
    final fontSize = _placeholderFontSize(width);
    return Container(
      width: width,
      height: height,
      color: Colors.red[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: iconSize,
            color: Colors.red[300],
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  double _placeholderIconSize(double width, {double fraction = 0.25}) {
    if (!width.isFinite || width <= 0) {
      return 48;
    }
    final size = width * fraction;
    return size.clamp(24, 96).toDouble();
  }

  double _placeholderFontSize(double width) {
    if (!width.isFinite || width <= 0) {
      return 12;
    }
    final size = width * 0.03;
    return size.clamp(10, 18).toDouble();
  }
}
