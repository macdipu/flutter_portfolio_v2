import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/theme/app_typography.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_image.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading || prev.profile != curr.profile,
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return const SectionWrapper(
            title: 'About Me',
            subtitle: 'A brief introduction',
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final r = context.responsive;
        final badge = _experienceBadge(profile.keyAccomplishments);

        return SectionWrapper(
          sectionId: 'about',
          title: 'About Me',
          subtitle: 'A brief introduction',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: context.contentWidth,
            padding: context.defaultPadding,
            child: r.isMobileOrTablet
                ? _buildVerticalLayout(context, profile, badge)
                : _buildHorizontalLayout(context, profile, badge),
          ),
        );
      },
    );
  }

  static String _experienceBadge(List<String> accomplishments) {
    final match = accomplishments.firstWhere(
      (e) => e.toLowerCase().contains('year'),
      orElse: () => '',
    );
    final years = RegExp(r'\d+').firstMatch(match)?.group(0);
    return years == null ? '' : '$years+ Years Experience';
  }

  Widget _buildVerticalLayout(BuildContext context, dynamic profile, String badge) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(child: _AboutPhoto(imageUrl: profile.avatarUrl, badge: badge, size: 260)),
        const SizedBox(height: 32),
        _AboutContent(profile: profile),
      ],
    );
  }

  Widget _buildHorizontalLayout(BuildContext context, dynamic profile, String badge) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 4,
          child: Center(child: _AboutPhoto(imageUrl: profile.avatarUrl, badge: badge, size: 340)),
        ),
        const SizedBox(width: 56),
        Expanded(flex: 5, child: _AboutContent(profile: profile)),
      ],
    );
  }
}

class _AboutPhoto extends StatelessWidget {
  final String imageUrl;
  final String badge;
  final double size;

  const _AboutPhoto({required this.imageUrl, required this.badge, required this.size});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = context.responsive;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: size,
          height: size * 1.2,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 32,
                spreadRadius: 4,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: ResponsiveImage(
              imageUrl: imageUrl,
              width: size,
              height: size * 1.2,
              fit: BoxFit.cover,
              enableHoverEffect: false,
            ),
          ),
        ).animate().fade(duration: 600.ms).slideY(begin: 0.05, end: 0),
        if (badge.isNotEmpty)
          Positioned(
            bottom: -18,
            left: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Text(
                badge,
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: AppTypography.bodyMedium(r),
                ),
              ),
            ).animate().fade(duration: 500.ms, delay: 300.ms).slideY(begin: 0.3, end: 0),
          ),
      ],
    );
  }
}

class _AboutContent extends StatelessWidget {
  final dynamic profile;
  const _AboutContent({required this.profile});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);

    final nameStyle = (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.bold,
      fontSize: AppTypography.title(r),
    );
    final titleStyle = (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
      color: theme.colorScheme.primary,
      fontSize: AppTypography.bodyMedium(r),
    );
    final aboutStyle = (theme.textTheme.bodyLarge ?? const TextStyle())
        .copyWith(fontSize: AppTypography.bodyLarge(r), height: 1.6);

    final spacing = r.isMobile ? 8.0 : r.isTablet ? 10.0 : 12.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText('About ${profile.name}', style: nameStyle)
            .animate()
            .fade(duration: 500.ms)
            .slideY(begin: 0.15, end: 0),
        const SizedBox(height: 6),
        SelectableText(profile.title, style: titleStyle)
            .animate()
            .fade(duration: 500.ms, delay: 100.ms)
            .slideY(begin: 0.15, end: 0),
        const SizedBox(height: 20),
        SelectableText(profile.about, style: aboutStyle)
            .animate()
            .fade(duration: 500.ms, delay: 200.ms),
        if ((profile.keyAccomplishments as List).isNotEmpty) ...[
          const SizedBox(height: 28),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: (profile.keyAccomplishments as List<String>)
                .map((a) => _AccomplishmentChip(text: a))
                .toList(),
          ).animate().fade(duration: 500.ms, delay: 300.ms),
        ],
        const SizedBox(height: 32),
        _buildButtons(context),
      ],
    );
  }

  Widget _buildButtons(BuildContext context) {
    final r = context.responsive;
    final hPad = r.isMobile ? 20.0 : 28.0;
    final vPad = r.isMobile ? 12.0 : 14.0;
    final buttonPadding = EdgeInsets.symmetric(horizontal: hPad, vertical: vPad);
    final buttonTextStyle = TextStyle(fontSize: AppTypography.bodyMedium(r), fontWeight: FontWeight.w600);

    return Wrap(
      spacing: 16,
      runSpacing: 16,
      children: [
        ElevatedButton.icon(
          onPressed: () => context.read<ScrollCubit>().scrollToSection(NavigationSection.contact),
          style: ElevatedButton.styleFrom(
            padding: buttonPadding,
            textStyle: buttonTextStyle,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.arrow_forward, size: 18),
          label: const Text("Let's Work Together"),
        ).animate().fade(duration: 500.ms, delay: 400.ms).scale(begin: const Offset(0.95, 0.95)),
        OutlinedButton.icon(
          onPressed: () => context.read<ScrollCubit>().scrollToSection(NavigationSection.portfolio),
          style: OutlinedButton.styleFrom(
            padding: buttonPadding,
            textStyle: buttonTextStyle,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: const Icon(Icons.circle, size: 8),
          label: const Text('View My Work'),
        ).animate().fade(duration: 500.ms, delay: 500.ms).scale(begin: const Offset(0.95, 0.95)),
        TextButton.icon(
          onPressed: () => context.read<ScrollCubit>().scrollToSection(NavigationSection.resume),
          icon: const Icon(Icons.download, size: 18),
          label: const Text('Download CV'),
        ).animate().fade(duration: 500.ms, delay: 600.ms),
      ],
    );
  }
}

class _AccomplishmentChip extends StatelessWidget {
  final String text;
  const _AccomplishmentChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: r.isMobile ? 12.0 : 14.0,
        vertical: r.isMobile ? 8.0 : 10.0,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withAlpha(20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: theme.colorScheme.primary.withAlpha(60)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 16),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: AppTypography.bodySmall(r),
            ),
          ),
        ],
      ),
    );
  }
}
