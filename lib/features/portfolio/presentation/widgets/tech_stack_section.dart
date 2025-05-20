import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class TechStackSection extends StatefulWidget {
  const TechStackSection({super.key});

  @override
  State<TechStackSection> createState() => _TechStackSectionState();
}

class _TechStackSectionState extends State<TechStackSection> with SingleTickerProviderStateMixin {
  String _selectedCategory = 'All';
  late TabController _tabController;
  final List<String> _categories = [
    'All',
    'Frameworks',
    'Programming Languages',
    'UI & Design',
    'Dev Tools & Productivity',
    'Other Technologies',
  ];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
    _tabController.addListener(_handleTabChange);
  }
  
  void _handleTabChange() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedCategory = _categories[_tabController.index];
      });
    }
  }
  
  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
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
        
        // Filter tech stacks based on selected category
        final filteredTechStacks = _selectedCategory == 'All'
            ? profile.techStacks
            : profile.techStacks.where((tech) => tech.category == _selectedCategory).toList();
        
        return Container(
          padding: EdgeInsets.only(
            left: isDesktop ? 300 : AppTheme.spacing24,
            right: AppTheme.spacing24,
            top: AppTheme.spacing64,
            bottom: AppTheme.spacing64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Tech Stack',
                subtitle: 'My Technical Skills',
              ),
              const SizedBox(height: AppTheme.spacing32),
              
              // Category tabs
              TabBar(
                controller: _tabController,
                isScrollable: true,
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: theme.textTheme.bodyMedium?.color,
                indicatorColor: theme.colorScheme.primary,
                tabs: _categories.map((category) => Tab(text: category)).toList(),
              ),
              const SizedBox(height: AppTheme.spacing32),
              
              // Tech stack grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isDesktop ? 4 : (screenSize.width > 600 ? 3 : 2),
                  crossAxisSpacing: AppTheme.spacing16,
                  mainAxisSpacing: AppTheme.spacing16,
                  childAspectRatio: 1.0,
                ),
                itemCount: filteredTechStacks.length,
                itemBuilder: (context, index) {
                  final tech = filteredTechStacks[index];
                  return _TechStackCard(
                    name: tech.name,
                    iconUrl: tech.iconUrl,
                    proficiency: tech.proficiency,
                    index: index,
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TechStackCard extends StatelessWidget {
  final String name;
  final String iconUrl;
  final double proficiency;
  final int index;
  
  const _TechStackCard({
    required this.name,
    required this.iconUrl,
    required this.proficiency,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
              ),
              padding: const EdgeInsets.all(AppTheme.spacing8),
              child: iconUrl.isNotEmpty
                  ? Image.network(
                      iconUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Icon(
                          Icons.code,
                          color: theme.colorScheme.primary,
                          size: 24,
                        );
                      },
                    )
                  : Icon(
                      Icons.code,
                      color: theme.colorScheme.primary,
                      size: 24,
                    ),
            ),
            const SizedBox(height: AppTheme.spacing8),
            Text(
              name,
              style: theme.textTheme.titleSmall,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: AppTheme.spacing8),
            // Proficiency indicator
            LinearProgressIndicator(
              value: proficiency,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
              borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
            ),
            const SizedBox(height: AppTheme.spacing4),
            Text(
              '${(proficiency * 100).toInt()}%',
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 600.ms, delay: Duration(milliseconds: 100 * index)).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}