import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

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
                title: 'Services',
                subtitle: 'What I Offer',
              ),
              const SizedBox(height: AppTheme.spacing48),

              // Services grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      isDesktop ? 3 : (screenSize.width > 600 ? 2 : 1),
                  crossAxisSpacing: AppTheme.spacing24,
                  mainAxisSpacing: AppTheme.spacing24,
                  childAspectRatio: 1.1,
                ),
                itemCount: profile.services.length,
                itemBuilder: (context, index) {
                  return _ServiceCard(
                    title: profile.services[index].title,
                    description: profile.services[index].description,
                    iconUrl: profile.services[index].iconUrl,
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

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconUrl;
  final int index;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spacing24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
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
                          size: 32,
                        );
                      },
                    )
                  : Icon(
                      Icons.code,
                      color: theme.colorScheme.primary,
                      size: 32,
                    ),
            ),
            const SizedBox(height: AppTheme.spacing16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppTheme.spacing8),
            Expanded(
              child: Text(
                description,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 4,
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 600.ms, delay: Duration(milliseconds: 200 * index))
        .scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1));
  }
}
