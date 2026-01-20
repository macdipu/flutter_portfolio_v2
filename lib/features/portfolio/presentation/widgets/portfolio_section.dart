import 'package:any_image_view/any_image_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/theme/app_theme.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/data/models/profile_model.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/widgets/dynamic_screenshot_banner.dart';
import 'package:url_launcher/url_launcher.dart';

class PortfolioSection extends StatelessWidget {
  const PortfolioSection({super.key});

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
        final categories = ProjectCategory.values.where((c) => c == ProjectCategory.all || profile.projects.any((p) => p.category == c)).toList();

        return SectionWrapper(
          sectionId: 'portfolio',
          title: 'Portfolio',
          subtitle: 'My Recent Work',
          addTopPadding: true,
          addBottomPadding: true,
          mobileChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!, categories),
          tabletChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!, categories),
          smallLaptopChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!, categories),
          desktopChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!, categories),
          largeDesktopChild: _buildLayout(
              context, filteredProjects, state.selectedProjectCategory!, categories),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, List<ProjectModel> projects,
      ProjectCategory selectedCategory, List<ProjectCategory> categories) {
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
                    label: Text(
                      category.displayName,
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
                    selectedColor: theme.colorScheme.primary.withAlpha((0.2 * 255).toInt()),
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
              return Portfolios(
                project: projects[index],
              );
            },
          ),
        ],
      ),
    );
  }
}

class Portfolios extends StatelessWidget {
  final ProjectModel project;

  const Portfolios({
    Key? key,
    required this.project,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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

    Widget details = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // App icon
        if (project.appIconUrl?.isNotEmpty ?? false)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: AnyImageView(
              imagePath: project.appIconUrl!,
              width: 64,
              height: 64,
            ),
          ),
        // App name
        SelectableText(
          project.title,
          style: titleStyle,
        ),
        const SizedBox(height: 16),
        // Short description
        SelectableText(
          project.description,
          style: descriptionStyle,
        ),
        const SizedBox(height: 16),
        // Technologies
        if (project.technologies.isNotEmpty)
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: project.technologies
                .map((tech) => Chip(
                      label: Text(tech),
                      backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      labelStyle: TextStyle(color: theme.colorScheme.onSurface),
                    ))
                .toList(),
          ),
        if (project.technologies.isNotEmpty) const SizedBox(height: 16),
        // App Store / Play Store buttons
        if (project.appUrl.isNotEmpty)
          ElevatedButton.icon(
            onPressed: () async {
              final url = Uri.parse(project.appUrl);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            icon: const Icon(Icons.android),
            label: const Text('Download on Play Store'),
          ),
      ],
    );

    return Container(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing32),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(32),
      child: DynamicScreenshotBanner(
        screenshots: project.screenshots,
        details: details,
        bannerRatio: 16 / 9,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
