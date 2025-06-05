import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionId: 'about',
      title: 'About Me',
      subtitle: 'A brief introduction to my skills and experience',
      addTopPadding: true,
      addBottomPadding: true,
      mobileChild: _buildLayout(context),
      tabletChild: _buildLayout(context),
      smallLaptopChild: _buildLayout(context),
      desktopChild: _buildLayout(context),
      largeDesktopChild: _buildLayout(context),
    );
  }

  Widget _buildLayout(BuildContext context) {
    final spacing = context.responsive(
      mobile: 12.0,
      tablet: 16.0,
      smallLaptop: 20.0,
      desktop: 24.0,
      largeDesktop: 32.0,
    );

    final cards = const [
      _AboutCard(title: 'Frontend', experience: '3+ yrs'),
      _AboutCard(title: 'Backend', experience: '2+ yrs'),
      _AboutCard(title: 'UI/UX', experience: '1.5+ yrs'),
      _AboutCard(title: 'Tools', experience: '4+ yrs'),
    ];

    return Container(
      width: ResponsiveHelper.getContentWidth(context),
      padding: ResponsiveHelper.getResponsivePadding(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'I’m a software engineer with a passion for building beautiful and functional user interfaces. I specialize in Flutter and enjoy working on responsive design, performance optimization, and scalable architecture.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: ResponsiveHelper.getFontSize(
                    context,
                    mobile: 14,
                    tablet: 16,
                    smallLaptop: 16,
                    desktop: 18,
                    largeDesktop: 20,
                  ),
                ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: spacing,
            runSpacing: spacing,
            children: cards,
          ),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String experience;

  const _AboutCard({
    required this.title,
    required this.experience,
  });

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive(
      mobile: 12.0,
      tablet: 16.0,
      smallLaptop: 18.0,
      desktop: 20.0,
      largeDesktop: 24.0,
    );

    final cardWidth = context.responsive(
      mobile: 140.0,
      tablet: 160.0,
      smallLaptop: 180.0,
      desktop: 200.0,
      largeDesktop: 220.0,
    );

    return SizedBox(
      width: cardWidth,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsets.all(padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  experience,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
