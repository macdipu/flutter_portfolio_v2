import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_image.dart';
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
            mobileChild: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const SectionWrapper(
            fullHeight: true,
            mobileChild: Center(child: Text('No profile data available')),
          );
        }

        // Define responsive values for image size
        final imageSize = context.responsiveValue<double>(
          mobile: 180.0,
          tablet: 240.0,
          smallLaptop: 300.0,
          desktop: 400.0,
          largeDesktop: 480.0,
        );

        // Define text styles with responsive font sizes
        final greetingStyle =
            Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: context.responsiveValue(
                        mobile: 18.0,
                        tablet: 20.0,
                        smallLaptop: 22.0,
                        desktop: 24.0,
                        largeDesktop: 26.0,
                      ),
                    ) ??
                TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: context.responsiveValue(
                    mobile: 18.0,
                    tablet: 20.0,
                    smallLaptop: 22.0,
                    desktop: 24.0,
                    largeDesktop: 26.0,
                  ),
                );

        final nameStyle = Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontSize: context.responsiveValue(
                    mobile: 28.0,
                    tablet: 38.0,
                    smallLaptop: 46.0,
                    desktop: 56.0,
                    largeDesktop: 64.0,
                  ),
                ) ??
            TextStyle(
              fontSize: context.responsiveValue(
                mobile: 28.0,
                tablet: 38.0,
                smallLaptop: 46.0,
                desktop: 56.0,
                largeDesktop: 64.0,
              ),
              fontWeight: FontWeight.bold,
            );

        final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontSize: context.responsiveValue(
                    mobile: 18.0,
                    tablet: 22.0,
                    smallLaptop: 24.0,
                    desktop: 28.0,
                    largeDesktop: 30.0,
                  ),
                ) ??
            TextStyle(
              fontSize: context.responsiveValue(
                mobile: 18.0,
                tablet: 22.0,
                smallLaptop: 24.0,
                desktop: 28.0,
                largeDesktop: 30.0,
              ),
              fontWeight: FontWeight.normal,
            );

        final introStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: context.responsiveValue(
                    mobile: 14.0,
                    tablet: 16.0,
                    smallLaptop: 17.0,
                    desktop: 18.0,
                    largeDesktop: 20.0,
                  ),
                ) ??
            TextStyle(
              fontSize: context.responsiveValue(
                mobile: 14.0,
                tablet: 16.0,
                smallLaptop: 17.0,
                desktop: 18.0,
                largeDesktop: 20.0,
              ),
            );

        return SectionWrapper(
          // fullHeight: true,
          mobileChild: _buildVerticalLayout(context, profile, imageSize,
              greetingStyle, nameStyle, titleStyle, introStyle),
          tabletChild: _buildVerticalLayout(context, profile, imageSize,
              greetingStyle, nameStyle, titleStyle, introStyle),
          smallLaptopChild: _buildHorizontalLayout(context, profile, imageSize,
              greetingStyle, nameStyle, titleStyle, introStyle),
          desktopChild: _buildHorizontalLayout(context, profile, imageSize,
              greetingStyle, nameStyle, titleStyle, introStyle),
          largeDesktopChild: _buildHorizontalLayout(context, profile, imageSize,
              greetingStyle, nameStyle, titleStyle, introStyle),
        );
      },
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    dynamic profile,
    double imageSize,
    TextStyle greetingStyle,
    TextStyle nameStyle,
    TextStyle titleStyle,
    TextStyle introStyle,
  ) {
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
              SelectableText(
                'Hello, I\'m',
                style: greetingStyle,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 12),
              SelectableText(
                profile.name,
                style: nameStyle,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 12),
              SelectableText(
                profile.title,
                style: titleStyle,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 16),
              SelectableText(
                profile.introduction,
                style: introStyle,
                textAlign: TextAlign.center,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 600.ms)
                  .slide(begin: const Offset(0, -0.5)),
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
    TextStyle greetingStyle,
    TextStyle nameStyle,
    TextStyle titleStyle,
    TextStyle introStyle,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                'Hello, I\'m',
                style: greetingStyle,
              )
                  .animate()
                  .fade(duration: 500.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 16),
              SelectableText(
                profile.name,
                style: nameStyle,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 200.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 24),
              SelectableText(
                profile.title,
                style: titleStyle,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 400.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 32),
              SelectableText(
                profile.introduction,
                style: introStyle,
              )
                  .animate()
                  .fade(duration: 500.ms, delay: 600.ms)
                  .slide(begin: const Offset(0, -0.5)),
              const SizedBox(height: 48),
              _buildButtons(context),
            ],
          ),
        ),
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
    // Define responsive button padding
    final buttonPadding = context.responsiveValue<EdgeInsets>(
      mobile: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      tablet: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      smallLaptop: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      desktop: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
      largeDesktop: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
    );

    // Define responsive text style for buttons
    final buttonTextStyle = Theme.of(context).textTheme.labelLarge?.copyWith(
              fontSize: context.responsiveValue(
                mobile: 14.0,
                tablet: 15.0,
                smallLaptop: 16.0,
                desktop: 17.0,
                largeDesktop: 18.0,
              ),
            ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
          fontWeight: FontWeight.w500,
        );

    final children = [
      ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: buttonPadding,
          textStyle: buttonTextStyle,
        ),
        onPressed: () {
          context
              .read<ScrollCubit>()
              .scrollToSection(NavigationSection.portfolio);
        },
        child: const Text('View My Work'),
      )
          .animate()
          .fade(duration: 500.ms, delay: 800.ms)
          .scale(begin: const Offset(0.9, 0.9)),
      SizedBox(width: isVertical ? 16 : 24),
      OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: buttonPadding,
          textStyle: buttonTextStyle,
        ),
        onPressed: () {
          context
              .read<ScrollCubit>()
              .scrollToSection(NavigationSection.contact);
        },
        child: const Text('Contact Me'),
      )
          .animate()
          .fade(duration: 500.ms, delay: 1000.ms)
          .scale(begin: const Offset(0.9, 0.9)),
    ];

    return Row(
      mainAxisAlignment:
          isVertical ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: children,
    );
  }
}
