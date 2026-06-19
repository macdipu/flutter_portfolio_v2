import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/profile_model.dart';
import '../bloc/portfolio_bloc.dart';

class ServicesSection extends StatelessWidget {
  const ServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading || prev.profile != curr.profile,
      builder: (context, state) {
        if (state.isLoading && state.profile == null) {
          return const Center(child: CircularProgressIndicator());
        }
        final profile = state.profile;
        if (profile == null) {
          return Center(child: Text('No profile data available', style: Theme.of(context).textTheme.bodyLarge));
        }

        return SectionWrapper(
          sectionId: 'services',
          title: 'Services',
          subtitle: 'What I Offer',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: context.contentWidth,
            padding: context.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                ServicesGrid(services: profile.services),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ServicesGrid extends StatelessWidget {
  final List<ServiceModel> services;
  const ServicesGrid({super.key, required this.services});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: services.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 400,
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
    );
  }
}

class _ServiceCard extends StatelessWidget {
  final String title;
  final String description;
  final String iconUrl;
  final int index;

  const _ServiceCard({required this.title, required this.description, required this.iconUrl, required this.index});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    final bg = theme.colorScheme.primary.withAlpha(26);

    final titleStyle = (theme.textTheme.titleSmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.w600,
      fontSize: AppTypography.bodyMedium(r),
    );
    final descriptionStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodySmall(r),
    );

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            iconUrl.isNotEmpty
                ? ResponsiveImage(
                    imageUrl: iconUrl, width: 48, height: 48, fit: BoxFit.contain,
                    enableHoverEffect: false, backgroundColor: bg,
                    padding: const EdgeInsets.all(6), borderRadius: BorderRadius.circular(12),
                  )
                : Container(
                    width: 48, height: 48,
                    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
                    child: Icon(Icons.code, color: theme.colorScheme.primary, size: 24),
                  ),
            const SizedBox(height: 12),
            Text(title, style: titleStyle, textAlign: TextAlign.center),
            const SizedBox(height: 6),
            Expanded(
              child: Text(description, style: descriptionStyle, textAlign: TextAlign.center, maxLines: 4, overflow: TextOverflow.ellipsis),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: Duration(milliseconds: 80 * index))
        .scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1));
  }
}
