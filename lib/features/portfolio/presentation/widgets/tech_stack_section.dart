import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';

class TechStackSection extends StatelessWidget {
  const TechStackSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading ||
          prev.profile != curr.profile ||
          prev.filteredTechStacks != curr.filteredTechStacks ||
          prev.selectedTechStacksCategory != curr.selectedTechStacksCategory,
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;
        if (profile == null) {
          return Center(
            child: Text(
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
          mobileChild: _buildLayout(context, state.filteredTechStacks,
              state.selectedTechStacksCategory, profile),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context,
      List<TechStackModel> filteredTechStacks, TechStackCategory selectedCategory, ProfileModel profile) {
    final theme = Theme.of(context);
    final r = context.responsive;
    final contentWidth = context.contentWidth;
    final categories = TechStackCategory.values
        .where((c) => c == TechStackCategory.all || profile.techStacks.any((t) => t.category == c))
        .toList();

    final chipFontSize = r.isMobile ? 14.0 : r.isTablet ? 15.0 : r.isSmallLaptop ? 16.0 : r.isDesktop ? 17.0 : 18.0;
    final chipLabelStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(fontSize: chipFontSize);

    return Container(
      width: contentWidth,
      padding: context.defaultPadding,
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
                final isSelected = selectedCategory == category;
                return Padding(
                  padding: const EdgeInsets.only(right: AppTheme.spacing8),
                  child: ChoiceChip(
                    label: Text(
                      category.displayName,
                      style: chipLabelStyle.copyWith(
                        color: isSelected ? theme.colorScheme.primary : theme.textTheme.bodyMedium?.color,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        context.read<PortfolioBloc>().add(UpdateTechStackCategory(category));
                      }
                    },
                    selectedColor: theme.colorScheme.primary.withAlpha(51),
                    backgroundColor: theme.colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
                      side: BorderSide(
                        color: isSelected ? theme.colorScheme.primary : Colors.transparent,
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
      duration: const Duration(milliseconds: 200),
      child: GridView.builder(
        key: ValueKey(items.map((e) => e.name).join()),
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
        ),
      ),
    );
  }
}

class _TechStackCard extends StatelessWidget {
  final String name;
  final String iconUrl;

  const _TechStackCard({required this.name, required this.iconUrl});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final r = context.responsive;
    final fontSize = r.isMobile ? 12.0 : r.isTablet ? 13.0 : r.isSmallLaptop ? 14.0 : r.isDesktop ? 15.0 : 16.0;
    final nameStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w500,
      fontSize: fontSize,
    );
    final iconBg = theme.colorScheme.primary.withAlpha(26);

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius8)),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconUrl.isNotEmpty
                ? ResponsiveImage(
                    imageUrl: iconUrl,
                    width: 32,
                    height: 32,
                    fit: BoxFit.contain,
                    enableHoverEffect: false,
                    backgroundColor: iconBg,
                    padding: const EdgeInsets.all(AppTheme.spacing4),
                    borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
                  )
                : Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: iconBg,
                      borderRadius: BorderRadius.circular(AppTheme.borderRadius4),
                    ),
                    child: Icon(Icons.code, color: theme.colorScheme.primary, size: 16),
                  ),
            const SizedBox(height: AppTheme.spacing4),
            Text(name, style: nameStyle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
