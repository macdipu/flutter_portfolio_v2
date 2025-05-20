import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../core/theme/app_theme.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          subtitle,
          style: theme.textTheme.titleMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
        ).animate().fade(duration: 400.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          title,
          style: theme.textTheme.displaySmall,
        ).animate().fade(duration: 400.ms, delay: 200.ms).slideY(begin: -0.2, end: 0),
        const SizedBox(height: AppTheme.spacing16),
        Container(
          width: 80,
          height: 4,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary,
            borderRadius: BorderRadius.circular(2),
          ),
        ).animate().fade(duration: 400.ms, delay: 400.ms).slideX(begin: -0.2, end: 0),
      ],
    );
  }
}