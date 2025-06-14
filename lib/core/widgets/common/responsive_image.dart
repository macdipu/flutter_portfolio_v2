import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class ResponsiveImage extends StatefulWidget {
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

  const ResponsiveImage({
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

  @override
  State<ResponsiveImage> createState() => _ResponsiveImageState();
}

class _ResponsiveImageState extends State<ResponsiveImage>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  bool _isLoading = true;
  bool _hasError = false;
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

    // Add hero animation if heroTag is provided
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
    setState(() {
      _isHovered = isHovered;
    });
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
        color: Colors.black.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 4),
        spreadRadius: 0,
      ),
    ];

    return Container(
      width: width,
      height: height,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
        borderRadius: borderRadius,
        boxShadow: widget.boxShadow ?? defaultShadow,
      ),
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: widget.imageUrl.isNotEmpty
          ? _buildNetworkImage(width, height)
          : _buildPlaceholder(width, height),
    );
  }

  Widget _buildNetworkImage(double width, double height) {
    return Image.network(
      widget.imageUrl,
      fit: widget.fit,
      width: width,
      height: height,
      loadingBuilder: widget.enableLoadingAnimation
          ? (context, child, loadingProgress) {
              if (loadingProgress == null) {
                _isLoading = false;
                return child;
              }
              return _buildLoadingIndicator(width, height, loadingProgress);
            }
          : null,
      errorBuilder: (context, error, stackTrace) {
        _hasError = true;
        return _buildErrorPlaceholder(width, height);
      },
      semanticLabel: widget.altText,
    );
  }

  Widget _buildLoadingIndicator(
      double width, double height, ImageChunkEvent loadingProgress) {
    final progress = loadingProgress.expectedTotalBytes != null
        ? loadingProgress.cumulativeBytesLoaded /
            loadingProgress.expectedTotalBytes!
        : null;

    return Container(
      width: width,
      height: height,
      color: Colors.grey[100],
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: width * 0.2,
              height: width * 0.2,
              child: CircularProgressIndicator(
                value: progress,
                strokeWidth: 2,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).primaryColor,
                ),
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  fontSize: width * 0.03,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(double width, double height) {
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
          if (widget.placeholder != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.placeholder!,
              style: TextStyle(
                fontSize: width * 0.03,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ],
      ),
    );
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

// Specialized responsive image widgets for common use cases
class ResponsiveAvatar extends ResponsiveImage {
  const ResponsiveAvatar({
    super.key,
    required super.imageUrl,
    super.altText,
    super.mobileSize = 60,
    super.tabletSize = 80,
    super.smallLaptopSize = 100,
    super.desktopSize = 120,
    super.largeDesktopSize = 140,
    super.enableHoverEffect = true,
    super.onTap,
    super.heroTag,
  }) : super(
          isCircular: true,
          fit: BoxFit.cover,
        );
}

class ResponsiveProjectImage extends ResponsiveImage {
  const ResponsiveProjectImage({
    super.key,
    required super.imageUrl,
    super.altText,
    super.aspectRatio = 16 / 9,
    super.borderRadius = const BorderRadius.all(Radius.circular(12)),
    super.enableHoverEffect = true,
    super.enableLoadingAnimation = true,
    super.onTap,
    super.heroTag,
    super.mobileSize = 300,
    super.tabletSize = 400,
    super.smallLaptopSize = 450,
    super.desktopSize = 500,
    super.largeDesktopSize = 600,
  });
}

class ResponsiveGalleryImage extends ResponsiveImage {
  const ResponsiveGalleryImage({
    super.key,
    required super.imageUrl,
    super.altText,
    super.aspectRatio = 1,
    super.borderRadius = const BorderRadius.all(Radius.circular(8)),
    super.enableHoverEffect = true,
    super.onTap,
    super.heroTag,
    super.mobileSize = 150,
    super.tabletSize = 200,
    super.smallLaptopSize = 220,
    super.desktopSize = 250,
    super.largeDesktopSize = 280,
  });
}
