import 'package:flutter/material.dart';

import '../../content/portfolio_content.dart';
import '../design/tokens.dart';
import 'ui.dart';

const double _phoneAspect = 9 / 19.5;

BoxShadow _depth(BuildContext context, {double blur = 48, double dy = 28}) {
  final dark = Theme.of(context).brightness == Brightness.dark;
  return BoxShadow(
    color: Colors.black.withValues(alpha: dark ? 0.55 : 0.22),
    blurRadius: blur,
    offset: Offset(0, dy),
  );
}

/// A phone showing [child] on its screen.
class PhoneFrame extends StatelessWidget {
  const PhoneFrame({super.key, required this.width, required this.child});

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final bezel = width * 0.035;
    final radius = width * 0.14;
    return RepaintBoundary(
      child: Container(
        width: width,
        height: width / _phoneAspect,
        padding: EdgeInsets.all(bezel),
        decoration: BoxDecoration(
          color: const Color(0xFF05060A),
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(color: c.line, width: 1),
          boxShadow: [_depth(context)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(radius - bezel),
          child: child,
        ),
      ),
    );
  }
}

/// A desktop app window or a browser window with a title bar.
class WindowFrame extends StatelessWidget {
  const WindowFrame({
    super.key,
    required this.width,
    required this.aspect,
    required this.child,
    this.title = '',
    this.browser = false,
  });

  final double width;

  /// Aspect ratio (width / height) of the content area.
  final double aspect;
  final Widget child;
  final String title;
  final bool browser;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    const bar = 28.0;
    return RepaintBoundary(
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: BorderRadius.circular(Radii.md),
          border: Border.all(color: c.line),
          boxShadow: [_depth(context)],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: bar,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              color: c.surface,
              child: Row(
                children: [
                  for (var i = 0; i < 3; i++)
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(right: 6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: c.line,
                      ),
                    ),
                  if (browser) ...[
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 16,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                          color: c.paper,
                          borderRadius: BorderRadius.circular(Radii.pill),
                        ),
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style: AppType.caption(context).copyWith(fontSize: 9),
                        ),
                      ),
                    ),
                  ] else
                    Expanded(
                      child: Center(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.clip,
                          style:
                              AppType.caption(context).copyWith(fontSize: 10),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            AspectRatio(aspectRatio: aspect, child: child),
          ],
        ),
      ),
    );
  }
}

/// Renders a [Shot] inside the right kind of device at [width].
class ShotDevice extends StatelessWidget {
  const ShotDevice({super.key, required this.shot, required this.width});

  final Shot shot;
  final double width;

  @override
  Widget build(BuildContext context) {
    final image = AppImage(
      shot.asset,
      cacheWidth: shot.kind == ShotKind.phone ? 640 : 1400,
      semanticLabel: shot.caption,
    );
    return switch (shot.kind) {
      ShotKind.phone => PhoneFrame(width: width, child: image),
      ShotKind.desktop => WindowFrame(
          width: width,
          aspect: 1280 / 766,
          title: 'OpenReader',
          child: image,
        ),
      ShotKind.banner => ClipRRect(
          borderRadius: BorderRadius.circular(Radii.md),
          child: SizedBox(
            width: width,
            child: AspectRatio(aspectRatio: 4 / 3, child: image),
          ),
        ),
      ShotKind.browser => WindowFrame(
          width: width,
          aspect: 1.684,
          browser: true,
          title: 'localhost',
          child: image,
        ),
    };
  }
}
