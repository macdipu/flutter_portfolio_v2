import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/common/responsive_image.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/blog_post_model.dart';
import '../bloc/portfolio_bloc.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      buildWhen: (prev, curr) =>
          prev.isLoading != curr.isLoading ||
          prev.blogPosts != curr.blogPosts ||
          prev.visibleBlogPostCount != curr.visibleBlogPostCount,
      builder: (context, state) {
        final contentWidth = context.contentWidth;
        final maxPosts = state.visibleBlogPostCount.clamp(0, state.blogPosts.length);

        return SectionWrapper(
          sectionId: 'blog',
          title: 'Blog',
          subtitle: 'My Latest Posts',
          addTopPadding: true,
          addBottomPadding: true,
          child: Container(
            width: contentWidth,
            padding: context.defaultPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppTheme.spacing32),
                if (state.isLoading && state.blogPosts.isEmpty)
                  const Center(child: CircularProgressIndicator())
                else if (state.blogPosts.isEmpty)
                  _EmptyBlogState()
                else ...[
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: maxPosts,
                    itemBuilder: (context, index) =>
                        _BlogPostCard(post: state.blogPosts[index], index: index),
                  ),
                  const SizedBox(height: AppTheme.spacing24),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        final url = Uri.parse('https://medium.com/@c.dipu0');
                        if (await canLaunchUrl(url)) launchUrl(url);
                      },
                      child: const Text('Show More on Medium', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _EmptyBlogState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.article_outlined, size: 64, color: theme.colorScheme.primary),
          const SizedBox(height: AppTheme.spacing16),
          Text('No blog posts available',
              style: (theme.textTheme.labelLarge ?? const TextStyle()).copyWith(fontSize: AppTypography.heading(r))),
          const SizedBox(height: AppTheme.spacing8),
          Text('Check back later for new content',
              style: (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(fontSize: AppTypography.bodyMedium(r))),
        ],
      ),
    );
  }
}

class _BlogPostCard extends StatelessWidget {
  final BlogPostModel post;
  final int index;

  const _BlogPostCard({required this.post, required this.index});

  @override
  Widget build(BuildContext context) {
    final r = context.responsive;
    final theme = Theme.of(context);
    final isNarrow = r.isMobile;

    String formattedDate = post.publishDate;
    try {
      final date = DateTime.tryParse(post.publishDate);
      if (date != null) formattedDate = DateFormat.yMMMMd().format(date);
    } catch (_) {}

    final dateStyle = (theme.textTheme.bodySmall ?? const TextStyle()).copyWith(
      color: theme.colorScheme.onSurface.withAlpha(153),
      fontSize: AppTypography.bodySmall(r),
    );
    final titleStyle = (theme.textTheme.headlineSmall ?? const TextStyle()).copyWith(
      fontWeight: FontWeight.bold,
      fontSize: AppTypography.heading(r),
    );
    final excerptStyle = (theme.textTheme.bodyMedium ?? const TextStyle()).copyWith(
      fontSize: AppTypography.bodyMedium(r),
      color: theme.colorScheme.onSurface.withAlpha(179),
    );
    final readMoreStyle = TextStyle(
      color: theme.colorScheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: AppTypography.bodyMedium(r),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing24),
      child: InkWell(
        onTap: () async {
          if (post.link.isNotEmpty) {
            final url = Uri.parse(post.link);
            if (await canLaunchUrl(url)) launchUrl(url);
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Flex(
            direction: isNarrow ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BlogImage(imageUrl: post.imageUrl, isNarrow: isNarrow),
              SizedBox(width: isNarrow ? 0 : AppTheme.spacing16, height: isNarrow ? AppTheme.spacing16 : 0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.calendar_today, size: 14, color: theme.colorScheme.onSurface.withAlpha(153)),
                      const SizedBox(width: AppTheme.spacing4),
                      Text(formattedDate, style: dateStyle),
                      const SizedBox(width: AppTheme.spacing16),
                      Icon(Icons.person, size: 14, color: theme.colorScheme.onSurface.withAlpha(153)),
                      const SizedBox(width: AppTheme.spacing4),
                      Text(post.author, style: dateStyle),
                    ]),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(post.title, style: titleStyle, maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppTheme.spacing8),
                    Text(post.excerpt, style: excerptStyle, maxLines: 3, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: AppTheme.spacing16),
                    TextButton.icon(
                      onPressed: () async {
                        if (post.link.isNotEmpty) {
                          final url = Uri.parse(post.link);
                          if (await canLaunchUrl(url)) launchUrl(url);
                        }
                      },
                      icon: Icon(Icons.arrow_forward, color: theme.colorScheme.primary),
                      label: Text('Read More', style: readMoreStyle),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 400.ms, delay: Duration(milliseconds: 80 * index))
        .slideY(begin: 0.05, end: 0);
  }
}

class _BlogImage extends StatelessWidget {
  final String imageUrl;
  final bool isNarrow;
  const _BlogImage({required this.imageUrl, required this.isNarrow});

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    if (imageUrl.isEmpty) {
      return Container(
        width: isNarrow ? double.infinity : 200,
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
          color: primary.withAlpha(26),
        ),
        child: Center(child: Icon(Icons.article, size: 40, color: primary)),
      );
    }
    return ResponsiveImage(
      imageUrl: imageUrl,
      width: isNarrow ? double.infinity : 200,
      height: 120,
      aspectRatio: isNarrow ? null : 16 / 9,
      enableHoverEffect: false,
      borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
      backgroundColor: primary.withAlpha(26),
      fit: BoxFit.cover,
      placeholder: 'Loading image',
    );
  }
}
