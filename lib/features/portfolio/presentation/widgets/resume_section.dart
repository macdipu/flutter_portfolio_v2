import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_portfolio/features/portfolio/presentation/bloc/portfolio_bloc.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/section_wrapper.dart';

class ResumeSection extends StatelessWidget {
  const ResumeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading || prev.profile != curr.profile,
      builder: (context, state) {
        final r = context.responsive;
        final showFooter = !r.isMobileOrTablet;

        if (state.isLoading && state.profile == null) {
          return const SectionWrapper(
            title: 'Resume',
            subtitle: 'Download My CV',
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.profile == null) {
          return const SectionWrapper(
            title: 'Resume',
            subtitle: 'Download My CV',
            child: Center(child: Text('No profile data available')),
          );
        }

        final theme = Theme.of(context);
        final titleStyle = (theme.textTheme.headlineMedium ?? const TextStyle()).copyWith(
          fontSize: AppTypography.largeCta(r),
        );
        final descStyle = (theme.textTheme.bodyLarge ?? const TextStyle()).copyWith(
          fontSize: AppTypography.bodyLarge(r),
        );
        final buttonStyle = (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(
          fontSize: AppTypography.bodyMedium(r),
        );

        return SectionWrapper(
          sectionId: 'resume',
          title: 'Resume',
          subtitle: 'Download My CV',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: context.contentWidth,
            padding: context.defaultPadding.copyWith(
              bottom: MediaQuery.of(context).padding.bottom + (theme.textTheme.bodyMedium?.fontSize ?? 16.0) * 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: AppTheme.spacing48),
                Card(
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppTheme.borderRadius16)),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.spacing32),
                    child: Column(
                      children: [
                        Icon(Icons.description, size: 80, color: theme.colorScheme.primary),
                        const SizedBox(height: AppTheme.spacing16),
                        SelectableText('My Resume', style: titleStyle),
                        const SizedBox(height: AppTheme.spacing8),
                        SelectableText(
                          'Download my detailed resume to learn more about my skills, experience, and qualifications.',
                          style: descStyle, textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppTheme.spacing32),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Resume download started', style: theme.textTheme.bodyMedium),
                                duration: const Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.download),
                          label: Text('Download Resume', style: buttonStyle),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacing32, vertical: AppTheme.spacing16),
                          ),
                        ),
                      ],
                    ),
                  ),
                ).animate().fade(duration: 400.ms).scale(begin: const Offset(0.95, 0.95), end: const Offset(1, 1)),
                if (showFooter) ...[
                  const SizedBox(height: AppTheme.spacing64),
                  _Footer(),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    final secondary = theme.colorScheme.onSurface.withAlpha(153);

    final footerStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: secondary, fontSize: AppTypography.bodySmall(r),
    );
    final linkStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colorScheme.primary,
      decoration: TextDecoration.underline,
      fontSize: AppTypography.bodySmall(r),
    );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppTheme.spacing16),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: secondary.withAlpha(51), width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SelectableText('© ${DateTime.now().year} Md. Asad Chowdhury Dipu. All rights reserved.', style: footerStyle),
          const SizedBox(width: AppTheme.spacing16),
          InkWell(
            onTap: () async {
              final url = Uri.parse('https://github.com/dipu0/flutter_portfolio_v2');
              if (await canLaunchUrl(url)) launchUrl(url);
            },
            child: SelectableText('View Source on GitHub', style: linkStyle),
          ),
        ],
      ),
    ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0);
  }
}
