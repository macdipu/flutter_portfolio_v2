import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/core/navigation/scroll_controller.dart';
import 'package:flutter_portfolio/core/responsive/responsive_framework.dart';
import 'package:flutter_portfolio/core/widgets/common/section_wrapper.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';

class AboutSection extends StatelessWidget {
  const AboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionWrapper(
      sectionId: 'about',
      title: 'About Me',
      subtitle: 'A brief introduction',
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

    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        final profile = state.profile;
        if (profile == null) {
          return const Center(child: Text('No profile data available'));
        }
        return Container(
          width: ResponsiveHelper.getContentWidth(context),
          padding: ResponsiveHelper.getResponsivePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.about,
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
              const SizedBox(height: 32),
              Text(
                'Key Accomplishments',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 16),
              state.profile?.keyAccomplishments != null
                  ? Wrap(
                      spacing: spacing,
                      runSpacing: spacing,
                      children: profile.keyAccomplishments
                          .map(
                            (accomplishment) => _AccomplishmentTile(
                              icon: Icons.check_circle_outline,
                              text: accomplishment,
                            ),
                          )
                          .toList(),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 32),
              Text(
                'Want to know more about my journey? You can download my CV by clicking the button below.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {
                  context
                      .read<ScrollCubit>()
                      .scrollToSection(NavigationSection.resume);
                },
                icon: const Icon(Icons.download),
                label: const Text('Download CV'),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _AccomplishmentTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const _AccomplishmentTile({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: Theme.of(context).colorScheme.primary, size: 20),
        const SizedBox(width: 8),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
      ],
    );
  }
}
