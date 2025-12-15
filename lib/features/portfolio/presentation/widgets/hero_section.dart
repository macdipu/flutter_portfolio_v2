import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_image.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:flutter_portfolio/core/config/site_config_scope.dart';
import 'package:flutter_portfolio/core/animations/aos_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/data/models/profile_model.dart';
import 'package:flutter_portfolio/core/widgets/common/glass_panel.dart';

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
        final config = SiteConfigScope.of(context).header;
        final animationConfig = SiteConfigScope.of(context).animations;

        // Define responsive values for image size
        final imageSize = context.responsiveValue<double>(
          mobile: 180.0,
          tablet: 240.0,
          smallLaptop: 300.0,
          desktop: 400.0,
          largeDesktop: 480.0,
        );

        // Define responsive fullHeight value
        final fullHeight = context.responsiveValue<bool>(
          mobile: false,
          tablet: false,
          smallLaptop: true,
          desktop: true,
          largeDesktop: true,
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
          fullHeight: fullHeight,
          backgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF203A43),
              Color(0xFF2C5364),
            ],
          ),
          useGlass: true,
          mobileChild: _buildVerticalLayout(
            context,
            profile,
            imageSize,
            greetingStyle,
            nameStyle,
            titleStyle,
            introStyle,
            config,
            animationConfig,
          ),
          tabletChild: _buildVerticalLayout(
            context,
            profile,
            imageSize,
            greetingStyle,
            nameStyle,
            titleStyle,
            introStyle,
            config,
            animationConfig,
          ),
          smallLaptopChild: _buildHorizontalLayout(
            context,
            profile,
            imageSize,
            greetingStyle,
            nameStyle,
            titleStyle,
            introStyle,
            config,
            animationConfig,
          ),
          desktopChild: _buildHorizontalLayout(
            context,
            profile,
            imageSize,
            greetingStyle,
            nameStyle,
            titleStyle,
            introStyle,
            config,
            animationConfig,
          ),
          largeDesktopChild: _buildHorizontalLayout(
            context,
            profile,
            imageSize,
            greetingStyle,
            nameStyle,
            titleStyle,
            introStyle,
            config,
            animationConfig,
          ),
        );
      },
    );
  }

  Widget _buildVerticalLayout(
    BuildContext context,
    ProfileModel profile,
    double imageSize,
    TextStyle greetingStyle,
    TextStyle nameStyle,
    TextStyle titleStyle,
    TextStyle introStyle,
    HeaderConfigModel config,
    AnimationConfigModel animationConfig,
  ) {
    final glassChild = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Flexible(child: SizedBox(height: 20)),
        _buildHeroImage(profile.avatarUrl, imageSize),
        const SizedBox(height: 24),
        _AnimatedLetterBlock(
          lines: [config.greeting],
          style: greetingStyle,
          textAlign: TextAlign.center,
          animationConfig: animationConfig,
          delayMultiplier: 1,
        ),
        const SizedBox(height: 12),
        _AnimatedLetterBlock(
          lines: config.heroNameLines,
          style: nameStyle,
          textAlign: TextAlign.center,
          animationConfig: animationConfig,
          delayMultiplier: 2,
        ),
        const SizedBox(height: 12),
        _AnimatedLetterBlock(
          lines: config.roleLines,
          style: titleStyle,
          textAlign: TextAlign.center,
          animationConfig: animationConfig,
          delayMultiplier: 3,
        ),
        const SizedBox(height: 16),
        AosWrapper(
          enabled: animationConfig.enableAos,
          delay: animationConfig.baseDelay * 3,
          duration: const Duration(milliseconds: 600),
          verticalOffset: animationConfig.verticalOffset,
          child: SelectableText(
            config.infoParagraph,
            style: introStyle,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 24),
        _buildButtons(context, isVertical: true, config: config),
        const Flexible(child: SizedBox(height: 20)),
      ],
    );

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.vertical,
        ),
        child: IntrinsicHeight(
          child: Center(
            child: GlassPanel(child: glassChild),
          ),
        ),
      ),
    );
  }

  Widget _buildHorizontalLayout(
    BuildContext context,
    ProfileModel profile,
    double imageSize,
    TextStyle greetingStyle,
    TextStyle nameStyle,
    TextStyle titleStyle,
    TextStyle introStyle,
    HeaderConfigModel config,
    AnimationConfigModel animationConfig,
  ) {
    final glassChild = Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _AnimatedLetterBlock(
                lines: [config.greeting],
                style: greetingStyle,
                textAlign: TextAlign.start,
                animationConfig: animationConfig,
                delayMultiplier: 1,
              ),
              const SizedBox(height: 16),
              _AnimatedLetterBlock(
                lines: config.heroNameLines,
                style: nameStyle,
                textAlign: TextAlign.start,
                animationConfig: animationConfig,
                delayMultiplier: 2,
              ),
              const SizedBox(height: 24),
              _AnimatedLetterBlock(
                lines: config.roleLines,
                style: titleStyle,
                textAlign: TextAlign.start,
                animationConfig: animationConfig,
                delayMultiplier: 3,
              ),
              const SizedBox(height: 32),
              AosWrapper(
                enabled: animationConfig.enableAos,
                delay: animationConfig.baseDelay * 3,
                duration: const Duration(milliseconds: 600),
                verticalOffset: animationConfig.verticalOffset,
                child: SelectableText(
                  config.infoParagraph,
                  style: introStyle,
                ),
              ),
              const SizedBox(height: 48),
              _buildButtons(context, config: config),
            ],
          ),
        ),
        _buildHeroImage(profile.avatarUrl, imageSize),
      ],
    );

    return Center(
      child: GlassPanel(child: glassChild),
    );
  }

  Widget _buildHeroImage(String avatarUrl, double size) {
    return AosWrapper(
      enabled: true,
      delay: const Duration(milliseconds: 400),
      duration: const Duration(milliseconds: 800),
      verticalOffset: 0.1,
      child: ResponsiveImage(
        imageUrl: avatarUrl,
        width: size,
        height: size,
        borderRadius: BorderRadius.circular(size / 2),
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildButtons(BuildContext context,
      {bool isVertical = false, required HeaderConfigModel config}) {
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
        child: Text(config.primaryCtaLabel),
      ),
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
        child: Text(config.secondaryCtaLabel),
      ),
    ];

    return Row(
      mainAxisAlignment:
          isVertical ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: children,
    );
  }
}

class _AnimatedLetterBlock extends StatelessWidget {
  final List<String> lines;
  final TextStyle style;
  final TextAlign textAlign;
  final AnimationConfigModel animationConfig;
  final int delayMultiplier;

  const _AnimatedLetterBlock({
    required this.lines,
    required this.style,
    required this.textAlign,
    required this.animationConfig,
    required this.delayMultiplier,
  });

  @override
  Widget build(BuildContext context) {
    return AosWrapper(
      enabled: animationConfig.enableAos,
      delay: animationConfig.baseDelay * delayMultiplier,
      duration: const Duration(milliseconds: 600),
      verticalOffset: animationConfig.verticalOffset,
      child: Column(
        crossAxisAlignment: textAlign == TextAlign.center
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        children: lines
            .map(
              (line) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Wrap(
                  alignment: textAlign == TextAlign.center
                      ? WrapAlignment.center
                      : WrapAlignment.start,
                  children: line.split('').map((char) {
                    if (char == ' ') {
                      return const SizedBox(width: 8);
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: SelectableText(
                        char,
                        style: style,
                        textAlign: textAlign,
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
