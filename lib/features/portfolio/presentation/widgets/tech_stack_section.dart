import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common/glass_panel.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

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

        return SectionWrapper(
          sectionId: 'techStack',
          title: 'Tech Stack',
          subtitle: 'My Technical Skills',
          addTopPadding: true,
          addBottomPadding: true,
          backgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
          useGlass: true,
          mobileChild: _buildLayout(context, state.filteredTechStacks,
              state.selectedTechStacksCategory),
          tabletChild: _buildLayout(context, state.filteredTechStacks,
              state.selectedTechStacksCategory),
          smallLaptopChild: _buildLayout(context, state.filteredTechStacks,
              state.selectedTechStacksCategory),
          desktopChild: _buildLayout(context, state.filteredTechStacks,
              state.selectedTechStacksCategory),
          largeDesktopChild: _buildLayout(context, state.filteredTechStacks,
              state.selectedTechStacksCategory),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context,
      List<TechStackModel> filteredTechStacks, selectedCategory) {
    final theme = Theme.of(context);
    final contentWidth = context.contentWidth;
    final categories = [
      'All',
      'Frameworks',
      'Programming Languages',
      'UI & Design',
      'Dev Tools & Productivity',
      'Other Technologies',
    ];

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
      padding: context.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacing32),
          // Category chips
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
                        context.read<PortfolioBloc>().add(
                              UpdateTechStackCategory(category),
                            );
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
          // Tech stack grid
          TechStackGrid(items: filteredTechStacks),
        ],
      ),
    );
  }
}

class TechStackGrid extends StatelessWidget {
  final List<TechStackModel> items;

  const TechStackGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        key: ValueKey(items.length),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          crossAxisSpacing: AppTheme.spacing8,
          mainAxisSpacing: AppTheme.spacing8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) => _TechStackCard(
          name: items[index].name,
          iconUrl: items[index].iconUrl,
          index: index,
        ),
      ),
    );
  }
}

class _TechStackCard extends StatelessWidget {
  final String name;
  final String iconUrl;
  final int index;

  const _TechStackCard({
    required this.name,
    required this.iconUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define responsive text style for tech name
    final nameStyle = theme.textTheme.bodySmall?.copyWith(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveValue(
            mobile: 12.0,
            tablet: 13.0,
            smallLaptop: 14.0,
            desktop: 15.0,
            largeDesktop: 16.0,
          ),
        ) ??
        TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: context.responsiveValue(
            mobile: 12.0,
            tablet: 13.0,
            smallLaptop: 14.0,
            desktop: 15.0,
            largeDesktop: 16.0,
          ),
        );

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      borderRadius: 20,
      maxWidth: double.infinity,
      opacity: 0.05,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconUrl.isNotEmpty
              ? ResponsiveImage(
                  imageUrl: iconUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  enableHoverEffect: false,
                  backgroundColor:
                      theme.colorScheme.primary.withOpacity(0.08),
                  padding: const EdgeInsets.all(8),
                  borderRadius:
                      BorderRadius.circular(16),
                )
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius:
                        BorderRadius.circular(16),
                  ),
                  child: Icon(
                    Icons.code,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
          const SizedBox(height: AppTheme.spacing8),
          SelectableText(
            name,
            style: nameStyle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 300.ms, delay: (index * 50).ms)
        .scale(begin: const Offset(0.9, 0.9));
  }
}
