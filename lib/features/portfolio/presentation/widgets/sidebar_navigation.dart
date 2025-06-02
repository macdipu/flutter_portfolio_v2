import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';

class SidebarNavigation extends StatelessWidget {
  final bool isOpen;
  final NavigationSection currentSection;
  final VoidCallback onToggle;
  final Function(NavigationSection) onSectionSelected;

  const SidebarNavigation({
    super.key,
    required this.isOpen,
    required this.currentSection,
    required this.onToggle,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        if (deviceType == DeviceType.desktop) {
          return _DesktopSidebar(
            currentSection: currentSection,
            onSectionSelected: onSectionSelected,
          );
        } else {
          // Tablet: 0.5 width, Mobile: 0.75 width
          final width = deviceType == DeviceType.tablet
              ? constraints.maxWidth * 0.5
              : constraints.maxWidth * 0.75;
          return _MobileSidebar(
            isOpen: isOpen,
            currentSection: currentSection,
            onToggle: onToggle,
            onSectionSelected: onSectionSelected,
            width: width,
          );
        }
      },
    );
  }
}

class _DesktopSidebar extends StatelessWidget {
  final NavigationSection currentSection;
  final Function(NavigationSection) onSectionSelected;

  const _DesktopSidebar({
    required this.currentSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 250,
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing32),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: CircleAvatar(
              radius: 50,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
              child: Text(
                'JD',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'John Doe',
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(
            'Flutter Developer',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacing32),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
              child: Column(
                children: NavigationSection.values.map((section) {
                  return _NavigationItem(
                    section: section,
                    isSelected: section == currentSection,
                    onTap: () => onSectionSelected(section),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _SocialIcon(
                    icon: FontAwesomeIcons.github, url: 'https://github.com'),
                _SocialIcon(
                    icon: FontAwesomeIcons.linkedin,
                    url: 'https://linkedin.com'),
                _SocialIcon(
                    icon: FontAwesomeIcons.twitter, url: 'https://twitter.com'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileSidebar extends StatelessWidget {
  final bool isOpen;
  final NavigationSection currentSection;
  final VoidCallback onToggle;
  final Function(NavigationSection) onSectionSelected;
  final double width;

  const _MobileSidebar({
    required this.isOpen,
    required this.currentSection,
    required this.onToggle,
    required this.onSectionSelected,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Stack(
      children: [
        // Hamburger menu button
        Positioned(
          top: 16,
          left: 16,
          child: IconButton(
            icon: Icon(
              isOpen ? Icons.close : Icons.menu,
              color: theme.colorScheme.primary,
            ),
            onPressed: onToggle,
          ),
        ),

        // Sidebar drawer
        if (isOpen)
          Animate(
            effects: const [
              SlideEffect(
                begin: Offset(-1, 0),
                end: Offset(0, 0),
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOutCubic,
              ),
            ],
            child: Container(
              width: screenSize.width * 0.75,
              height: screenSize.height,
              color: theme.cardColor,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + AppTheme.spacing48,
                bottom: AppTheme.spacing32,
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
                    child: Text(
                      'JD',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    'John Doe',
                    style: theme.textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Flutter Developer',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.textTheme.bodySmall?.color,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(
                          horizontal: AppTheme.spacing16),
                      child: Column(
                        children: NavigationSection.values.map((section) {
                          return _NavigationItem(
                            section: section,
                            isSelected: section == currentSection,
                            onTap: () {
                              onSectionSelected(section);
                              onToggle(); // Close the sidebar after selection
                            },
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _SocialIcon(
                            icon: FontAwesomeIcons.github,
                            url: 'https://github.com'),
                        _SocialIcon(
                            icon: FontAwesomeIcons.linkedin,
                            url: 'https://linkedin.com'),
                        _SocialIcon(
                            icon: FontAwesomeIcons.twitter,
                            url: 'https://twitter.com'),
                        _SocialIcon(
                            icon: FontAwesomeIcons.dribbble,
                            url: 'https://dribbble.com'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}

class _NavigationItem extends StatelessWidget {
  final NavigationSection section;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavigationItem({
    required this.section,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppTheme.spacing8),
        padding: const EdgeInsets.symmetric(
          vertical: AppTheme.spacing16,
          horizontal: AppTheme.spacing16,
        ),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
        ),
        child: Row(
          children: [
            Icon(
              _getIconForSection(section),
              color: isSelected ? Colors.white : theme.colorScheme.primary,
              size: 20,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Text(
              _getSectionName(section),
              style: theme.textTheme.titleMedium?.copyWith(
                color: isSelected
                    ? Colors.white
                    : theme.textTheme.titleMedium?.color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForSection(NavigationSection section) {
    switch (section) {
      case NavigationSection.hero:
        return Icons.home;
      case NavigationSection.about:
        return Icons.person;
      case NavigationSection.experience:
        return Icons.work;
      case NavigationSection.portfolio:
        return Icons.cases;
      case NavigationSection.services:
        return Icons.design_services;
      case NavigationSection.techStack:
        return Icons.code;
      case NavigationSection.blog:
        return Icons.article;
      case NavigationSection.contact:
        return Icons.email;
      case NavigationSection.resume:
        return Icons.description;
    }
  }

  String _getSectionName(NavigationSection section) {
    switch (section) {
      case NavigationSection.hero:
        return 'Home';
      case NavigationSection.about:
        return 'About';
      case NavigationSection.experience:
        return 'Experience';
      case NavigationSection.portfolio:
        return 'Portfolio';
      case NavigationSection.services:
        return 'Services';
      case NavigationSection.techStack:
        return 'Tech Stack';
      case NavigationSection.blog:
        return 'Blog';
      case NavigationSection.contact:
        return 'Contact';
      case NavigationSection.resume:
        return 'Resume';
    }
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({
    required this.icon,
    required this.url,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IconButton(
      icon: FaIcon(
        icon,
        size: 20,
        color: theme.colorScheme.primary,
      ),
      onPressed: () {
        // Open URL (would use url_launcher in a real app)
      },
    );
  }
}
