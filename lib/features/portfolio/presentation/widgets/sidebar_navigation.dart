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
            color: theme.colorScheme.shadow.withAlpha(13),
            blurRadius: 10,
          ),
        ],
      ),
      child: _buildSidebarContent(context),
    );
  }

  Widget _buildSidebarContent(BuildContext context) {
    final theme = Theme.of(context);
    final r = context.responsive;

    final avatarFontSize = r.isMobile ? 24.0 : r.isTablet ? 26.0 : r.isSmallLaptop ? 28.0 : r.isDesktop ? 30.0 : 32.0;
    final nameFontSize   = r.isMobile ? 20.0 : r.isTablet ? 22.0 : r.isSmallLaptop ? 24.0 : r.isDesktop ? 26.0 : 28.0;
    final titleFontSize  = r.isMobile ? 14.0 : r.isTablet ? 15.0 : r.isSmallLaptop ? 16.0 : r.isDesktop ? 17.0 : 18.0;
    final heroRadius     = r.isMobile ? 55.0 : r.isSmallLaptop ? 65.0 : 75.0;

    final avatarTextStyle = (theme.textTheme.headlineMedium ?? const TextStyle()).copyWith(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: avatarFontSize,
    );
    final nameStyle = (theme.textTheme.titleLarge ?? const TextStyle()).copyWith(
      fontSize: nameFontSize,
    );
    final titleStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      color: theme.textTheme.bodySmall?.color,
      fontSize: titleFontSize,
    );

    return Column(
      children: [
        const SizedBox(height: AppTheme.spacing24),
        _SidebarHeroImage(
          radius: heroRadius,
          primaryColor: theme.colorScheme.primary,
          fallbackStyle: avatarTextStyle,
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

class _SidebarHeroImage extends StatelessWidget {
  final double radius;
  final Color primaryColor;
  final TextStyle fallbackStyle;

  const _SidebarHeroImage({
    required this.radius,
    required this.primaryColor,
    required this.fallbackStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: radius * 2 + 6,
          height: radius * 2 + 6,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: primaryColor, width: 3),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withAlpha(77),
                blurRadius: 24,
                spreadRadius: 4,
              ),
            ],
          ),
        ),
        ClipOval(
          child: Image.network(
            'https://github.com/dipu0.png',
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              width: radius * 2,
              height: radius * 2,
              color: primaryColor.withAlpha(26),
              child: Center(
                child: Text('MACD', style: fallbackStyle),
              ),
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

    final r = context.responsive;
    final navFontSize = r.isMobile ? 14.0 : r.isTablet ? 15.0 : r.isSmallLaptop ? 16.0 : r.isDesktop ? 17.0 : 18.0;
    final navItemStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      fontSize: navFontSize,
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