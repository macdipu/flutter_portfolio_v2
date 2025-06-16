import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';

class SidebarNavigation extends StatelessWidget {
  final NavigationSection currentSection;
  final Function(NavigationSection) onSectionSelected;

  const SidebarNavigation({
    super.key,
    required this.currentSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, info) {
        final deviceType = info.deviceType;
        double sidebarWidth;

        switch (deviceType) {
          case DeviceType.smallLaptop:
            sidebarWidth = 250;
            break;
          case DeviceType.desktop:
            sidebarWidth = 300;
            break;
          case DeviceType.largeDesktop:
            sidebarWidth = 350;
            break;
          default:
            sidebarWidth = 300;
            break;
        }

        return _SidebarLayout(
          width: sidebarWidth,
          currentSection: currentSection,
          onSectionSelected: onSectionSelected,
        );
      },
    );
  }
}

class _SidebarLayout extends StatelessWidget {
  final double width;
  final NavigationSection currentSection;
  final Function(NavigationSection) onSectionSelected;

  const _SidebarLayout({
    required this.width,
    required this.currentSection,
    required this.onSectionSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    final theme = Theme.of(context);

    // Define responsive text styles
    final avatarTextStyle = theme.textTheme.headlineMedium?.copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: context.responsiveValue(
        mobile: 24.0,
        tablet: 26.0,
        smallLaptop: 28.0,
        desktop: 30.0,
        largeDesktop: 32.0,
      ),
    ) ??
        TextStyle(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          fontSize: context.responsiveValue(
            mobile: 24.0,
            tablet: 26.0,
            smallLaptop: 28.0,
            desktop: 30.0,
            largeDesktop: 32.0,
          ),
        );

    final nameStyle = theme.textTheme.titleLarge?.copyWith(
      fontSize: context.responsiveValue(
        mobile: 20.0,
        tablet: 22.0,
        smallLaptop: 24.0,
        desktop: 26.0,
        largeDesktop: 28.0,
      ),
    ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
        );

    final titleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.textTheme.bodySmall?.color,
      fontSize: context.responsiveValue(
        mobile: 14.0,
        tablet: 15.0,
        smallLaptop: 16.0,
        desktop: 17.0,
        largeDesktop: 18.0,
      ),
    ) ??
        TextStyle(
          color: theme.textTheme.bodySmall?.color,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: theme.colorScheme.primary.withOpacity(0.1),
          child: Text(
            'MACD',
            style: avatarTextStyle,
          ),
        ),
        const SizedBox(height: AppTheme.spacing16),
        SelectableText(
          'Md. Asad Chowdhury Dipu',
          style: nameStyle,
          textAlign: TextAlign.center,
        ),
        SelectableText(
          'Flutter Developer',
          style: titleStyle,
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
                icon: FontAwesomeIcons.github,
                url: 'https://github.com/dipu0',
              ),
              _SocialIcon(
                icon: FontAwesomeIcons.linkedin,
                url: 'https://linkedin.com/in/cdipu',
              ),
              _SocialIcon(
                icon: FontAwesomeIcons.twitter,
                url: 'https://twitter.com/c_dipu0',
              ),
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

    // Define responsive text style
    final navItemStyle = theme.textTheme.bodyMedium?.copyWith(
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      fontSize: context.responsiveValue(
        mobile: 14.0,
        tablet: 15.0,
        smallLaptop: 16.0,
        desktop: 17.0,
        largeDesktop: 18.0,
      ),
    ) ??
        TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    return ListTile(
      leading: Icon(
        section.icon,
        color: isSelected ? theme.colorScheme.primary : null,
      ),
      title: Text(
        section.label,
        style: navItemStyle,
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
    final theme = Theme.of(context);
    return IconButton(
      icon: FaIcon(
        icon,
        color: theme.colorScheme.primary,
      ),
      onPressed: () async {
        final uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri);
        }
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