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
        if (deviceType.index >= DeviceType.smallLaptop.index) {
          return _SidebarLayout(
            width: 250,
            isDrawer: false,
            isOpen: true,
            currentSection: currentSection,
            onToggle: onToggle,
            onSectionSelected: onSectionSelected,
          );
        } else {
          final double width = switch (deviceType) {
            DeviceType.smallLaptop => constraints.maxWidth * 0.4,
            DeviceType.tablet => constraints.maxWidth * 0.5,
            _ => constraints.maxWidth * 0.75,
          };

          return _SidebarLayout(
            width: width,
            isDrawer: true,
            isOpen: isOpen,
            currentSection: currentSection,
            onToggle: onToggle,
            onSectionSelected: onSectionSelected,
          );
        }
      },
    );
  }
}

class _SidebarLayout extends StatelessWidget {
  final double width;
  final bool isDrawer;
  final bool isOpen;
  final NavigationSection currentSection;
  final VoidCallback onToggle;
  final Function(NavigationSection) onSectionSelected;

  const _SidebarLayout({
    required this.width,
    required this.isDrawer,
    required this.isOpen,
    required this.currentSection,
    required this.onToggle,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (!isDrawer) {
      return Container(
        width: width,
        decoration: BoxDecoration(
          color: theme.cardColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: _buildSidebarContent(context, isDrawer),
      );
    }

    return Stack(
      children: [
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
              width: width,
              height: MediaQuery.of(context).size.height,
              color: theme.cardColor,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top + AppTheme.spacing48,
                bottom: AppTheme.spacing32,
              ),
              child: _buildSidebarContent(context, isDrawer),
            ),
          ),
      ],
    );
  }

  Widget _buildSidebarContent(BuildContext context, bool isDrawer) {
    final theme = Theme.of(context);

    return Column(
      children: [
        CircleAvatar(
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
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing16),
            child: Column(
              children: NavigationSection.values.map((section) {
                return _NavigationItem(
                  section: section,
                  isSelected: section == currentSection,
                  onTap: () {
                    onSectionSelected(section);
                    if (isDrawer) onToggle();
                  },
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
                  icon: FontAwesomeIcons.linkedin, url: 'https://linkedin.com'),
              _SocialIcon(
                  icon: FontAwesomeIcons.twitter, url: 'https://twitter.com'),
              if (isDrawer)
                _SocialIcon(
                    icon: FontAwesomeIcons.dribbble,
                    url: 'https://dribbble.com'),
            ],
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
    return ListTile(
      leading: Icon(section.icon,
          color: isSelected ? theme.colorScheme.primary : null),
      title: Text(
        section.label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      onTap: onTap,
    );
  }
}

class _SocialIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const _SocialIcon({required this.icon, required this.url});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        // Launch URL or handle tap
      },
    );
  }
}

extension NavigationSectionExtension on NavigationSection {
  IconData get icon {
    switch (this) {
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

  String get label => name[0].toUpperCase() + name.substring(1);
}
