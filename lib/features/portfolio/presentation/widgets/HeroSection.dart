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

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

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
                  return _buildVerticalLayout(
                      context, profile, 180.0, 18, 28, 18, 14);
                case DeviceType.tablet:
                  return _buildVerticalLayout(
                      context, profile, 240.0, 20, 38, 22, 16);
                case DeviceType.smallLaptop:
                  return _buildHorizontalLayout(
                      context, profile, 300.0, 22, 46, 24, 17);
                case DeviceType.desktop:
                  return _buildHorizontalLayout(
                      context, profile, 400.0, 24, 56, 28, 18);
                case DeviceType.largeDesktop:
                  return _buildHorizontalLayout(
                      context, profile, 480.0, 26, 64, 30, 20);
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    dynamic profile,
    double imageSize,
    double greetingSize,
    double nameSize,
    double titleSize,
    double introSize,
  ) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
        ),
        child: IntrinsicHeight(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Flexible(child: SizedBox(height: 20)),
              _buildHeroImage(profile.avatarUrl, imageSize),
              const SizedBox(height: 24),
              ResponsiveText(
                'Hello, I\'m',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
                mobileFontSize: greetingSize,
                tabletFontSize: greetingSize,
              )
                  .animate()
                  .fade(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 12),
              ResponsiveText(
                profile.name,
                style: theme.textTheme.displaySmall,
                textAlign: TextAlign.center,
                mobileFontSize: nameSize,
                tabletFontSize: nameSize,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 12),
              ResponsiveText(
                profile.title,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
                mobileFontSize: titleSize,
                tabletFontSize: titleSize,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: ResponsiveText(
                  profile.introduction,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  mobileFontSize: introSize,
                  tabletFontSize: introSize,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 600.ms)
                    .slide(begin: const Offset(0, -0.5)),
              ),
              const SizedBox(height: 24),
              _buildButtons(context, isVertical: true),
              const Flexible(child: SizedBox(height: 20)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    dynamic profile,
    double imageSize,
    double greetingSize,
    double nameSize,
    double titleSize,
    double introSize,
  ) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Hello, I\'m',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  desktopFontSize: greetingSize,
                )
                    .animate()
                    .fade(duration: 500.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 16),
                ResponsiveText(
                  profile.name,
                  style: theme.textTheme.displayLarge,
                  desktopFontSize: nameSize,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 200.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 24),
                ResponsiveText(
                  profile.title,
                  style: theme.textTheme.headlineSmall,
                  desktopFontSize: titleSize,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 400.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 32),
                ResponsiveText(
                  profile.introduction,
                  style: theme.textTheme.bodyLarge,
                  desktopFontSize: introSize,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 600.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 48),
                _buildButtons(context),
              ],
            ),
          ),
        ),
        const SizedBox(width: 64),
        _buildHeroImage(profile.avatarUrl, imageSize),
      ],
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

  Widget _buildButtons(BuildContext context, {bool isVertical = false}) {
    final children = [
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
      SizedBox(width: isVertical ? 0 : 24, height: isVertical ? 16 : 0),
      ResponsiveButton(
        text: 'Contact Me',
        variant: ButtonVariant.outlined,
        onPressed: () {
          context
              .read<ScrollCubit>()
              .scrollToSection(NavigationSection.contact);
        },
      )
          .animate()
          .fade(duration: 500.ms, delay: 1000.ms)
          .scale(begin: const Offset(0.9, 0.9)),
    ];

    return isVertical ? Column(children: children) : Row(children: children);
  }
}
