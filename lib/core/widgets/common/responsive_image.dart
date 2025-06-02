import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class ResponsiveImage extends StatelessWidget {
  final String imageUrl;
  final String? placeholder;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final double? mobileSize;
  final double? tabletSize;
  final double? desktopSize;

  const ResponsiveImage({
    super.key,
    required this.imageUrl,
    this.placeholder,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.mobileSize,
    this.tabletSize,
    this.desktopSize,
  });

  @override
  Widget build(BuildContext context) {
    final responsiveSize = ResponsiveHelper.getResponsiveValue(
      context: context,
      mobile: mobileSize ?? width ?? 150.0,
      tablet: tabletSize ?? width ?? 200.0,
      desktop: desktopSize ?? width ?? 250.0,
    );

    return Container(
      width: responsiveSize,
      height: height ?? responsiveSize,
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: borderRadius != null ? Clip.antiAlias : Clip.none,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: fit,
              width: responsiveSize,
              height: height ?? responsiveSize,
              errorBuilder: (context, error, stackTrace) {
                return _buildPlaceholder(
                    responsiveSize, height ?? responsiveSize);
              },
            )
          : _buildPlaceholder(responsiveSize, height ?? responsiveSize),
    );
  }

  Widget _buildPlaceholder(double width, double height) {
    return Container(
      width: width,
      height: height,
      color: Colors.grey[300],
      child: Icon(
        Icons.image,
        size: width * 0.3,
        color: Colors.grey[600],
      ),
    );
  }
}
