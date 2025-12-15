import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/widgets/common/glass_panel.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final profile = state.profile;
        if (profile == null) {
          return Center(
            child: SelectableText(
              'No profile data available',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        return SectionWrapper(
          sectionId: 'services',
          title: 'Services',
          subtitle: 'What I Offer',
          addTopPadding: true,
          addBottomPadding: true,
          backgroundGradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
          ),
          useGlass: true,
          mobileChild: _buildLayout(context, profile),
          tabletChild: _buildLayout(context, profile),
          smallLaptopChild: _buildLayout(context, profile),
          desktopChild: _buildLayout(context, profile),
          largeDesktopChild: _buildLayout(context, profile),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, ProfileModel profile) {
    final contentWidth = context.contentWidth;

    return GlassPanel(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          ServicesGrid(services: profile.services),
        ],
      ),
    );
  }
}

class ServicesGrid extends StatelessWidget {
  final List<ServiceModel> services;

  const ServicesGrid({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: GridView.builder(
        key: ValueKey(services.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: services.length,
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 400, // item max width for services
          crossAxisSpacing: 24,
          mainAxisSpacing: 24,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final service = services[index];
          return _ServiceCard(
            title: service.title,
            description: service.description,
            iconUrl: service.iconUrl,
            index: index,
          );
        },
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconUrl;
  final int index;

  const _ServiceCard({
    required this.title,
    required this.description,
    required this.iconUrl,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Define responsive text styles
    final titleStyle = theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        ) ??
        TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    final descriptionStyle = theme.textTheme.bodySmall?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 12.0,
            tablet: 13.0,
            smallLaptop: 14.0,
            desktop: 15.0,
            largeDesktop: 16.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 12.0,
            tablet: 13.0,
            smallLaptop: 14.0,
            desktop: 15.0,
            largeDesktop: 16.0,
          ),
        );

    return GlassPanel(
      padding: const EdgeInsets.all(20),
      borderRadius: 24,
      maxWidth: double.infinity,
      opacity: 0.05,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          iconUrl.isNotEmpty
              ? ResponsiveImage(
                  imageUrl: iconUrl,
                  width: 48,
                  height: 48,
                  fit: BoxFit.contain,
                  enableHoverEffect: false,
                  padding: const EdgeInsets.all(6),
                  borderRadius: BorderRadius.circular(20),
                  backgroundColor:
                      theme.colorScheme.primary.withOpacity(0.08),
                )
              : Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(
                    Icons.code,
                    color: theme.colorScheme.primary,
                    size: 24,
                  ),
                ),
          const SizedBox(height: 12),
          SelectableText(
            title,
            style: titleStyle,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 6),
          Expanded(
            child: SelectableText(
              description,
              style: descriptionStyle,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: 350.ms, delay: (index * 100).ms)
        .scale(begin: const Offset(0.95, 0.95));
  }
}
