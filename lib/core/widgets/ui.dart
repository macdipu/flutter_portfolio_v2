import 'package:flutter/material.dart';

import '../../content/portfolio_content.dart' show Platform;
import '../design/tokens.dart';
import '../motion/pressable.dart';
import '../motion/reveal.dart';
import '../utils/launch.dart';

/// Centers content, applies the fluid gutter and the max content width.
class Frame extends StatelessWidget {
  const Frame({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return Align(
      alignment: Alignment.topCenter,
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: Widths.forViewport(w) + gutter(context) * 2),
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: gutter(context)),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// A page section: vertical rhythm, optional heading, constrained content.
class SectionShell extends StatelessWidget {
  const SectionShell({super.key, this.title, this.intro, required this.child});

  final String? title;
  final String? intro;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: sectionGap(context)),
      child: Frame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Reveal(
                kind: RevealKind.mask,
                child: Semantics(
                  header: true,
                  child: Text(title!, style: AppType.h1(context)),
                ),
              ),
              if (intro != null) ...[
                const SizedBox(height: Space.m),
                Reveal(
                  delay: Motion.stagger,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: Widths.reading),
                    child: Text(intro!, style: AppType.body(context)),
                  ),
                ),
              ],
              SizedBox(height: fluid(context, 32, 56)),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

/// Primary or secondary call to action.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.primary = false,
    this.icon = Icons.arrow_forward,
  });

  final String label;
  final VoidCallback onTap;
  final bool primary;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      builder: (context, s) {
        final bg = primary
            ? (s.active ? c.ink : c.signal)
            : (s.active
                ? c.signal.withValues(alpha: 0.10)
                : Colors.transparent);
        final fg = primary ? (s.active ? c.paper : c.onSignal) : c.ink;
        return AnimatedContainer(
          duration: Motion.scaled(context, Motion.hover),
          curve: Motion.easeOut,
          padding: EdgeInsets.symmetric(
              horizontal: Space.l, vertical: fluid(context, 12, 15)),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(Radii.sm),
            border: Border.all(
              color: s.focused
                  ? c.signal
                  : (primary
                      ? Colors.transparent
                      : (s.active ? c.signal : c.line)),
              width: s.focused ? 2 : 1.5,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style: AppType.ui14(context)
                      .copyWith(color: fg, fontWeight: FontWeight.w600)),
              const SizedBox(width: Space.s),
              AnimatedSlide(
                duration: Motion.scaled(context, Motion.hover),
                curve: Motion.easeOut,
                offset: Offset(s.active ? 0.3 : 0, 0),
                child: Icon(icon, size: 18, color: fg),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Text link with an underline that grows on hover and focus.
class TextLink extends StatelessWidget {
  const TextLink(
      {super.key, required this.label, this.url, this.onTap, this.style});

  final String label;
  final String? url;
  final VoidCallback? onTap;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap ?? (url == null ? null : () => openUrl(url!)),
      semanticLabel: label,
      builder: (context, s) {
        return Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 3),
              child: Text(
                label,
                style: (style ?? AppType.ui14(context)).copyWith(
                  color: s.active ? c.signal : (style?.color ?? c.ink),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedFractionallySizedBox(
                duration: Motion.scaled(context, Motion.hover),
                curve: Motion.easeOut,
                alignment: Alignment.centerLeft,
                widthFactor: s.active ? 1 : 0.0,
                child: Container(height: 2, color: c.signal),
              ),
            ),
          ],
        );
      },
    );
  }
}

/// Small bordered label for technologies.
class Tag extends StatelessWidget {
  const Tag(this.text, {super.key});
  final String text;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(Radii.sm),
      ),
      child: Text(text, style: AppType.caption(context)),
    );
  }
}

/// Local asset image with a fade-in and an honest fallback.
class AppImage extends StatelessWidget {
  const AppImage(
    this.asset, {
    super.key,
    this.fit = BoxFit.cover,
    this.alignment = Alignment.topCenter,
    this.cacheWidth,
    this.semanticLabel,
  });

  final String asset;
  final BoxFit fit;
  final Alignment alignment;
  final int? cacheWidth;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Image.asset(
      asset,
      fit: fit,
      alignment: alignment,
      cacheWidth: cacheWidth,
      semanticLabel: semanticLabel,
      excludeFromSemantics: semanticLabel == null,
      gaplessPlayback: true,
      frameBuilder: (context, child, frame, sync) {
        if (sync) return child;
        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: Motion.scaled(context, Motion.entrance),
          curve: Motion.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, _, __) => ColoredBox(
        color: c.surface,
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, color: c.muted),
        ),
      ),
    );
  }
}

/// Pill showing what a project runs on.
class PlatformBadge extends StatelessWidget {
  const PlatformBadge(this.platform, {super.key});
  final Platform platform;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(color: c.line),
        borderRadius: BorderRadius.circular(Radii.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(platform.icon, size: 14, color: c.signal),
          const SizedBox(width: 6),
          Text(platform.label, style: AppType.caption(context)),
        ],
      ),
    );
  }
}
