import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

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
            left: isDesktop ? 300 : AppTheme.spacing24,
            right: AppTheme.spacing24,
            top: AppTheme.spacing64,
            bottom: MediaQuery.of(context).padding.bottom + AppTheme.spacing64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SectionHeader(
                title: 'Resume',
                subtitle: 'Download My CV',
              ),
              const SizedBox(height: AppTheme.spacing48),
              
              // Resume download section
              Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(AppTheme.spacing32),
                  child: Column(
                    children: [
                      Icon(
                        Icons.description,
                        size: 80,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(height: AppTheme.spacing16),
                      Text(
                        'My Resume',
                        style: theme.textTheme.headlineMedium,
                      ),
                      const SizedBox(height: AppTheme.spacing8),
                      Text(
                        'Download my detailed resume to learn more about my skills, experience, and qualifications.',
                        style: theme.textTheme.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppTheme.spacing32),
                      ElevatedButton.icon(
                        onPressed: () {
                          // In a real app, this would download the resume
                          // For now, we'll just show a snackbar
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Resume download started'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.download),
                        label: const Text('Download Resume'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing32,
                            vertical: AppTheme.spacing16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ).animate().fade(duration: 600.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            ],
          ),
        );
      },
    );
  }
}