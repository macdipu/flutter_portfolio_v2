import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/widgets/ResponsiveHeroSection.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/widgets/responsive_about_section.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../bloc/portfolio_bloc.dart';
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
        BlocProvider(
          create: (context) => ScrollCubit(),
        ),
        BlocProvider(
          create: (context) => PortfolioBloc()
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
        final isDesktop = deviceType == DeviceType.desktop;
        return Scaffold(
          drawer: isDesktop
              ? null
              : Drawer(
                  child: SafeArea(
                    child: SidebarNavigation(
                      isOpen: true,
                      currentSection: scrollCubit.state.currentSection,
                      onToggle: () => Navigator.of(context).pop(),
                      onSectionSelected: (section) {
                        scrollCubit.scrollToSection(section);
                      },
                    ),
                  ),
                ),
          body: BlocBuilder<ScrollCubit, ScrollState>(
            builder: (context, scrollState) {
              return Stack(
                children: [
                  Row(
                    children: [
                      if (isDesktop)
                        SafeArea(
                          child: SidebarNavigation(
                            isOpen: true,
                            currentSection: scrollState.currentSection,
                            onToggle: () {},
                            onSectionSelected: scrollCubit.scrollToSection,
                          ),
                        ),
                      Expanded(
                        child: ScrollablePositionedList.builder(
                          itemCount: NavigationSection.values.length,
                          itemScrollController:
                              scrollCubit.itemScrollController,
                          itemPositionsListener:
                              scrollCubit.itemPositionsListener,
                          itemBuilder: (context, index) {
                            return _buildSection(
                              NavigationSection.values[index],
                              context,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  // Theme toggle button
                  Positioned(
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
                              size: 24,
                            ),
                            onPressed: () {
                              context.read<ThemeCubit>().toggleTheme();
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  // Mobile menu button
                  if (!isDesktop)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: SafeArea(
                        child: Builder(
                          builder: (context) => IconButton(
                            icon: Icon(Icons.menu,
                                color: Theme.of(context).colorScheme.primary),
                            onPressed: () => Scaffold.of(context).openDrawer(),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildSection(NavigationSection section, BuildContext context) {
    switch (section) {
      case NavigationSection.hero:
        return const ResponsiveHeroSection();
      case NavigationSection.about:
        return const ResponsiveAboutSection();
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
