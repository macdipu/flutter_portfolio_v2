import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

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
            bottom: AppTheme.spacing64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'About Me',
                subtitle: 'My Introduction',
              ),
              const SizedBox(height: AppTheme.spacing48),
              if (isDesktop)
                _buildDesktopAbout(profile.about, profile.avatarUrl)
              else
                _buildMobileAbout(profile.about, profile.avatarUrl),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildDesktopAbout(String about, String avatarUrl) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: _buildAboutImage(avatarUrl),
        ),
        const SizedBox(width: AppTheme.spacing48),
        Expanded(
          child: _buildAboutText(about),
        ),
      ],
    );
  }
  
  Widget _buildMobileAbout(String about, String avatarUrl) {
    return Column(
      children: [
        _buildAboutImage(avatarUrl, size: 250),
        const SizedBox(height: AppTheme.spacing32),
        _buildAboutText(about),
      ],
    );
  }
  
  Widget _buildAboutImage(String avatarUrl, {double size = 400}) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: avatarUrl.isNotEmpty
          ? Image.network(
              avatarUrl,
              fit: BoxFit.cover,
              width: size,
              height: size,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.person,
                    size: 100,
                    color: Colors.grey,
                  ),
                );
              },
            )
          : Container(
              color: Colors.grey[300],
              child: const Icon(
                Icons.person,
                size: 100,
                color: Colors.grey,
              ),
            ),
    ).animate().fade(duration: 600.ms).slideX(begin: -0.2, end: 0);
  }
  
  Widget _buildAboutText(String about) {
    return Text(
      about,
      style: const TextStyle(
        fontSize: 16,
        height: 1.8,
      ),
    ).animate().fade(duration: 600.ms, delay: 200.ms).slideX(begin: 0.2, end: 0);
  }
}