import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/config/site_config_scope.dart';
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
    final config = SiteConfigScope.of(context);

    return Column(
      children: [
        const SizedBox(height: AppTheme.spacing24),
        Text(
          config.sidebar.salutation,
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.primary.withValues(alpha: 0.9),
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: AppTheme.spacing8),
        SelectableText(
          config.sidebar.tagline,
          style: theme.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacing24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing24),
            itemCount: config.sidebar.navigationLinks.length,
            itemBuilder: (context, index) {
              final navLink = config.sidebar.navigationLinks[index];
              final section = NavigationSection.values.firstWhere(
                (nav) => nav.name == navLink.sectionId,
                orElse: () => NavigationSection.hero,
              );
              final isSelected = section == currentSection;

              return _AsciiNavItem(
                label: navLink.label,
                asciiLabel: navLink.asciiLabel,
                isSelected: isSelected,
                onTap: () => onSectionSelected(section),
              );
            },
          ),
        ),
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
          child: Wrap(
            alignment: WrapAlignment.center,
            spacing: AppTheme.spacing16,
            children: config.sidebar.socialLinks
                .map(
                  (link) => _SocialIcon(
                    icon: _mapPlatformToIcon(link.platform),
                    url: link.url,
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _AsciiNavItem extends StatelessWidget {
  final String label;
  final String asciiLabel;
  final bool isSelected;
  final VoidCallback onTap;

  const _AsciiNavItem({
    required this.label,
    required this.asciiLabel,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Container(
        decoration: BoxDecoration(
          color: isSelected
              ? theme.colorScheme.primary.withValues(alpha: 0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.3),
                  width: 1.2,
                )
              : null,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: AppTheme.spacing16,
          vertical: AppTheme.spacing8,
        ),
        child: RichText(
          text: TextSpan(
            style: theme.textTheme.bodyLarge?.copyWith(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.textTheme.bodyLarge?.color,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
            children: [
              TextSpan(text: '$asciiLabel '),
              TextSpan(text: label),
            ],
          ),
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

IconData _mapPlatformToIcon(String platform) {
  switch (platform.toLowerCase()) {
    case 'github':
      return FontAwesomeIcons.github;
    case 'linkedin':
      return FontAwesomeIcons.linkedin;
    case 'twitter':
      return FontAwesomeIcons.twitter;
    case 'email':
      return FontAwesomeIcons.envelope;
    default:
      return FontAwesomeIcons.globe;
  }
}
