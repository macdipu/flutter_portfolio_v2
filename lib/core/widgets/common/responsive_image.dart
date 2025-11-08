import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:any_image_view/any_image_view.dart';

class ResponsiveImage extends StatefulWidget {
  final Object? imagePath;
  final String? altText;
  final Widget? placeholderWidget;
  final Widget? errorWidget;
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

  const ResponsiveImage({
    super.key,
    required this.imagePath,
    this.altText,
    this.placeholderWidget,
    this.errorWidget,
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

  @override
  State<ResponsiveImage> createState() => _ResponsiveImageState();
}

class _ResponsiveImageState extends State<ResponsiveImage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

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
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final responsiveSize = _getResponsiveSize(context);
    final effectiveWidth = widget.maxWidth != null
        ? responsiveSize.width > widget.maxWidth!
            ? widget.maxWidth!
            : responsiveSize.width
        : responsiveSize.width;
    final effectiveHeight = widget.maxHeight != null
        ? responsiveSize.height > widget.maxHeight!
            ? widget.maxHeight!
            : responsiveSize.height
        : responsiveSize.height;

    Widget imageWidget = _buildImageContent(effectiveWidth, effectiveHeight);

    if (widget.heroTag != null) {
      imageWidget = Hero(
        tag: widget.heroTag!,
        child: imageWidget,
      );
    }

    // Add hover effect for web
    if (widget.enableHoverEffect) {
      imageWidget = MouseRegion(
        onEnter: (_) => _onHover(true),
        onExit: (_) => _onHover(false),
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: imageWidget,
            );
          },
        ),
      );
    }

    // Add tap functionality
    if (widget.onTap != null) {
      imageWidget = GestureDetector(
        onTap: widget.onTap,
        child: imageWidget,
      );
    }

    // Add margin if specified
    if (widget.margin != null) {
      imageWidget = Padding(
        padding: widget.margin!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  void _onHover(bool isHovered) {
    if (!mounted) return;
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

  Widget _buildImageContent(double width, double height) {
    final borderRadius = widget.isCircular
        ? BorderRadius.circular(width / 2)
        : widget.borderRadius;

    final defaultShadow = [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.1),
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
      child: widget.imagePath != null
          ? _buildHeroImage(width, height)
          : _buildPlaceholder(width, height),
    );
  }

  Widget _buildHeroImage(double width, double height) {
    if (widget.imagePath is String && (widget.imagePath as String).startsWith('http')) {
      return Image.network(
        widget.imagePath as String,
        height: height,
        width: width,
        fit: widget.fit,
        loadingBuilder: widget.enableLoadingAnimation
            ? (BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: width,
                  height: height,
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                );
              }
            : null,
        errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
          return widget.errorWidget ?? _buildErrorPlaceholder(width, height);
        },
      );
    } else {
      return SizedBox(
        width: width,
        height: height,
        child: AnyImageView(
          imagePath: widget.imagePath,
          fit: widget.fit,
          placeholderWidget: widget.enableLoadingAnimation
              ? Container(
                  width: width,
                  height: height,
                  color: Colors.grey[100],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                  ),
                )
              : null,
          errorWidget: widget.errorWidget ?? _buildErrorPlaceholder(width, height),
          fadeDuration: const Duration(milliseconds: 400),
        ),
      );
    }
  }

  Widget _buildPlaceholder(double width, double height) {
    if (widget.placeholderWidget != null) {
      return widget.placeholderWidget!;
    } else {
      return Container(
        width: width,
        height: height,
        color: Colors.grey[200],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.image_outlined,
              size: width * 0.25,
              color: Colors.grey[400],
            ),
          ],
        ),
      );
    }
  }

  Widget _buildErrorPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.red[50],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: width * 0.25,
            color: Colors.red[300],
          ),
          const SizedBox(height: 8),
          Text(
            'Failed to load image',
            style: TextStyle(
              fontSize: width * 0.03,
              color: Colors.red[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
