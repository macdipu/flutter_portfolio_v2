import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({super.key});

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
          height: screenSize.height,
          width: screenSize.width,
          padding: EdgeInsets.only(
            left: isDesktop ? 300 : AppTheme.spacing24,
            right: AppTheme.spacing24,
          ),
          child: Center(
            child: isDesktop
                ? _buildDesktopHero(context, profile.name, profile.title, profile.introduction, profile.avatarUrl)
                : _buildMobileHero(context, profile.name, profile.title, profile.introduction, profile.avatarUrl),
          ),
        );
      },
    );
  }
  
  Widget _buildDesktopHero(
    BuildContext context, 
    String name, 
    String title, 
    String introduction,
    String avatarUrl,
  ) {
    final theme = Theme.of(context);
    
    return Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, I\'m',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ).animate().fade(duration: 500.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
              const SizedBox(height: AppTheme.spacing8),
              Text(
                name,
                style: theme.textTheme.displayLarge,
              ).animate().fade(duration: 500.ms, delay: 200.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
              const SizedBox(height: AppTheme.spacing16),
              Text(
                title,
                style: theme.textTheme.headlineSmall,
              ).animate().fade(duration: 500.ms, delay: 400.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
              const SizedBox(height: AppTheme.spacing24),
              Text(
                introduction,
                style: theme.textTheme.bodyLarge,
              ).animate().fade(duration: 500.ms, delay: 600.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
              const SizedBox(height: AppTheme.spacing32),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<ScrollCubit>().scrollToSection(NavigationSection.portfolio);
                    },
                    child: const Text('View My Work'),
                  ).animate().fade(duration: 500.ms, delay: 800.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                  const SizedBox(width: AppTheme.spacing16),
                  OutlinedButton(
                    onPressed: () {
                      context.read<ScrollCubit>().scrollToSection(NavigationSection.contact);
                    },
                    child: const Text('Contact Me'),
                  ).animate().fade(duration: 500.ms, delay: 1000.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.spacing48),
        Expanded(
          child: _buildAvatarSection(avatarUrl, theme.colorScheme.primary),
        ),
      ],
    );
  }
  
  Widget _buildMobileHero(
    BuildContext context, 
    String name, 
    String title, 
    String introduction,
    String avatarUrl,
  ) {
    final theme = Theme.of(context);
    
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAvatarSection(avatarUrl, theme.colorScheme.primary, size: 120),
        const SizedBox(height: AppTheme.spacing32),
        Text(
          'Hello, I\'m',
          style: theme.textTheme.headlineMedium?.copyWith(
            color: theme.colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ).animate().fade(duration: 500.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
        const SizedBox(height: AppTheme.spacing8),
        Text(
          name,
          style: theme.textTheme.displaySmall,
          textAlign: TextAlign.center,
        ).animate().fade(duration: 500.ms, delay: 200.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
        const SizedBox(height: AppTheme.spacing16),
        Text(
          title,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ).animate().fade(duration: 500.ms, delay: 400.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
        const SizedBox(height: AppTheme.spacing24),
        Text(
          introduction,
          style: theme.textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ).animate().fade(duration: 500.ms, delay: 600.ms).slide(begin: const Offset(0, -0.5), end: Offset.zero),
        const SizedBox(height: AppTheme.spacing32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                context.read<ScrollCubit>().scrollToSection(NavigationSection.portfolio);
              },
              child: const Text('View My Work'),
            ).animate().fade(duration: 500.ms, delay: 800.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
            const SizedBox(width: AppTheme.spacing16),
            OutlinedButton(
              onPressed: () {
                context.read<ScrollCubit>().scrollToSection(NavigationSection.contact);
              },
              child: const Text('Contact Me'),
            ).animate().fade(duration: 500.ms, delay: 1000.ms).scale(begin: const Offset(0.9, 0.9), end: const Offset(1, 1)),
          ],
        ),
      ],
    );
  }
  
  Widget _buildAvatarSection(String avatarUrl, Color accentColor, {double size = 300}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: accentColor,
          width: 5,
        ),
      ),
      child: ClipOval(
        child: avatarUrl.isNotEmpty
            ? Image.network(
                avatarUrl,
                fit: BoxFit.cover,
                width: size,
                height: size,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: accentColor.withOpacity(0.1),
                    child: Icon(
                      Icons.person,
                      size: size / 2,
                      color: accentColor,
                    ),
                  );
                },
              )
            : Container(
                color: accentColor.withOpacity(0.1),
                child: Icon(
                  Icons.person,
                  size: size / 2,
                  color: accentColor,
                ),
              ),
      ),
    ).animate().fade(duration: 800.ms, delay: 400.ms).scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
  }
}