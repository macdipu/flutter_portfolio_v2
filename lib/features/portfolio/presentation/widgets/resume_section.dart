import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common/section_wrapper.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        return SectionWrapper(
          sectionId: 'resume',
          title: 'Resume',
          subtitle: 'Download My CV',
          addTopPadding: true,
          addBottomPadding: true,
          mobileChild: _buildLayout(context, state, isFooterVisible: false),
          tabletChild: _buildLayout(context, state, isFooterVisible: false),
          smallLaptopChild: _buildLayout(context, state, isFooterVisible: true),
          desktopChild: _buildLayout(context, state, isFooterVisible: true),
          largeDesktopChild:
              _buildLayout(context, state, isFooterVisible: true),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, PortfolioState state,
      {required bool isFooterVisible}) {
    final contentWidth = ResponsiveHelper.getContentWidth(context);
    final theme = Theme.of(context);
    final textColors = theme.extension<TextColors>();

    if (state.isLoading && state.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final profile = state.profile;
    if (profile == null) {
      return Center(
        child: Text(
          'No profile data available',
          style: theme.textTheme.bodyMedium,
        ),
      );
    }

    return Container(
      width: contentWidth,
      padding: ResponsiveHelper.getResponsivePadding(context).copyWith(
        bottom: MediaQuery.of(context).padding.bottom +
            theme.textTheme.bodyMedium!.fontSize! * 4,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: AppTheme.spacing48),
// Resume download section
          Card(
            elevation: 3,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(AppTheme.spacing32),
              child: Column(
                children: [
                  Icon(
                    Icons.description,
                    size: 80,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(height: AppTheme.spacing16),
                  Text(
                    'My Resume',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: AppTheme.spacing8),
                  Text(
                    'Download my detailed resume to learn more about my skills, experience, and qualifications.',
                    style: theme.textTheme.bodyLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.spacing32),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Resume download started'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    },
                    icon: const Icon(Icons.download),
                    label: Text(
                      'Download Resume',
                      style: theme.textTheme.labelLarge,
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing32,
                        vertical: AppTheme.spacing16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 600.ms).scale(
                begin: const Offset(0.9, 0.9),
                end: const Offset(1, 1),
              ),
          if (isFooterVisible) ...[
            const SizedBox(height: AppTheme.spacing64),
            _buildFooter(context),
          ],
        ],
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final theme = Theme.of(context);
    final textColors = theme.extension<TextColors>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: textColors?.secondary?.withOpacity(0.2) ??
                Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '© ${DateTime.now().year} Md. Asad Chowdhury Dipu. All rights reserved.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: textColors?.secondary,
            ),
          ),
          const SizedBox(width: AppTheme.spacing16),
          InkWell(
            onTap: () async {
              final url =
                  Uri.parse('https://github.com/dipu0/flutter_portfolio_v2');
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            },
            child: Text(
              'View Source on GitHub',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.primary,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
        ],
      ),
    ).animate().fade(duration: 600.ms).slideY(begin: 0.2, end: 0);
  }
}
