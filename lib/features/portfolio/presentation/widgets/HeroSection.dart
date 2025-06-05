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
          centerContent: true,
          child: ResponsiveBuilder(
            builder: (context, deviceType, constraints) {
              // Define responsive values for all breakpoints
              final imageSize = ResponsiveHelper.getResponsiveValue<double>(
                context: context,
                mobile: 180.0,
                tablet: 240.0,
                smallLaptop: 300.0,
                desktop: 400.0,
                largeDesktop: 480.0,
              );

              final greetingSize = ResponsiveHelper.getFontSize(
                context,
                mobile: 18.0,
                tablet: 20.0,
                smallLaptop: 22.0,
                desktop: 24.0,
                largeDesktop: 26.0,
              );

              final nameSize = ResponsiveHelper.getFontSize(
                context,
                mobile: 28.0,
                tablet: 38.0,
                smallLaptop: 46.0,
                desktop: 56.0,
                largeDesktop: 64.0,
              );

              final titleSize = ResponsiveHelper.getFontSize(
                context,
                mobile: 18.0,
                tablet: 22.0,
                smallLaptop: 24.0,
                desktop: 28.0,
                largeDesktop: 30.0,
              );

              final introSize = ResponsiveHelper.getFontSize(
                context,
                mobile: 14.0,
                tablet: 16.0,
                smallLaptop: 17.0,
                desktop: 18.0,
                largeDesktop: 20.0,
              );

              final horizontalPadding =
                  ResponsiveHelper.getResponsiveValue<double>(
                context: context,
                mobile: 24.0,
                tablet: 32.0,
                smallLaptop: 48.0,
                desktop: 64.0,
                largeDesktop: 80.0,
              );

              // Use vertical layout for mobile and tablet, horizontal for others
              final isVertical = deviceType == DeviceType.mobile ||
                  deviceType == DeviceType.tablet;

              return isVertical
                  ? _buildVerticalLayout(
                      context,
                      profile,
                      imageSize,
                      greetingSize,
                      nameSize,
                      titleSize,
                      introSize,
                      horizontalPadding,
                    )
                  : _buildHorizontalLayout(
                      context,
                      profile,
                      imageSize,
                      greetingSize,
                      nameSize,
                      titleSize,
                      introSize,
                      horizontalPadding,
                    );
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
    double horizontalPadding,
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
            crossAxisAlignment: CrossAxisAlignment.center,
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
                smallLaptopFontSize: greetingSize,
                desktopFontSize: greetingSize,
                largeDesktopFontSize: greetingSize,
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
                smallLaptopFontSize: nameSize,
                desktopFontSize: nameSize,
                largeDesktopFontSize: nameSize,
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
                smallLaptopFontSize: titleSize,
                desktopFontSize: titleSize,
                largeDesktopFontSize: titleSize,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
                child: ResponsiveText(
                  profile.introduction,
                  style: theme.textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                  mobileFontSize: introSize,
                  tabletFontSize: introSize,
                  smallLaptopFontSize: introSize,
                  desktopFontSize: introSize,
                  largeDesktopFontSize: introSize,
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
    double horizontalPadding,
  ) {
    final theme = Theme.of(context);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ResponsiveText(
                  'Hello, I\'m',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                  smallLaptopFontSize: greetingSize,
                  desktopFontSize: greetingSize,
                  largeDesktopFontSize: greetingSize,
                )
                    .animate()
                    .fade(duration: 500.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 16),
                ResponsiveText(
                  profile.name,
                  style: theme.textTheme.displayLarge,
                  smallLaptopFontSize: nameSize,
                  desktopFontSize: nameSize,
                  largeDesktopFontSize: nameSize,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 200.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 24),
                ResponsiveText(
                  profile.title,
                  style: theme.textTheme.headlineSmall,
                  smallLaptopFontSize: titleSize,
                  desktopFontSize: titleSize,
                  largeDesktopFontSize: titleSize,
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 400.ms)
                    .slide(begin: const Offset(0, -0.5)),
                const SizedBox(height: 32),
                ResponsiveText(
                  profile.introduction,
                  style: theme.textTheme.bodyLarge,
                  smallLaptopFontSize: introSize,
                  desktopFontSize: introSize,
                  largeDesktopFontSize: introSize,
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
        SizedBox(width: horizontalPadding),
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
