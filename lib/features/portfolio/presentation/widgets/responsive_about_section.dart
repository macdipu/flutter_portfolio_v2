import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/responsive_text.dart';
import '../../../../core/widgets/common/section_header.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../bloc/portfolio_bloc.dart';

class ResponsiveAboutSection extends StatelessWidget {
  const ResponsiveAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const SectionWrapper(
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final profile = state.profile;
        if (profile == null) {
          return const SectionWrapper(
            child: Center(child: Text('No profile data available')),
          );
        }

        return SectionWrapper(
          child: Column(
            children: [
              const SectionHeader(
                title: 'About Me',
                subtitle: 'My Introduction',
              ),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context: context,
                mobile: 32.0,
                tablet: 48.0,
                desktop: 64.0,
              )),
              ResponsiveBuilder(
                builder: (context, deviceType, constraints) {
                  switch (deviceType) {
                    case DeviceType.mobile:
                      return _buildMobileAbout(context, profile);
                    case DeviceType.tablet:
                      return _buildTabletAbout(context, profile);
                    case DeviceType.desktop:
                      return _buildDesktopAbout(context, profile);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDesktopAbout(BuildContext context, dynamic profile) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 2,
          child: ResponsiveImage(
            imageUrl: profile.avatarUrl ?? '',
            height: 400,
            width: 400,
            borderRadius: BorderRadius.circular(20),
            fit: BoxFit.cover,
          ).animate().fadeIn(duration: 800.ms).slideX(begin: -0.2),
        ),
        SizedBox(
            width: ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 24.0,
          tablet: 32.0,
          desktop: 48.0,
        )),
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ResponsiveText(
                profile.about ?? 'No bio available',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.8),
                    ),
                maxLines: null,
              ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context: context,
                mobile: 16.0,
                tablet: 20.0,
                desktop: 24.0,
              )),
              _buildStatsRow(context, profile)
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 400.ms),
              SizedBox(
                  height: ResponsiveHelper.getResponsiveValue(
                context: context,
                mobile: 24.0,
                tablet: 28.0,
                desktop: 32.0,
              )),
              _buildActionButtons(context)
                  .animate()
                  .fadeIn(duration: 800.ms, delay: 600.ms),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTabletAbout(BuildContext context, dynamic profile) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ResponsiveImage(
                imageUrl: profile.avatarUrl ?? '',
                height: 300,
                width: 300,
                borderRadius: BorderRadius.circular(16),
                fit: BoxFit.cover,
              ).animate().fadeIn(duration: 800.ms).slideY(begin: -0.2),
            ),
            SizedBox(
                width: ResponsiveHelper.getResponsiveValue(
              context: context,
              mobile: 24.0,
              tablet: 32.0,
              desktop: 48.0,
            )),
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ResponsiveText(
                    profile.about ?? 'No bio available',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          height: 1.6,
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.8),
                        ),
                    maxLines: null,
                  ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
                  SizedBox(
                      height: ResponsiveHelper.getResponsiveValue(
                    context: context,
                    mobile: 16.0,
                    tablet: 20.0,
                    desktop: 24.0,
                  )),
                  _buildStatsRow(context, profile)
                      .animate()
                      .fadeIn(duration: 800.ms, delay: 400.ms),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 24.0,
          tablet: 32.0,
          desktop: 40.0,
        )),
        _buildActionButtons(context)
            .animate()
            .fadeIn(duration: 800.ms, delay: 600.ms),
      ],
    );
  }

  Widget _buildMobileAbout(BuildContext context, dynamic profile) {
    return Column(
      children: [
        ResponsiveImage(
          imageUrl: profile.avatarUrl ?? '',
          height: 250,
          width: 250,
          borderRadius: BorderRadius.circular(16),
          fit: BoxFit.cover,
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: const Offset(0.8, 0.8)),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 24.0,
          tablet: 32.0,
          desktop: 40.0,
        )),
        ResponsiveText(
          profile.about ?? 'No bio available',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                height: 1.6,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
          maxLines: null,
          textAlign: TextAlign.center,
        ).animate().fadeIn(duration: 800.ms, delay: 200.ms),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 20.0,
          tablet: 24.0,
          desktop: 28.0,
        )),
        _buildStatsRow(context, profile)
            .animate()
            .fadeIn(duration: 800.ms, delay: 400.ms),
        SizedBox(
            height: ResponsiveHelper.getResponsiveValue(
          context: context,
          mobile: 24.0,
          tablet: 28.0,
          desktop: 32.0,
        )),
        _buildActionButtons(context)
            .animate()
            .fadeIn(duration: 800.ms, delay: 600.ms),
      ],
    );
  }

  Widget _buildStatsRow(BuildContext context, dynamic profile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildStatItem(
          context,
          title: 'Years',
          subtitle: 'Experience',
          value: '0',
        ),
        _buildStatItem(
          context,
          title: 'Projects',
          subtitle: 'Completed',
          value: '0',
        ),
        _buildStatItem(
          context,
          title: 'Companies',
          subtitle: 'Worked',
          value: '0',
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String value,
  }) {
    return Column(
      children: [
        ResponsiveText(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
        ),
        const SizedBox(height: 4),
        ResponsiveText(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        ResponsiveText(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, deviceType, constraints) {
        final isMobile = deviceType == DeviceType.mobile;

        return Flex(
          direction: isMobile ? Axis.vertical : Axis.horizontal,
          mainAxisAlignment:
              isMobile ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // Handle download CV action
              },
              icon: const Icon(Icons.download),
              label: const Text('Download CV'),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsiveValue(
                    context: context,
                    mobile: 24.0,
                    tablet: 32.0,
                    desktop: 40.0,
                  ),
                  vertical: ResponsiveHelper.getResponsiveValue(
                    context: context,
                    mobile: 12.0,
                    tablet: 16.0,
                    desktop: 20.0,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: isMobile ? 0 : 16,
              height: isMobile ? 16 : 0,
            ),
            OutlinedButton.icon(
              onPressed: () {
                // Handle contact action
              },
              icon: const Icon(Icons.message),
              label: const Text('Contact Me'),
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveHelper.getResponsiveValue(
                    context: context,
                    mobile: 24.0,
                    tablet: 32.0,
                    desktop: 40.0,
                  ),
                  vertical: ResponsiveHelper.getResponsiveValue(
                    context: context,
                    mobile: 12.0,
                    tablet: 16.0,
                    desktop: 20.0,
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
