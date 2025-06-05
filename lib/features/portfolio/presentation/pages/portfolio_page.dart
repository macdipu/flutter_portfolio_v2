import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/widgets/HeroSection.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/portfolio_bloc.dart';
import '../widgets/about_section.dart';
import '../widgets/blog_section.dart';
import '../widgets/contact_section.dart';
import '../widgets/experience_section.dart';
import '../widgets/portfolio_section.dart';
import '../widgets/resume_section.dart';
import '../widgets/services_section.dart';
import '../widgets/sidebar_navigation.dart';
import '../widgets/tech_stack_section.dart';

class PortfolioPage extends StatelessWidget {
  const PortfolioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ScrollCubit()),
        BlocProvider(
          create: (_) => PortfolioBloc()
            ..add(LoadPortfolioData())
            ..add(LoadBlogPosts()),
        ),
      ],
      child: const _PortfolioView(),
    );
  }
}

class _PortfolioView extends StatelessWidget {
  const _PortfolioView();

  @override
  Widget build(BuildContext context) {
    final scrollCubit = context.read<ScrollCubit>();

    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final isDrawer =
            deviceType == DeviceType.mobile || deviceType == DeviceType.tablet;
        final isSidebar = deviceType.index >= DeviceType.smallLaptop.index;

        return Scaffold(
          drawer: isDrawer ? _buildDrawer(context, scrollCubit) : null,
          body: BlocBuilder<ScrollCubit, ScrollState>(
            builder: (context, scrollState) {
              return Stack(
                children: [
                  Row(
                    children: [
                      if (isSidebar)
                        SafeArea(
                            child: _buildSidebar(scrollState, scrollCubit)),
                      Expanded(child: _buildScrollableContent(scrollCubit)),
                    ],
                  ),
                  _buildThemeToggle(context),
                  if (isDrawer) _buildDrawerToggleButton(context),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildDrawer(BuildContext context, ScrollCubit scrollCubit) {
    return Drawer(
      child: SafeArea(
        child: SidebarNavigation(
          isOpen: true,
          currentSection: scrollCubit.state.currentSection,
          onToggle: () => Navigator.of(context).pop(),
          onSectionSelected: (section) => scrollCubit.scrollToSection(section),
        ),
      ),
    );
  }

  Widget _buildSidebar(ScrollState scrollState, ScrollCubit scrollCubit) {
    return SidebarNavigation(
      isOpen: true,
      currentSection: scrollState.currentSection,
      onToggle: () {},
      onSectionSelected: scrollCubit.scrollToSection,
    );
  }

  Widget _buildScrollableContent(ScrollCubit scrollCubit) {
    return ScrollablePositionedList.builder(
      itemCount: NavigationSection.values.length,
      itemScrollController: scrollCubit.itemScrollController,
      itemPositionsListener: scrollCubit.itemPositionsListener,
      itemBuilder: (context, index) {
        final section = NavigationSection.values[index];
        return _buildSection(section);
      },
    );
  }

  Widget _buildThemeToggle(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: SafeArea(
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            final isDark = state.themeMode == ThemeMode.dark;
            return IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
                color: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () => context.read<ThemeCubit>().toggleTheme(),
            );
          },
        ),
      ),
    );
  }

  Widget _buildDrawerToggleButton(BuildContext context) {
    return Positioned(
      top: 16,
      left: 16,
      child: SafeArea(
        child: Builder(
          builder: (context) => IconButton(
            icon:
                Icon(Icons.menu, color: Theme.of(context).colorScheme.primary),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(NavigationSection section) {
    switch (section) {
      case NavigationSection.hero:
        return const HeroSection();
      case NavigationSection.about:
        return const AboutSection();
      case NavigationSection.experience:
        return const ExperienceSection();
      case NavigationSection.portfolio:
        return const PortfolioSection();
      case NavigationSection.services:
        return const ServicesSection();
      case NavigationSection.techStack:
        return const TechStackSection();
      case NavigationSection.blog:
        return const BlogSection();
      case NavigationSection.contact:
        return const ContactSection();
      case NavigationSection.resume:
        return const ResumeSection();
    }
  }
}
