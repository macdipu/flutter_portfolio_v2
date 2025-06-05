import 'package:flutter/material.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidget(
      mobile:
          _buildLayout(context, maxWidth: double.infinity, crossAxisCount: 1),
      tablet: _buildLayout(context, maxWidth: 720, crossAxisCount: 1),
      smallLaptop: _buildLayout(context, maxWidth: 860, crossAxisCount: 2),
      desktop: _buildLayout(context, maxWidth: 1024, crossAxisCount: 2),
      largeDesktop: _buildLayout(context, maxWidth: 1200, crossAxisCount: 2),
    );
  }

  Widget _buildLayout(
    BuildContext context, {
    required double maxWidth,
    required int crossAxisCount,
  }) {
    return Center(
      child: Container(
        width: maxWidth,
        padding: ResponsiveHelper.getResponsivePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About Me',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context,
                        mobile: 24,
                        tablet: 28,
                        smallLaptop: 32,
                        desktop: 36,
                        largeDesktop: 40),
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            Text(
              'I’m a software engineer with a passion for building beautiful and functional user interfaces. I specialize in Flutter and enjoy working on responsive design, performance optimization, and scalable architecture.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: ResponsiveHelper.getFontSize(context,
                        mobile: 14,
                        tablet: 16,
                        smallLaptop: 16,
                        desktop: 18,
                        largeDesktop: 20),
                  ),
            ),
            const SizedBox(height: 24),
            LayoutBuilder(
              builder: (context, constraints) {
                final spacing = context.responsive(
                  mobile: 16.0,
                  tablet: 24.0,
                  smallLaptop: 32.0,
                  desktop: 40.0,
                  largeDesktop: 48.0,
                );

                return GridView.count(
                  shrinkWrap: true,
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: spacing,
                  mainAxisSpacing: spacing,
                  physics: const NeverScrollableScrollPhysics(),
                  children: const [
                    _AboutCard(
                        title: 'Frontend', description: 'Flutter, HTML, CSS'),
                    _AboutCard(
                        title: 'Backend', description: 'Firebase, Supabase'),
                    _AboutCard(title: 'UI/UX', description: 'Figma, Adobe XD'),
                    _AboutCard(title: 'Tools', description: 'Git, GitHub, CLI'),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  final String title;
  final String description;

  const _AboutCard({required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    final padding = context.responsive(
      mobile: 16.0,
      tablet: 20.0,
      smallLaptop: 24.0,
      desktop: 28.0,
      largeDesktop: 32.0,
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    )),
            const SizedBox(height: 8),
            Text(description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[700],
                    )),
          ],
        ),
      ),
    );
  }
}
