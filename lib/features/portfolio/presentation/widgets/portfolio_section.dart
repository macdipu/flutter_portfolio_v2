import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/theme/app_theme.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class PortfolioSection extends StatefulWidget {
  const PortfolioSection({super.key});

  @override
  State<PortfolioSection> createState() => _PortfolioSectionState();
}

class _PortfolioSectionState extends State<PortfolioSection> {
  final CarouselController _carouselController = CarouselController();
  int _currentIndex = 0;

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
                title: 'Portfolio',
                subtitle: 'My Recent Work',
              ),
              const SizedBox(height: AppTheme.spacing48),

              // Projects in vertical scroll
              SizedBox(
                height: 600, // Adjust based on your content
                child: ListView.builder(
                  itemCount: profile.projects.length,
                  itemBuilder: (context, index) {
                    return _ProjectCard(
                      project: profile.projects[index],
                      index: index,
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final ProjectModel project;
  final int index;

  const _ProjectCard({
    required this.project,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: AppTheme.spacing32),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: isDesktop
            ? _buildDesktopLayout(context, theme)
            : _buildMobileLayout(context, theme),
      ),
    )
        .animate()
        .fade(duration: 600.ms, delay: Duration(milliseconds: 200 * index))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildDesktopLayout(BuildContext context, ThemeData theme) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Screenshots
        Expanded(
          child: _buildScreenshotCarousel(context, theme),
        ),
        const SizedBox(width: AppTheme.spacing24),

        // Project details
        Expanded(
          child: _buildProjectDetails(theme),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project title and role
        Text(
          project.title,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          project.role,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Screenshots
        _buildScreenshotCarousel(context, theme),
        const SizedBox(height: AppTheme.spacing24),

        // Description
        Text(
          project.description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Technologies
        _buildTechList(theme),
        const SizedBox(height: AppTheme.spacing24),

        // Challenges
        if (project.challenge.isNotEmpty) ...[
          Text(
            'Challenge:',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            project.challenge,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),
        ],

        // Links
        _buildLinks(theme),
      ],
    );
  }

  Widget _buildScreenshotCarousel(BuildContext context, ThemeData theme) {
    if (project.screenshots.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        ),
        child: Center(
          child: Icon(
            Icons.image,
            size: 64,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Container(
      height: 250,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        child: project.screenshots.length > 1
            ? CarouselSlider(
                items: project.screenshots.map((screenshot) {
                  return Image.network(
                    screenshot,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: theme.colorScheme.primary.withOpacity(0.1),
                        child: Icon(
                          Icons.image_not_supported,
                          size: 64,
                          color: theme.colorScheme.primary,
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 250,
                  viewportFraction: 1.0,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  autoPlayAnimationDuration: const Duration(milliseconds: 800),
                  pauseAutoPlayOnTouch: true,
                  enlargeCenterPage: true,
                ),
              )
            : Image.network(
                project.screenshots.first,
                fit: BoxFit.cover,
                width: double.infinity,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: theme.colorScheme.primary.withOpacity(0.1),
                    child: Icon(
                      Icons.image_not_supported,
                      size: 64,
                      color: theme.colorScheme.primary,
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildProjectDetails(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project title and role
        Text(
          project.title,
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          project.role,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Description
        Text(
          project.description,
          style: theme.textTheme.bodyLarge,
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Technologies
        _buildTechList(theme),
        const SizedBox(height: AppTheme.spacing24),

        // Challenges
        if (project.challenge.isNotEmpty) ...[
          Text(
            'Challenge:',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            project.challenge,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.spacing16),
        ],

        // Links
        _buildLinks(theme),
      ],
    );
  }

  Widget _buildTechList(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technologies:',
          style: theme.textTheme.titleMedium,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Wrap(
          spacing: AppTheme.spacing8,
          runSpacing: AppTheme.spacing8,
          children: project.technologies.map((tech) {
            return Chip(
              label: Text(tech),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              labelStyle: TextStyle(
                color: theme.colorScheme.primary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildLinks(ThemeData theme) {
    return Row(
      children: [
        if (project.appUrl.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () async {
              final url = Uri.parse(project.appUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            icon: const Icon(Icons.phone_android),
            label: const Text('View App'),
          ),
        const SizedBox(width: AppTheme.spacing16),
        if (project.sourceCodeUrl.isNotEmpty)
          OutlinedButton.icon(
            onPressed: () async {
              final url = Uri.parse(project.sourceCodeUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            icon: const Icon(Icons.code),
            label: const Text('Source Code'),
          ),
      ],
    );
  }
}
