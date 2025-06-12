import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }

        return SectionWrapper(
          sectionId: 'experience',
          title: 'Experience',
          subtitle: 'My Journey',
          addTopPadding: true,
          addBottomPadding: true,
          mobileChild: _buildLayout(context, profile, isVertical: true),
          tabletChild: _buildLayout(context, profile, isVertical: true),
          smallLaptopChild: _buildLayout(context, profile, isVertical: false),
          desktopChild: _buildLayout(context, profile, isVertical: false),
          largeDesktopChild: _buildLayout(context, profile, isVertical: false),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, ProfileModel profile,
      {required bool isVertical}) {
    final contentWidth = ResponsiveHelper.getContentWidth(context);
    final groupedExperiences = profile.experiences;

    return Container(
      width: contentWidth,
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: isVertical
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTimelineSection(
                  context,
                  title: 'Work Experience',
                  items: groupedExperiences,
                  isWork: true,
                ),
                const SizedBox(height: AppTheme.spacing32),
                _buildTimelineSection(
                  context,
                  title: 'Education',
                  items: profile.educations,
                  isWork: false,
                ),
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildTimelineSection(
                    context,
                    title: 'Work Experience',
                    items: groupedExperiences,
                    isWork: true,
                  ),
                ),
                const SizedBox(width: AppTheme.spacing32),
                Expanded(
                  child: _buildTimelineSection(
                    context,
                    title: 'Education',
                    items: profile.educations,
                    isWork: false,
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildTimelineSection(BuildContext context,
      {required String title,
      required List<dynamic> items,
      required bool isWork}) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        FixedTimeline.tileBuilder(
          theme: TimelineThemeData(
            nodePosition: 0,
            color: theme.colorScheme.primary,
            indicatorTheme: IndicatorThemeData(
              size: 20,
              color: theme.colorScheme.primary,
            ),
            connectorTheme: ConnectorThemeData(
              thickness: 2.5,
              color: theme.colorScheme.primary.withOpacity(0.5),
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemCount: items.length,
            contentsBuilder: (_, index) {
              if (isWork) {
                final group = items[index] as ExperienceGroup;
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.spacing24,
                    bottom: AppTheme.spacing32,
                  ),
                  child: _GroupedTimelineCard(
                    company: group.company,
                    logoUrl: group.logoUrl,
                    roles: group.roles,
                    index: index,
                  ),
                );
              } else {
                final edu = items[index] as EducationModel;
                return Padding(
                  padding: const EdgeInsets.only(
                    left: AppTheme.spacing24,
                    bottom: AppTheme.spacing32,
                  ),
                  child: _TimelineCard(
                    title: edu.institution,
                    subtitle: edu.degree,
                    period: edu.period,
                    description: edu.description,
                    logoUrl: edu.logoUrl,
                    index: index,
                  ),
                );
              }
            },
            indicatorBuilder: (_, index) {
              return DotIndicator(
                color: theme.colorScheme.primary,
                child: Icon(
                  isWork ? Icons.work : Icons.school,
                  color: Colors.white,
                  size: 12,
                ),
              );
            },
            connectorBuilder: (_, index, __) {
              return SolidLineConnector(
                color: theme.colorScheme.primary.withOpacity(0.5),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _GroupedTimelineCard extends StatelessWidget {
  final String company;
  final String logoUrl;
  final List<ExperienceModel> roles;
  final int index;

  const _GroupedTimelineCard({
    required this.company,
    required this.logoUrl,
    required this.roles,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: ExpansionTile(
          tilePadding: EdgeInsets.zero,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          leading: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
              child: Image.network(
                logoUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(Icons.business, color: theme.colorScheme.primary);
                },
              ),
            ),
          ),
          title: Text(
            company,
            style: theme.textTheme.titleMedium
                ?.copyWith(fontWeight: FontWeight.bold),
          ),
          childrenPadding: const EdgeInsets.only(
            left: AppTheme.spacing24,
            bottom: AppTheme.spacing16,
            right: AppTheme.spacing8,
          ),
          children: roles.map((role) {
            return Padding(
              padding: const EdgeInsets.only(bottom: AppTheme.spacing16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    role.position,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: AppTheme.spacing4),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing12,
                      vertical: AppTheme.spacing4,
                    ),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadius8),
                    ),
                    child: Text(
                      role.period,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(role.description, style: theme.textTheme.bodyMedium),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    )
        .animate()
        .fade(duration: 600.ms, delay: Duration(milliseconds: 200 * index))
        .slideY(begin: 0.1, end: 0);
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
    required this.title,
    required this.subtitle,
    required this.period,
    required this.description,
    required this.logoUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                  ),
                  child: logoUrl.isNotEmpty
                      ? ClipRRect(
                          borderRadius:
                              BorderRadius.circular(AppTheme.borderRadius8),
                          child: Image.network(
                            logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.business,
                                color: theme.colorScheme.primary,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.business,
                          color: theme.colorScheme.primary,
                        ),
                ),
                const SizedBox(width: AppTheme.spacing16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppTheme.spacing4),
                      Text(
                        subtitle,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacing16),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppTheme.spacing16,
                vertical: AppTheme.spacing8,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
              ),
              child: Text(
                period,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              description,
              style: theme.textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 600.ms, delay: Duration(milliseconds: 200 * index))
        .slideY(begin: 0.1, end: 0);
  }
}
