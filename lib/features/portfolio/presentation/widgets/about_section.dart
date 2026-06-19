import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/theme/app_typography.dart';
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
        final theme = Theme.of(context);

        final aboutStyle = (theme.textTheme.bodyLarge ?? const TextStyle())
            .copyWith(fontSize: AppTypography.bodyLarge(r));

        final accomplishmentsTitleStyle =
            (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w600,
          fontSize: AppTypography.title(r),
        );

        final cvPromptStyle = (theme.textTheme.bodyMedium ?? const TextStyle())
            .copyWith(fontSize: AppTypography.bodyMedium(r));

        final spacing = r.isMobile ? 8.0 : r.isTablet ? 12.0 : 16.0;

        return SectionWrapper(
          sectionId: 'about',
          title: 'About Me',
          subtitle: 'A brief introduction',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: context.contentWidth,
            padding: context.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SelectableText(profile.about, style: aboutStyle),
                const SizedBox(height: 32),
                SelectableText('Key Accomplishments', style: accomplishmentsTitleStyle),
                const SizedBox(height: 16),
                if (profile.keyAccomplishments.isNotEmpty)
                  Wrap(
                    spacing: spacing,
                    runSpacing: spacing,
                    children: profile.keyAccomplishments
                        .map((a) => _AccomplishmentTile(text: a))
                        .toList(),
                  ),
                const SizedBox(height: 32),
                SelectableText(
                  'Want to know more about my journey? You can download my CV by clicking the button below.',
                  style: cvPromptStyle,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => context.read<ScrollCubit>().scrollToSection(NavigationSection.resume),
                  icon: const Icon(Icons.download),
                  label: const Text('Download CV'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AccomplishmentTile extends StatelessWidget {
  final String text;
  const _AccomplishmentTile({required this.text});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    final style = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w500,
      fontSize: AppTypography.bodyMedium(r),
    );
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.check_circle_outline, color: theme.colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        SelectableText(text, style: style),
      ],
    );
  }
}
