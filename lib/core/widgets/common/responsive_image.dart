import 'package:any_image_view/any_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/widgets/common/base_responsive_image.dart';

class ResponsiveImage extends BaseResponsiveImage {
  const ResponsiveImage({
    super.key,
    required super.imageUrl,
    super.altText,
    super.placeholder,
    super.width,
    super.height,
    super.aspectRatio,
    super.fit,
    super.borderRadius,
    super.mobileSize,
    super.tabletSize,
    super.smallLaptopSize,
    super.desktopSize,
    super.largeDesktopSize,
    super.boxShadow,
    super.enableHoverEffect,
    super.enableLoadingAnimation,
    super.backgroundColor,
    super.padding,
    super.margin,
    super.onTap,
    super.heroTag,
    super.isCircular,
    super.maxWidth,
    super.maxHeight,
  });

  @override
  State<ResponsiveImage> createState() => _ResponsiveImageState();
}

class _ResponsiveImageState
    extends BaseResponsiveImageState<ResponsiveImage> {
  @override
  Widget buildImageWidget(
    double width,
    double height,
    BoxShape shape,
    BorderRadius? borderRadius,
  ) {
    return AnyImageView(
      imagePath: widget.imageUrl,
      width: width,
      height: height,
      fit: widget.fit,
      shape: shape,
      borderRadius: shape == BoxShape.rectangle ? borderRadius : null,
      placeholderWidget: widget.enableLoadingAnimation
          ? buildLoadingPlaceholder(width, height)
          : null,
      errorWidget: buildErrorPlaceholder(width, height),
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
