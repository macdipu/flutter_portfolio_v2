import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:timelines_plus/timelines_plus.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class ExperienceSection extends StatefulWidget {
  const ExperienceSection({super.key});

  @override
  State<ExperienceSection> createState() => _ExperienceSectionState();
}

class _ExperienceSectionState extends State<ExperienceSection>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final theme = Theme.of(context);

    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }

        return Container(
          padding: EdgeInsets.only(
            left: AppTheme.spacing24,
            right: AppTheme.spacing24,
            top: AppTheme.spacing64,
            bottom: AppTheme.spacing64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Experience',
                subtitle: 'My Journey',
              ),
              const SizedBox(height: AppTheme.spacing32),

              // Tab bar for switching between experience and education
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                ),
                child: TabBar(
                  controller: _tabController,
                  indicatorColor: theme.colorScheme.primary,
                  labelColor: theme.colorScheme.primary,
                  unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                  indicatorSize: TabBarIndicatorSize.tab,
                  tabs: const [
                    Tab(text: 'Work Experience'),
                    Tab(text: 'Education'),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacing32),

              // Tab content
              SizedBox(
                height: 480, // Adjust height based on content
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Work experience timeline
                    _TimelineView(items: profile.experiences),

                    // Education timeline
                    _TimelineView(items: profile.educations),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimelineView extends StatelessWidget {
  final List<dynamic> items;

  const _TimelineView({
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return FixedTimeline.tileBuilder(
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
          final item = items[index];
          return Padding(
            padding: const EdgeInsets.only(
                left: AppTheme.spacing24, bottom: AppTheme.spacing32),
            child: _TimelineCard(
              title: item is ExperienceModel ? item.company : item.institution,
              subtitle: item is ExperienceModel ? item.position : item.degree,
              period: item.period,
              description: item.description,
              logoUrl: item.logoUrl,
              index: index,
            ),
          );
        },
        indicatorBuilder: (_, index) {
          return DotIndicator(
            color: theme.colorScheme.primary,
            child: Icon(
              items[index] is ExperienceModel ? Icons.work : Icons.school,
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
    );
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
