import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/pressable.dart';
import '../../../../core/motion/scroll_scope.dart';
import '../../../../core/motion/tilt.dart';
import '../../../../core/widgets/devices.dart';
import '../../../../core/widgets/ui.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionShell(
          title: 'Projects',
          intro: 'Apps I shipped for clients, apps I published myself and '
              'open-source tools, each with its real screens. Scroll to move '
              'through them, or jump to one.',
          child: SizedBox.shrink(),
        ),
        ProjectShowcase(),
      ],
    );
  }
}

/// A pinned scene. The page keeps scrolling, but the scene stays on screen
/// while the projects rotate through depth, one per [step] of scroll.
class ProjectShowcase extends StatefulWidget {
  const ProjectShowcase({super.key});

  @override
  State<ProjectShowcase> createState() => _ProjectShowcaseState();
}

class _ProjectShowcaseState extends State<ProjectShowcase> {
  final _outerKey = GlobalKey();
  double _pin = 0;
  double _step = 1;

  void _jumpTo(int index) {
    final controller = ScrollScope.of(context);
    final target = controller.offset + (index * _step - _pin);
    if (Motion.reduced(context)) {
      controller.jumpTo(target);
    } else {
      controller.animateTo(
        target,
        duration: Motion.scroll,
        curve: Motion.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vh = MediaQuery.sizeOf(context).height;
    final n = projects.length;
    _step = vh * 0.7;
    final outerHeight = vh + (n - 1) * _step;

    return SizedBox(
      key: _outerKey,
      height: outerHeight,
      child: ScrollLinked(
        builder: (context, offset, _) {
          final top = viewportTop(_outerKey.currentContext ?? context) ?? 0;
          _pin = (-top).clamp(0.0, outerHeight - vh);
          final f = _pin / _step;
          return Stack(
            children: [
              Positioned(
                top: _pin,
                left: 0,
                right: 0,
                height: vh,
                child: _Scene(progress: dwell(f), onJump: _jumpTo),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Holds each project still for most of its scroll range and rotates only in
/// the band between two projects, so every slide is sharp while you read it.
double dwell(double f) {
  final i = f.floor();
  final t = ((f - i - 0.3) / 0.4).clamp(0.0, 1.0);
  return i + t * t * (3 - 2 * t);
}

class _Scene extends StatelessWidget {
  const _Scene({required this.progress, required this.onJump});

  /// 0..n-1, already eased by [dwell].
  final double progress;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final active = progress.round().clamp(0, projects.length - 1);

    final text = _ProjectText(
      key: ValueKey(active),
      project: projects[active],
      index: active,
      compact: !wide,
    );
    final switcher = AnimatedSwitcher(
      duration: Motion.scaled(context, const Duration(milliseconds: 320)),
      switchInCurve: Motion.easeOut,
      transitionBuilder: (child, anim) => FadeTransition(
        opacity: anim,
        child: SlideTransition(
          position: Tween(begin: const Offset(0, 0.04), end: Offset.zero)
              .animate(anim),
          child: child,
        ),
      ),
      layoutBuilder: (current, previous) => Stack(
        alignment: Alignment.topLeft,
        children: [...previous, if (current != null) current],
      ),
      child: text,
    );

    final stage = _Stage(progress: progress);
    final rail = _Rail(active: active, onJump: onJump);

    return Padding(
      padding:
          EdgeInsets.only(top: 64 + fluid(context, 8, 24), bottom: Space.m),
      child: Frame(
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 5,
                    child: _FitBox(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          switcher,
                          const SizedBox(height: Space.l),
                          rail,
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: Space.xl),
                  Expanded(flex: 7, child: stage),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: stage),
                  const SizedBox(height: Space.s),
                  Expanded(
                    flex: 6,
                    child: _FitBox(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          switcher,
                          const SizedBox(height: Space.s),
                          rail,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

/// Keeps [child] at its natural size, and only shrinks it when the viewport
/// is too short to hold it. Short laptop windows and small phones need this.
class _FitBox extends StatelessWidget {
  const _FitBox({required this.child, required this.alignment});

  final Widget child;
  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, box) => FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: SizedBox(width: box.maxWidth, child: child),
      ),
    );
  }
}

class _Rail extends StatelessWidget {
  const _Rail({required this.active, required this.onJump});

  final int active;
  final ValueChanged<int> onJump;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final n = projects.length;
    return Row(
      children: [
        Text(
          '${active + 1} / $n',
          style: AppType.caption(context).copyWith(
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        const SizedBox(width: Space.m),
        for (var i = 0; i < n; i++)
          Pressable(
            onTap: () => onJump(i),
            semanticLabel: 'Show ${projects[i].title}',
            pressScale: 1,
            builder: (context, s) => Container(
              // 44px tall touch target around a thin visual rail.
              height: 44,
              width: 28,
              alignment: Alignment.center,
              decoration: focusRing(context, s.focused),
              child: AnimatedContainer(
                duration: Motion.scaled(context, Motion.hover),
                curve: Motion.easeOut,
                height: 3,
                width: i == active ? 24 : 12,
                decoration: BoxDecoration(
                  color:
                      i == active ? c.signal : (s.hovered ? c.muted : c.line),
                  borderRadius: BorderRadius.circular(Radii.pill),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _ProjectText extends StatelessWidget {
  const _ProjectText({
    super.key,
    required this.project,
    required this.index,
    required this.compact,
  });

  final Project project;
  final int index;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final body = AppType.body(context).copyWith(
      fontSize: compact ? 15 : fluid(context, 17, 19),
      height: compact ? 1.5 : 1.6,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [for (final p in project.platforms) PlatformBadge(p)],
        ),
        SizedBox(height: compact ? Space.s : Space.m),
        Semantics(
          header: true,
          child: Text(
            project.title,
            style: AppType.h1(context).copyWith(
              fontSize: compact ? 28 : fluid(context, 32, 44),
            ),
          ),
        ),
        const SizedBox(height: 2),
        Text(project.role, style: AppType.caption(context)),
        SizedBox(height: compact ? Space.s : Space.m),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Text(project.summary, style: body),
        ),
        if (!compact) ...[
          const SizedBox(height: Space.m),
          Wrap(
            spacing: Space.s,
            runSpacing: Space.s,
            children: [for (final t in project.tags) Tag(t)],
          ),
        ],
        SizedBox(height: compact ? Space.s : Space.l),
        Wrap(
          spacing: Space.l,
          runSpacing: Space.s,
          children: [
            for (final l in project.links) TextLink(label: l.label, url: l.url),
          ],
        ),
      ],
    );
  }
}

/// All projects stacked in depth. Each rotates in from the right as the
/// scroll reaches it and rotates out to the left as it leaves.
class _Stage extends StatelessWidget {
  const _Stage({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, box) {
      final w = math
          .min(box.maxWidth * 0.94, box.maxHeight / 0.8)
          .clamp(240.0, 720.0);
      final order = List<int>.generate(projects.length, (i) => i)
        ..sort((a, b) => (progress - b)
            .abs()
            .compareTo((progress - a).abs())); // far first, near last (on top)

      return Align(
        alignment:
            box.maxWidth < 600 ? Alignment.center : Alignment.centerRight,
        child: PointerTilt(
          builder: (context, tilt) => SizedBox(
            width: w,
            height: w * 0.8,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                for (final i in order)
                  if ((progress - i).abs() < 1.25) _slide(i, w, tilt),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _slide(int i, double w, Offset tilt) {
    final d = progress - i; // -1 (coming) .. 0 (current) .. 1 (leaving)
    final a = d.abs();
    return Positioned.fill(
      child: IgnorePointer(
        child: Opacity(
          opacity: (1 - a * 2.0).clamp(0.0, 1.0),
          child: Transform(
            alignment: Alignment.center,
            transform: perspective(
              rotateY: -d * 0.75 + tilt.dx * 0.10,
              rotateX: 0.06 - tilt.dy * 0.06,
              dx: -d * w * 0.55,
              scale: 1 - a * 0.22,
            ),
            child: Center(child: _Devices(project: projects[i], width: w)),
          ),
        ),
      ),
    );
  }
}

/// Arranges a project's preview graphics as devices.
class _Devices extends StatelessWidget {
  const _Devices({required this.project, required this.width});

  final Project project;
  final double width;

  @override
  Widget build(BuildContext context) {
    final w = width;
    final shots = project.shots;
    final phones = shots.where((s) => s.kind == ShotKind.phone).toList();
    final windows = shots
        .where((s) => s.kind == ShotKind.desktop || s.kind == ShotKind.browser)
        .toList();
    final banners = shots.where((s) => s.kind == ShotKind.banner).toList();
    if (banners.isNotEmpty) {
      return ShotDevice(shot: banners.first, width: w * 0.86);
    }

    // Desktop or browser window with a phone in front.
    if (windows.isNotEmpty && phones.isNotEmpty) {
      return SizedBox(
        width: w,
        height: w * 0.8,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              left: w * 0.10,
              top: w * 0.06,
              child: ShotDevice(shot: windows.first, width: w * 0.70),
            ),
            Positioned(
              right: 0,
              top: w * 0.10,
              child: ShotDevice(shot: phones.first, width: w * 0.25),
            ),
          ],
        ),
      );
    }
    // A single window, centred.
    if (windows.isNotEmpty) {
      return ShotDevice(shot: windows.first, width: w * 0.88);
    }
    // Phones fan out.
    final fan = phones.take(3).toList();
    if (fan.length == 1) return ShotDevice(shot: fan.first, width: w * 0.36);
    return SizedBox(
      width: w,
      height: w * 0.8,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          for (var k = 0; k < fan.length; k++)
            Transform(
              alignment: Alignment.center,
              transform: perspective(
                rotateZ: (k - (fan.length - 1) / 2) * 0.16,
                dx: (k - (fan.length - 1) / 2) * w * 0.27,
                dy: (k - (fan.length - 1) / 2).abs() * w * 0.025,
              ),
              child: ShotDevice(
                shot: fan[k],
                width: w * (k == (fan.length - 1) ~/ 2 ? 0.30 : 0.27),
              ),
            ),
        ],
      ),
    );
  }
}
