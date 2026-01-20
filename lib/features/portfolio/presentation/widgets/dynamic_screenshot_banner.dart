import 'package:any_image_view/any_image_view.dart';
import 'package:flutter/material.dart';

class DynamicScreenshotBanner extends StatelessWidget {
  final List<String> screenshots;
  final Widget details;
  final double bannerRatio;
  final EdgeInsets? padding;

  const DynamicScreenshotBanner({
    super.key,
    required this.screenshots,
    required this.details,
    this.bannerRatio = 16 / 9,
    this.padding,
  });

  Widget _buildImage(String screenshot) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AnyImageView(
          imagePath: screenshot,
          useMemoryCache: true,
          fit: BoxFit.cover,
        )
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget content = LayoutBuilder(
      builder: (context, constraints) {
        Widget banner;
        if (screenshots.isEmpty) {
          banner = Container();
        } else if (screenshots.length == 1) {
          banner = AspectRatio(
            aspectRatio: bannerRatio,
            child: _buildImage(screenshots[0]),
          );
        } else if (screenshots.length <= 3) {
          banner = AspectRatio(
            aspectRatio: bannerRatio,
            child: Row(
              children: screenshots
                  .map((s) => Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(right: screenshots.length > 1 ? 8.0 : 0),
                          child: AspectRatio(
                            aspectRatio: 9 / 16,
                            child: _buildImage(s),
                          ),
                        ),
                      ))
                  .toList(),
            ),
          );
        } else {
          banner = AspectRatio(
            aspectRatio: bannerRatio,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: screenshots
                    .map((s) => Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: SizedBox(
                            width: 200,
                            child: AspectRatio(
                              aspectRatio: 9 / 16,
                              child: _buildImage(s),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          );
        }

        if (constraints.maxWidth < 600) {
          // Mobile layout: column
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: details,
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: banner,
              ),
            ],
          );
        } else {
          // Desktop layout: row
          return Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: details,
                ),
              ),
              Expanded(
                flex: 1,
                child: banner,
              ),
            ],
          );
        }
      },
    );

    return Padding(
      padding: padding ?? EdgeInsets.zero,
      child: content,
    );
  }
}