import 'package:flutter/material.dart';

import '../../../../content/other_projects.dart';
import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/pressable.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/utils/launch.dart';
import '../../../../core/widgets/ui.dart';

/// Smaller and older work as a plain list, ending with the GitHub profile.
class OtherProjectsSection extends StatelessWidget {
  const OtherProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      title: 'More projects',
      intro: 'Smaller, older and experimental work. Every row links to its '
          'repository.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final p in otherProjects) _Row(project: p),
          SizedBox(height: fluid(context, 28, 48)),
          Reveal(
            child: Wrap(
              spacing: Space.m,
              runSpacing: Space.m,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                AppButton(
                  label: 'See all repositories on GitHub',
                  primary: true,
                  icon: Icons.north_east,
                  onTap: () => openUrl('${AppLinks.github}?tab=repositories'),
                ),
                Text('github.com/macdipu', style: AppType.caption(context)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.project});

  final OtherProject project;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    return Reveal(
      kind: RevealKind.fade,
      child: Pressable(
        onTap: () => openUrl(project.url),
        semanticLabel: '${project.title}. ${project.summary}',
        pressScale: 1,
        builder: (context, s) {
          final head = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(project.title, style: AppType.h3(context)),
              const SizedBox(height: 2),
              Text(project.tags.join(', '), style: AppType.caption(context)),
            ],
          );
          final body = Text(project.summary, style: AppType.body(context));
          final arrow = AnimatedOpacity(
            duration: Motion.scaled(context, Motion.hover),
            opacity: s.active ? 1 : 0.35,
            child: Icon(
              Icons.north_east,
              size: 20,
              color: s.active ? c.signal : c.muted,
            ),
          );
          return AnimatedContainer(
            duration: Motion.scaled(context, Motion.hover),
            curve: Motion.easeOut,
            padding: const EdgeInsets.symmetric(
              vertical: Space.l,
              horizontal: Space.s,
            ),
            decoration: BoxDecoration(
              color: s.active ? c.surface : Colors.transparent,
              border: Border(
                bottom: BorderSide(color: c.line),
                left: BorderSide(
                  color: s.focused ? c.signal : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: wide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 4, child: head),
                      const SizedBox(width: Space.l),
                      Expanded(flex: 6, child: body),
                      const SizedBox(width: Space.m),
                      arrow,
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [Expanded(child: head), arrow],
                      ),
                      const SizedBox(height: Space.s),
                      body,
                    ],
                  ),
          );
        },
      ),
    );
  }
}
