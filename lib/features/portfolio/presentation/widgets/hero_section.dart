import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_image.dart';
import 'package:flutter_portfolio/core/theme/app_typography.dart';
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

        final r = context.responsive;
        final theme = Theme.of(context);

        final imageSize = r.isMobile ? 180.0 : r.isTablet ? 240.0 : r.isSmallLaptop ? 300.0 : r.isDesktop ? 400.0 : 480.0;
        final fullHeight = !r.isMobileOrTablet;

        final greetingStyle = (theme.textTheme.headlineMedium ?? const TextStyle()).copyWith(
          color: theme.colorScheme.primary,
          fontSize: AppTypography.sectionLabel(r),
        );
        final nameStyle = (theme.textTheme.displaySmall ?? const TextStyle()).copyWith(
          fontSize: AppTypography.display(r),
        );
        final titleStyle = (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
          fontSize: AppTypography.heroTitle(r),
          fontWeight: FontWeight.normal,
        );
        final introStyle = (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
          fontSize: AppTypography.bodyLarge(r),
        );

        return SectionWrapper(
          fullHeight: fullHeight,
          child: r.isMobileOrTablet
              ? _buildVerticalLayout(context, profile, imageSize, greetingStyle, nameStyle, titleStyle, introStyle)
              : _buildHorizontalLayout(context, profile, imageSize, greetingStyle, nameStyle, titleStyle, introStyle),
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
              _buildHeroImage(context, profile.avatarUrl, imageSize),
              const SizedBox(height: 24),
              _buildAvailableBadge(context, isCentered: true),
              const SizedBox(height: 12),
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
              _buildAvailableBadge(context),
              const SizedBox(height: 16),
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
        _buildHeroImage(context, profile.avatarUrl, imageSize),
      ],
    );
  }

  Widget _buildHeroImage(BuildContext context, String avatarUrl, double size) {
    final orbitSize = size * 1.45;

    final r = context.responsive;
    final tagFontSize = AppTypography.bodySmall(r);
    final tagIconSize = AppTypography.bodySmall(r);
    final tagHPad = r.isMobile ? 10.0 : r.isTablet ? 12.0 : r.isSmallLaptop ? 13.0 : r.isDesktop ? 14.0 : 16.0;
    final tagVPad = r.isMobile ? 8.0 : r.isTablet ? 9.0 : 10.0;
    final tagPadding = EdgeInsets.symmetric(horizontal: tagHPad, vertical: tagVPad);

    // Build the portrait area mirroring the ProfileCard composition
    return _HoverFloat(
      child: SizedBox(
        width: orbitSize,
        height: orbitSize,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Larger orbit ring (subtle pulsing)
            Container(
              width: orbitSize,
              height: orbitSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.08),
                  width: 1,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat(reverse: true)).scale(
                  begin: const Offset(0.995, 0.995),
                  end: const Offset(1.005, 1.005),
                  duration: 3000.ms,
                ),

            // Slightly-smaller orbit ring with a faint border (slower subtle motion)
            Container(
              width: size * 1.2,
              height: size * 1.2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.14),
                  width: 1,
                ),
              ),
            ).animate(onPlay: (controller) => controller.repeat()).rotate(
                  // one full turn every 20s
                  begin: 0.0,
                  end: math.pi * 2,
                  duration: 20000.ms,
                ),

            // Main profile image container (border + shadow)
            Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).dividerColor.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.12),
                    blurRadius: 30,
                    spreadRadius: 6,
                  )
                ],
              ),
              child: ClipOval(
                child: ResponsiveImage(
                  imageUrl: avatarUrl,
                  width: size,
                  height: size,
                  fit: BoxFit.cover,
                ),
              ),
            ).animate().fade(duration: 800.ms, delay: 300.ms).scale(begin: const Offset(0.96, 0.96)),

            // Floating tech badges converted to orbiting badges centered in the stack
            // Each _OrbitBadge translates its child around the center using a controller
            _OrbitBadge(
              radius: size * 0.62,
              initialAngle: -math.pi / 4, // top-right
              duration: const Duration(seconds: 11),
              clockwise: true,
              child: _buildFloatingTag(
                label: 'Flutter',
                icon: Icons.flutter_dash,
                delayMs: 300,
                iconSize: tagIconSize,
                fontSize: tagFontSize,
                padding: tagPadding,
              ),
            ),

            _OrbitBadge(
              radius: size * 0.68,
              initialAngle: math.pi, // left
              duration: const Duration(seconds: 13),
              clockwise: false,
              child: _buildFloatingTag(
                label: 'Mobile',
                icon: Icons.phone_android,
                delayMs: 500,
                iconSize: tagIconSize,
                fontSize: tagFontSize,
                padding: tagPadding,
              ),
            ),

            _OrbitBadge(
              radius: size * 0.64,
              initialAngle: math.pi / 6, // upper-right-ish
              duration: const Duration(seconds: 9),
              clockwise: true,
              child: _buildFloatingTag(
                label: 'Web',
                icon: Icons.web,
                delayMs: 700,
                iconSize: tagIconSize,
                fontSize: tagFontSize,
                padding: tagPadding,
              ),
            ),

            _OrbitBadge(
              radius: size * 0.5,
              initialAngle: math.pi * 0.6, // bottom-right-ish
              duration: const Duration(seconds: 14),
              clockwise: false,
              child: _buildFloatingTag(
                label: 'Desktop',
                icon: Icons.desktop_windows,
                delayMs: 900,
                iconSize: tagIconSize,
                fontSize: tagFontSize,
                padding: tagPadding,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingTag({
    required String label,
    required IconData icon,
    required int delayMs,
    required double iconSize,
    required double fontSize,
    required EdgeInsets padding,
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Theme.of(context).colorScheme.surfaceVariant.withAlpha(51),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withAlpha(38),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: iconSize),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(fontSize: fontSize),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(delay: delayMs.ms, duration: 600.ms)
        .slideY(begin: 0.2, end: 0.0, delay: delayMs.ms, duration: 600.ms);
  }

  Widget _buildAvailableBadge(BuildContext context, {bool isCentered = false}) {
    final badgeTextStyle = Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ) ??
        const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        );

    return Align(
      alignment: isCentered ? Alignment.center : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.circle,
              size: 8,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: 8),
            Text('Available for work', style: badgeTextStyle),
          ],
        ),
      )
          .animate()
          .fade(duration: 450.ms)
          .slideY(begin: -0.2, end: 0, duration: 450.ms),
    );
  }

  Widget _buildButtons(BuildContext context, {bool isVertical = false}) {
    final r = context.responsive;
    final hPad = r.isMobile ? 16.0 : r.isTablet ? 20.0 : r.isSmallLaptop ? 24.0 : r.isDesktop ? 28.0 : 32.0;
    final vPad = r.isMobile ? 8.0 : r.isTablet ? 10.0 : r.isSmallLaptop ? 12.0 : r.isDesktop ? 14.0 : 16.0;
    final buttonPadding = EdgeInsets.symmetric(horizontal: hPad, vertical: vPad);
    final buttonTextStyle = (Theme.of(context).textTheme.labelLarge ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodyMedium(r),
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

class _HoverFloat extends StatefulWidget {
  const _HoverFloat({required this.child});

  final Widget child;

  @override
  State<_HoverFloat> createState() => _HoverFloatState();
}

class _HoverFloatState extends State<_HoverFloat> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      cursor: SystemMouseCursors.click,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        scale: _isHovering ? 1.03 : 1.0,
        child: widget.child
            .animate(onPlay: (controller) => controller.repeat(reverse: true))
            .moveY(
              begin: -5,
              end: 5,
              duration: 3200.ms,
              curve: Curves.easeInOut,
            ),
      ),
    );
  }
}

class _OrbitBadge extends StatefulWidget {
  const _OrbitBadge({
    required this.child,
    required this.radius,
    required this.initialAngle,
    required this.duration,
    this.clockwise = true,
  });

  final Widget child;
  final double radius;
  final double initialAngle;
  final Duration duration;
  final bool clockwise;

  @override
  State<_OrbitBadge> createState() => _OrbitBadgeState();
}

class _OrbitBadgeState extends State<_OrbitBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();

    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.linear,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final angle = widget.clockwise ? -math.pi * 2 * _animation.value : math.pi * 2 * _animation.value;
    return Transform.translate(
      offset: Offset.fromDirection(angle + widget.initialAngle, widget.radius),
      child: widget.child,
    );
  }
}
