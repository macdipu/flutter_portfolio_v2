import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_button.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_image.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_text.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';

class ResponsiveHeroSection extends StatelessWidget {
  const ResponsiveHeroSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const SectionWrapper(
            fullHeight: true,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const SectionWrapper(
            fullHeight: true,
            child: Center(child: Text('No profile data available')),
          );
        }

        return SectionWrapper(
          fullHeight: true,
          child: ResponsiveBuilder(
            builder: (context, deviceType, constraints) {
              switch (deviceType) {
                case DeviceType.mobile:
                  return _buildMobileHero(context, profile);
                case DeviceType.tablet:
                  return _buildTabletHero(context, profile);
                case DeviceType.desktop:
                  return _buildDesktopHero(context, profile);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildDesktopHero(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                'Hello, I\'m',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                desktopFontSize: 24.0,
              )
                  .animate()
                  .fade(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 16),
              ResponsiveText(
                profile.name,
                style: theme.textTheme.displayLarge,
                desktopFontSize: 56.0,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 24),
              ResponsiveText(
                profile.title,
                style: theme.textTheme.headlineSmall,
                desktopFontSize: 28.0,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 32),
              ResponsiveText(
                profile.introduction,
                style: theme.textTheme.bodyLarge,
                desktopFontSize: 18.0,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 600.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 48),
              Row(
                children: [
                  ResponsiveButton(
                    text: 'View My Work',
                    onPressed: () {
                      context
                          .read<ScrollCubit>()
                          .scrollToSection(NavigationSection.portfolio);
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms, delay: 800.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                  const SizedBox(width: 24),
                  ResponsiveButton(
                    text: 'Contact Me',
                    isOutlined: true,
                    onPressed: () {
                      context
                          .read<ScrollCubit>()
                          .scrollToSection(NavigationSection.contact);
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms, delay: 1000.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: 64),
        _buildHeroImage(profile.avatarUrl, 400.0),
      ],
    );
  }

  Widget _buildTabletHero(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom),
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(child: SizedBox(height: 20)),

              _buildHeroImage(profile.avatarUrl, 240.0),
              const SizedBox(height: 32),

              ResponsiveText(
                'Hello, I\'m',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                tabletFontSize: 20.0,
              )
                  .animate()
                  .fade(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 12), // Reduced from 16

              ResponsiveText(
                profile.name,
                style: theme.textTheme.displayMedium,
                textAlign: TextAlign.center,
                tabletFontSize: 38.0, // Reduced from 42
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 16), // Reduced from 20

              ResponsiveText(
                profile.title,
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
                tabletFontSize: 22.0, // Reduced from 24
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 20), // Reduced from 24

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: ResponsiveText(
                  profile.introduction,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  tabletFontSize: 16.0,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 600.ms)
                    .slide(begin: const Offset(0, -0.5)),
              ),

              const SizedBox(height: 32), // Reduced from 40

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ResponsiveButton(
                    text: 'View My Work',
                    onPressed: () {
                      context
                          .read<ScrollCubit>()
                          .scrollToSection(NavigationSection.portfolio);
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms, delay: 800.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                  const SizedBox(width: 20),
                  ResponsiveButton(
                    text: 'Contact Me',
                    isOutlined: true,
                    onPressed: () {
                      context
                          .read<ScrollCubit>()
                          .scrollToSection(NavigationSection.contact);
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms, delay: 1000.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                ],
              ),

              // Flexible spacing at the bottom
              const Flexible(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileHero(BuildContext context, dynamic profile) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              (MediaQuery.of(context).padding.top +
                  MediaQuery.of(context).padding.bottom),
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Flexible spacing at the top
              const Flexible(child: SizedBox(height: 20)),

              _buildHeroImage(profile.avatarUrl, 180.0), // Reduced from 200
              const SizedBox(height: 24), // Reduced from 32

              ResponsiveText(
                'Hello, I\'m',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                mobileFontSize: 18.0,
              )
                  .animate()
                  .fade(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 10), // Reduced from 12

              ResponsiveText(
                profile.name,
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
                mobileFontSize: 28.0, // Reduced from 32
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 12), // Reduced from 16

              ResponsiveText(
                profile.title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
                mobileFontSize: 18.0, // Reduced from 20
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),

              const SizedBox(height: 16), // Reduced from 20

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ResponsiveText(
                  profile.introduction,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  mobileFontSize: 14.0,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 600.ms)
                    .slide(begin: const Offset(0, -0.5)),
              ),

              const SizedBox(height: 24), // Reduced from 32

              Column(
                children: [
                  ResponsiveButton(
                    text: 'View My Work',
                    onPressed: () {
                      context
                          .read<ScrollCubit>()
                          .scrollToSection(NavigationSection.portfolio);
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms, delay: 800.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                  const SizedBox(height: 16),
                  ResponsiveButton(
                    text: 'Contact Me',
                    isOutlined: true,
                    onPressed: () {
                      context
                          .read<ScrollCubit>()
                          .scrollToSection(NavigationSection.contact);
                    },
                  )
                      .animate()
                      .fade(duration: 500.ms, delay: 1000.ms)
                      .scale(begin: const Offset(0.9, 0.9)),
                ],
              ),

              // Flexible spacing at the bottom
              const Flexible(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage(String avatarUrl, double size) {
    return ResponsiveImage(
      imageUrl: avatarUrl,
      width: size,
      height: size,
      borderRadius: BorderRadius.circular(size / 2),
      fit: BoxFit.cover,
    )
        .animate()
        .fade(duration: 800.ms, delay: 400.ms)
        .scale(begin: const Offset(0.8, 0.8));
  }
}
