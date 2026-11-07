import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/pressable.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/utils/launch.dart';
import '../../../../core/widgets/ui.dart';

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionShell(
          title: 'Contact',
          intro: 'Email is the fastest way to reach me.',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Reveal(
                child: Pressable(
                  onTap: () => openUrl('mailto:${AppLinks.email}'),
                  semanticLabel: 'Email ${AppLinks.email}',
                  pressScale: 1,
                  builder: (context, s) => Container(
                    decoration: focusRing(context, s.focused),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        AppLinks.email,
                        style: AppType.display(context).copyWith(
                          fontSize: fluid(context, 28, 64),
                          letterSpacing: -fluid(context, 0.5, 2),
                          color: s.active ? c.signal : c.ink,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: Space.l),
              Reveal(
                delay: Motion.stagger,
                child: Wrap(
                  spacing: Space.m,
                  runSpacing: Space.m,
                  children: [
                    AppButton(
                      label: 'Email me',
                      primary: true,
                      icon: Icons.mail_outline,
                      onTap: () => openUrl('mailto:${AppLinks.email}'),
                    ),
                    AppButton(
                      label: 'Copy address',
                      icon: Icons.copy,
                      onTap: () async {
                        await copyText(AppLinks.email);
                        if (!context.mounted) return;
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Email address copied'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    ),
                    AppButton(
                      label: 'Book a call',
                      icon: Icons.event_outlined,
                      onTap: () => openUrl(AppLinks.calendly),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: Space.xl),
              Reveal(
                delay: Motion.stagger * 2,
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
          ),
        ),
        SizedBox(height: sectionGap(context)),
        const _Footer(),
      ],
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final cubit = context.read<ScrollCubit>();
    final reduced = Motion.reduced(context);
    return Container(
      decoration: BoxDecoration(border: Border(top: BorderSide(color: c.line))),
      padding: const EdgeInsets.symmetric(vertical: Space.l),
      child: Frame(
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          runSpacing: Space.m,
          spacing: Space.l,
          children: [
            Text('© ${DateTime.now().year} ${Profile.name}',
                style: AppType.caption(context)),
            Wrap(
              spacing: Space.l,
              runSpacing: Space.s,
              children: [
                const TextLink(
                    label: 'Source of this site', url: AppLinks.siteSource),
                TextLink(
                  label: 'Back to top',
                  onTap: () =>
                      cubit.scrollTo(NavigationSection.hero, reduced: reduced),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
