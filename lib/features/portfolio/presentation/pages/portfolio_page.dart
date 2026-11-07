import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design/tokens.dart';
import '../../../../core/motion/scroll_scope.dart';
import '../../../../core/navigation/scroll_controller.dart';
import '../bloc/blog_cubit.dart';
import '../sections/about_section.dart';
import '../sections/contact_section.dart';
import '../sections/experience_section.dart';
import '../sections/hero_section.dart';
import '../sections/marquee_strip.dart';
import '../sections/proof_strip.dart';
import '../sections/projects_section.dart';
import '../sections/writing_section.dart';
import '../widgets/top_bar.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ScrollCubit()),
        BlocProvider(create: (_) => BlogCubit()..load(), lazy: false),
      ],
      child: const _PortfolioView(),
    );
  }
}

class _PortfolioView extends StatefulWidget {
  const _PortfolioView();

  @override
  State<_PortfolioView> createState() => _PortfolioViewState();
}

class _PortfolioViewState extends State<_PortfolioView> {
  bool _menuOpen = false;

  Widget _section(NavigationSection s) => switch (s) {
        NavigationSection.hero => const Column(
            children: [HeroSection(), MarqueeStrip(), ProofStrip()],
          ),
        NavigationSection.projects => const ProjectsSection(),
        NavigationSection.experience => const ExperienceSection(),
        NavigationSection.about => const AboutSection(),
        NavigationSection.writing => const WritingSection(),
        NavigationSection.contact => const ContactSection(),
      };

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<ScrollCubit>();
    final reduced = Motion.reduced(context);

    return ScrollScope(
      controller: cubit.controller,
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: cubit.controller,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final s in NavigationSection.values)
                    KeyedSubtree(key: cubit.keys[s], child: _section(s)),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: TopBar(onMenu: () => setState(() => _menuOpen = true)),
            ),
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: Motion.scaled(context, Motion.exit),
                child: _menuOpen
                    ? MobileMenu(
                        key: const ValueKey('menu'),
                        onClose: () => setState(() => _menuOpen = false),
                        onSelect: (s) {
                          setState(() => _menuOpen = false);
                          cubit.scrollTo(s, reduced: reduced);
                        },
                      )
                    : const SizedBox.shrink(key: ValueKey('no-menu')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
