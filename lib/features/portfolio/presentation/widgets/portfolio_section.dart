import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/theme/app_theme.dart';
import 'package:flutter_portfolio/core/widgets/common/responsive_image.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/data/models/profile_model.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

  final categories = const [
    'All',
    'Full System',
    'Mobile',
    'Web',
    'Backend',
    'Others',
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;
        if (profile == null) {
          return Center(
            child: SelectableText(
              'No profile data available',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        final filteredProjects = state.filteredProjects;

        return SectionWrapper(
          sectionId: 'portfolio',
          title: 'Portfolio',
          subtitle: 'My Recent Work',
          addTopPadding: true,
          addBottomPadding: true,
          mobileChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!),
          tabletChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!),
          smallLaptopChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!),
          desktopChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!),
          largeDesktopChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, List<ProjectModel> projects,
      String selectedCategory) {
    final theme = Theme.of(context);
    final contentWidth = context.contentWidth;

    // Define responsive text style for category chip
    final chipLabelStyle = theme.textTheme.bodyMedium?.copyWith(
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
        );

    return Container(
      width: contentWidth,
      padding:  context.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacing32),
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacing8),
                  child: ChoiceChip(
                    label: SelectableText(
                      category,
                      style: chipLabelStyle.copyWith(
                        color: selectedCategory == category
                            ? theme.colorScheme.primary
                            : theme.textTheme.bodyMedium?.color,
                        fontWeight: selectedCategory == category
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      if (selected) {
                        context
                            .read<PortfolioBloc>()
                            .add(UpdateProjectCategory(category));
                      }
                    },
                    selectedColor: theme.colorScheme.primary.withOpacity(0.2),
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppTheme.borderRadius8),
                      side: BorderSide(
                        color: selectedCategory == category
                            ? theme.colorScheme.primary
                            : Colors.transparent,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppTheme.spacing16,
                      vertical: AppTheme.spacing8,
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: AppTheme.spacing32),
          // Project List
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: projects.length,
            itemBuilder: (context, index) {
              return _ProjectCard(
                project: projects[index],
                index: index,
              );
            },
          ),
        ],
      ),
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
    final isDesktop = context.isDesktop;

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
          child: _buildProjectDetails(context, theme),
        ),
      ],
    );
  }

  Widget _buildMobileLayout(BuildContext context, ThemeData theme) {
    // Define responsive text styles
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
          fontWeight: FontWeight.bold,
        );

    final roleStyle = theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        ) ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        );

    final categoryStyle = theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        ) ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    final descriptionStyle = theme.textTheme.bodyLarge?.copyWith(
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

    final sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
          fontWeight: FontWeight.w500,
        );

    final challengeStyle = theme.textTheme.bodyMedium?.copyWith(
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
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project title, role, and category
        SelectableText(
          project.title,
          style: titleStyle,
        ),
        const SizedBox(height: AppTheme.spacing8),
        SelectableText(
          project.role,
          style: roleStyle,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Chip(
          label: SelectableText(
            project.category,
            style: categoryStyle,
          ),
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Screenshots
        _buildScreenshotCarousel(context, theme),
        const SizedBox(height: AppTheme.spacing24),

        // Description
        SelectableText(
          project.description,
          style: descriptionStyle,
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Technologies
        _buildTechList(context, theme),
        const SizedBox(height: AppTheme.spacing24),

        // Challenges
        if (project.challenge.isNotEmpty) ...[
          SelectableText(
            'Challenge:',
            style: sectionTitleStyle,
          ),
          const SizedBox(height: AppTheme.spacing8),
          SelectableText(
            project.challenge,
            style: challengeStyle,
          ),
          const SizedBox(height: AppTheme.spacing16),
        ],

        // Links
        _buildLinks(theme),
      ],
    );
  }

  Widget _buildProjectDetails(BuildContext context, ThemeData theme) {
    // Define responsive text styles
    final titleStyle = theme.textTheme.headlineSmall?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
          fontWeight: FontWeight.bold,
        );

    final roleStyle = theme.textTheme.titleMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        ) ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        );

    final categoryStyle = theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        ) ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    final descriptionStyle = theme.textTheme.bodyLarge?.copyWith(
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

    final sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
          fontWeight: FontWeight.w500,
        );

    final challengeStyle = theme.textTheme.bodyMedium?.copyWith(
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
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Project title, role, and category
        SelectableText(
          project.title,
          style: titleStyle,
        ),
        const SizedBox(height: AppTheme.spacing8),
        SelectableText(
          project.role,
          style: roleStyle,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Chip(
          label: SelectableText(
            project.category,
            style: categoryStyle,
          ),
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Description
        SelectableText(
          project.description,
          style: descriptionStyle,
        ),
        const SizedBox(height: AppTheme.spacing16),

        // Technologies
        _buildTechList(context, theme),
        const SizedBox(height: AppTheme.spacing24),

        // Challenges
        if (project.challenge.isNotEmpty) ...[
          SelectableText(
            'Challenge:',
            style: sectionTitleStyle,
          ),
          const SizedBox(height: AppTheme.spacing8),
          SelectableText(
            project.challenge,
            style: challengeStyle,
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
                  return ResponsiveImage(
                    imageUrl: screenshot,
                    width: double.infinity,
                    height: 250,
                    fit: BoxFit.cover,
                    enableHoverEffect: false,
                    borderRadius:
                        BorderRadius.circular(AppTheme.borderRadius16),
                    backgroundColor:
                        theme.colorScheme.primary.withOpacity(0.1),
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
            : ResponsiveImage(
                imageUrl: project.screenshots.first,
                width: double.infinity,
                height: 250,
                fit: BoxFit.cover,
                enableHoverEffect: false,
                borderRadius:
                    BorderRadius.circular(AppTheme.borderRadius16),
                backgroundColor:
                    theme.colorScheme.primary.withOpacity(0.1),
              ),
      ),
    );
  }

  Widget _buildTechList(BuildContext context, ThemeData theme) {
    // Define responsive text style for technologies section
    final sectionTitleStyle = theme.textTheme.titleMedium?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
          fontWeight: FontWeight.w500,
        );

    final techChipStyle = theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        ) ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SelectableText(
          'Technologies:',
          style: sectionTitleStyle,
        ),
        const SizedBox(height: AppTheme.spacing8),
        Wrap(
          spacing: AppTheme.spacing8,
          runSpacing: AppTheme.spacing8,
          children: project.technologies.map((tech) {
            return Chip(
              label: SelectableText(
                tech,
                style: techChipStyle,
              ),
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
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
