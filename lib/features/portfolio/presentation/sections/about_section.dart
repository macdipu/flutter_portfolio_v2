import 'package:flutter/material.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/widgets/ui.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SectionShell(
      title: 'About',
      child: LayoutBuilder(builder: (context, box) {
        final wide = box.maxWidth >= 800;

        final photo = Reveal(
          kind: RevealKind.wipe,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 380),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Radii.md),
              border: Border.all(color: c.line),
            ),
            clipBehavior: Clip.antiAlias,
            child: const AspectRatio(
              aspectRatio: 1,
              child: AppImage(
                Profile.avatar,
                cacheWidth: 760,
                alignment: Alignment.center,
                semanticLabel: 'Portrait of ${Profile.name}',
              ),
            ),
          ),
        );

        final text = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Reveal(
              child: Text(Profile.about, style: AppType.lead(context)),
            ),
            SizedBox(height: fluid(context, 28, 44)),
            for (var i = 0; i < skills.length; i++)
              Reveal(
                delay: Motion.stagger * i,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: Space.l),
                  child: _SkillRow(group: skills[i]),
                ),
              ),
            const SizedBox(height: Space.s),
            Reveal(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final e in education) ...[
                    Text(e.institution, style: AppType.h3(context)),
                    Text('${e.degree}, ${e.period}',
                        style: AppType.caption(context)),
                  ],
                ],
              ),
            ),
            const SizedBox(height: Space.xl),
            Reveal(
              child: Wrap(
                spacing: Space.l,
                runSpacing: Space.m,
                children: const [
                  TextLink(label: 'GitHub', url: AppLinks.github),
                  TextLink(label: 'LinkedIn', url: AppLinks.linkedIn),
                  TextLink(label: 'X', url: AppLinks.x),
                  TextLink(label: 'Medium', url: AppLinks.medium),
                ],
              ),
            ),
          ],
        );

        if (!wide) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [photo, const SizedBox(height: Space.xl), text],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 4, child: photo),
            const SizedBox(width: Space.xxl),
            Expanded(flex: 7, child: text),
          ],
        );
      }),
    );
  }
}

class _SkillRow extends StatelessWidget {
  const _SkillRow({required this.group});
  final SkillGroup group;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(group.title, style: AppType.caption(context)),
        const SizedBox(height: Space.s),
        Wrap(
          spacing: Space.s,
          runSpacing: Space.s,
          children: [for (final s in group.items) Tag(s)],
        ),
      ],
    );
  }
}
