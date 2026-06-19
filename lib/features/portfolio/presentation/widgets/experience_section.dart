import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading || prev.profile != curr.profile,
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = state.profile;
        if (profile == null) {
          return Center(child: Text('No profile data available', style: Theme.of(context).textTheme.bodyLarge));
        }

        final r = context.responsive;
        final isVertical = r.isMobileOrTablet;

        return SectionWrapper(
          sectionId: 'experience',
          title: 'Experience',
          subtitle: 'My Journey',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: context.contentWidth,
            padding: context.defaultPadding,
            child: isVertical
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _TimelineSection(title: 'Work Experience', items: profile.experiences, isWork: true),
                      const SizedBox(height: AppTheme.spacing32),
                      _TimelineSection(title: 'Education', items: profile.educations, isWork: false),
                    ],
                  )
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _TimelineSection(title: 'Work Experience', items: profile.experiences, isWork: true)),
                      const SizedBox(width: AppTheme.spacing32),
                      Expanded(child: _TimelineSection(title: 'Education', items: profile.educations, isWork: false)),
                    ],
                  ),
          ),
        );
      },
    );
  }
}

class _TimelineSection extends StatelessWidget {
  final String title;
  final List<dynamic> items;
  final bool isWork;

  const _TimelineSection({required this.title, required this.items, required this.isWork});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    final titleStyle = (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.bold,
      color: theme.colorScheme.primary,
      fontSize: AppTypography.heading(r),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(title, style: titleStyle),
        const SizedBox(height: AppTheme.spacing16),
        ...List.generate(items.length, (index) {
          Widget content;
          if (isWork) {
            final group = items[index] as ExperienceGroup;
            content = _GroupedTimelineCard(company: group.company, logoUrl: group.logoUrl, roles: group.roles, index: index);
          } else {
            final edu = items[index] as EducationModel;
            content = _TimelineCard(
              title: edu.institution,
              subtitle: edu.degree,
              period: edu.period,
              description: edu.description,
              logoUrl: edu.logoUrl,
              index: index,
            );
          }
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Container(
                  width: 20, height: 20,
                  decoration: BoxDecoration(color: theme.colorScheme.primary, shape: BoxShape.circle),
                  child: Icon(isWork ? Icons.work : Icons.school, color: theme.colorScheme.onPrimary, size: 12),
                ),
                if (index < items.length - 1)
                  Container(width: 2.5, height: 100, color: theme.colorScheme.primary.withAlpha(128)),
              ]),
              const SizedBox(width: AppTheme.spacing24),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: AppTheme.spacing32),
                  child: content,
                ),
              ),
            ],
          );
        }),
      ],
    );
  }
}

class _GroupedTimelineCard extends StatelessWidget {
  final String company;
  final String logoUrl;
  final List<ExperienceModel> roles;
  final int index;

  const _GroupedTimelineCard({required this.company, required this.logoUrl, required this.roles, required this.index});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);

    final companyStyle = (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.bold,
      fontSize: AppTypography.title(r),
    );
    final positionStyle = (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w600,
      fontSize: AppTypography.bodyLarge(r),
    );
    final periodStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: AppTypography.bodySmall(r),
    );
    final descriptionStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodyMedium(r),
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius16)),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          childrenPadding: const EdgeInsets.only(
            left: AppTheme.spacing24, bottom: AppTheme.spacing16, right: AppTheme.spacing8,
          ),
          leading: _CompanyLogo(logoUrl: logoUrl),
          title: SelectableText(company, style: companyStyle),
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: roles.map((role) => Padding(
                    padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
                    child: _ExperienceRoleCard(
                      role: role,
                      positionStyle: positionStyle,
                      periodStyle: periodStyle,
                      descriptionStyle: descriptionStyle,
                      theme: theme,
                    ),
                  )).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: Duration(milliseconds: 100 * index))
        .slideY(begin: 0.05, end: 0);
  }
}

class _ExperienceRoleCard extends StatelessWidget {
  final ExperienceModel role;
  final TextStyle positionStyle;
  final TextStyle periodStyle;
  final TextStyle descriptionStyle;
  final ThemeData theme;

  const _ExperienceRoleCard({
    required this.role,
    required this.positionStyle,
    required this.periodStyle,
    required this.descriptionStyle,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(role.position, style: positionStyle),
        const SizedBox(height: AppTheme.spacing4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing12, vertical: AppTheme.spacing4),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withAlpha(26),
            borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
          ),
          child: SelectableText(role.period, style: periodStyle),
        ),
        const SizedBox(height: AppTheme.spacing8),
        SelectableText(role.description, style: descriptionStyle),
      ],
    );
  }
}

class _CompanyLogo extends StatelessWidget {
  final String logoUrl;
  const _CompanyLogo({required this.logoUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderRadius = BorderRadius.circular(AppTheme.borderRadius8);
    final bg = theme.colorScheme.primary.withAlpha(26);
    final child = logoUrl.isNotEmpty
        ? ResponsiveImage(
            imageUrl: logoUrl, width: 50, height: 50, maxWidth: 50, maxHeight: 50,
            enableHoverEffect: false, borderRadius: borderRadius, backgroundColor: bg, fit: BoxFit.cover,
          )
        : Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: bg, borderRadius: borderRadius),
            child: Icon(Icons.business, color: theme.colorScheme.primary),
          );
    return SizedBox(width: 56, height: 56, child: Align(alignment: Alignment.centerLeft, child: child));
  }
}

class _TimelineCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String period;
  final String description;
  final String logoUrl;
  final int index;

  const _TimelineCard({
    required this.title, required this.subtitle, required this.period,
    required this.description, required this.logoUrl, required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    final bg = theme.colorScheme.primary.withAlpha(26);

    final titleStyle = (theme.textTheme.titleMedium ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.bold, fontSize: AppTypography.title(r),
    );
    final subtitleStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodyMedium(r),
    );
    final periodStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colorScheme.primary, fontWeight: FontWeight.bold, fontSize: AppTypography.bodySmall(r),
    );
    final descriptionStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodyMedium(r),
    );

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius16)),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              logoUrl.isNotEmpty
                  ? ResponsiveImage(
                      imageUrl: logoUrl, width: 50, height: 50, maxWidth: 50, maxHeight: 50,
                      enableHoverEffect: false,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      backgroundColor: bg, fit: BoxFit.cover,
                    )
                  : Container(
                      width: 50, height: 50,
                      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppTheme.borderRadius8)),
                      child: Icon(Icons.business, color: theme.colorScheme.primary),
                    ),
              const SizedBox(width: AppTheme.spacing16),
              Expanded(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SelectableText(title, style: titleStyle),
                  const SizedBox(height: AppTheme.spacing4),
                  SelectableText(subtitle, style: subtitleStyle),
                ],
              )),
            ]),
            const SizedBox(height: AppTheme.spacing16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16, vertical: AppTheme.spacing8),
              decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(AppTheme.borderRadius8)),
              child: SelectableText(period, style: periodStyle),
            ),
            const SizedBox(height: AppTheme.spacing16),
            SelectableText(description, style: descriptionStyle),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: Duration(milliseconds: 100 * index))
        .slideY(begin: 0.05, end: 0);
  }
}
