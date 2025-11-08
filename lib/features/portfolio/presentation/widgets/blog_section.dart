import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/responsive/responsive_framework.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common/section_wrapper.dart';
import '../../data/models/blog_post_model.dart';
import '../bloc/portfolio_bloc.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        return SectionWrapper(
          sectionId: 'blog',
          title: 'Blog',
          subtitle: 'My Latest Posts',
          addTopPadding: true,
          addBottomPadding: true,
          mobileChild: _buildLayout(context, state),
          tabletChild: _buildLayout(context, state),
          smallLaptopChild: _buildLayout(context, state),
          desktopChild: _buildLayout(context, state),
          largeDesktopChild: _buildLayout(context, state),
        );
      },
    );
  }

  Widget _buildLayout(BuildContext context, PortfolioState state) {
    final contentWidth = context.contentWidth;
    final maxPosts =
        state.visibleBlogPostCount.clamp(0, state.blogPosts.length);

    return Container(
      width: contentWidth,
      padding: context.defaultPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppTheme.spacing32),
          if (state.isLoading && state.blogPosts.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (state.blogPosts.isEmpty)
            _buildEmptyState(context)
          else ...[
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: maxPosts,
              itemBuilder: (context, index) {
                return _BlogPostCard(
                  post: state.blogPosts[index],
                  index: index,
                );
              },
            ),
            const SizedBox(height: AppTheme.spacing24),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final url = Uri.parse('https://medium.com/@c.dipu0');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: const Text(
                  'Show More on Medium',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    // Define responsive text styles
    final emptyTitleStyle = theme.textTheme.labelLarge?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 16.0,
            tablet: 18.0,
            smallLaptop: 20.0,
            desktop: 22.0,
            largeDesktop: 24.0,
          ),
        );

    final emptySubtitleStyle = theme.textTheme.bodyMedium?.copyWith(
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        ) ??
        TextStyle(
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: AppTheme.spacing16),
          SelectableText(
            'No blog posts available',
            style: emptyTitleStyle,
          ),
          const SizedBox(height: AppTheme.spacing8),
          SelectableText(
            'Check back later for new content',
            style: emptySubtitleStyle,
          ),
        ],
      ),
    );
  }
}

class _BlogPostCard extends StatelessWidget {
  final BlogPostModel post;
  final int index;

  const _BlogPostCard({
    required this.post,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Format date
    String formattedDate = '';
    try {
      final date = DateTime.tryParse(post.publishDate);
      if (date != null) {
        formattedDate = DateFormat.yMMMMd().format(date);
      } else {
        formattedDate = post.publishDate;
      }
    } catch (_) {
      formattedDate = post.publishDate;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spacing24),
      child: InkWell(
        onTap: () async {
          if (post.link.isNotEmpty) {
            final url = Uri.parse(post.link);
            if (await canLaunchUrl(url)) {
              await launchUrl(url);
            }
          }
        },
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacing16),
          child: Flex(
            direction: isSmallScreen ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Blog post image
              _buildBlogImage(isSmallScreen),
              SizedBox(
                width: isSmallScreen ? 0 : AppTheme.spacing16,
                height: isSmallScreen ? AppTheme.spacing16 : 0,
              ),
              // Blog post content
              Expanded(child: _buildBlogContent(context, formattedDate)),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fade(duration: 600.ms, delay: Duration(milliseconds: 200 * index))
        .slideY(begin: 0.1, end: 0);
  }

  Widget _buildBlogImage(bool isSmallScreen) {
    return Container(
      width: isSmallScreen ? double.infinity : 200,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
        color: AppTheme.primary.withOpacity(0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: post.imageUrl.isNotEmpty
          ? Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return const Center(
                  child: Icon(
                    Icons.article,
                    size: 40,
                    color: AppTheme.primary,
                  ),
                );
              },
            )
          : const Center(
              child: Icon(
                Icons.article,
                size: 40,
                color: AppTheme.primary,
              ),
            ),
    );
  }

  Widget _buildBlogContent(BuildContext context, String formattedDate) {
    final theme = Theme.of(context);
    // Fallback to Theme.of(context) if custom extensions are unavailable
    final textTheme = context.textStyles ?? theme.textTheme;

    // Define responsive text styles
    final dateAuthorStyle = textTheme.bodySmall?.copyWith(
          color: context.textColors.secondary,
          fontSize: context.responsiveValue(
            mobile: 12.0,
            tablet: 13.0,
            smallLaptop: 14.0,
            desktop: 15.0,
            largeDesktop: 16.0,
          ),
        ) ??
        TextStyle(
          color: context.textColors.secondary,
          fontSize: context.responsiveValue(
            mobile: 12.0,
            tablet: 13.0,
            smallLaptop: 14.0,
            desktop: 15.0,
            largeDesktop: 16.0,
          ),
        );

    final titleStyle = textTheme.headlineSmall?.copyWith(
          fontWeight: FontWeight.bold,
          color: context.textColors.secondary,
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
        ) ??
        TextStyle(
          fontWeight: FontWeight.bold,
          color: context.textColors.primary,
          fontSize: context.responsiveValue(
            mobile: 20.0,
            tablet: 22.0,
            smallLaptop: 24.0,
            desktop: 26.0,
            largeDesktop: 28.0,
          ),
        );

    final excerptStyle = textTheme.bodyMedium?.copyWith(
          color: context.textColors.secondary,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        ) ??
        TextStyle(
          color: context.textColors.secondary,
          fontSize: context.responsiveValue(
            mobile: 14.0,
            tablet: 15.0,
            smallLaptop: 16.0,
            desktop: 17.0,
            largeDesktop: 18.0,
          ),
        );

    final readMoreStyle = TextStyle(
      color: AppTheme.primary,
      fontWeight: FontWeight.bold,
      fontSize: context.responsiveValue(
        mobile: 14.0,
        tablet: 15.0,
        smallLaptop: 16.0,
        desktop: 17.0,
        largeDesktop: 18.0,
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and author
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: context.textColors.secondary,
            ),
            const SizedBox(width: AppTheme.spacing4),
            SelectableText(
              formattedDate,
              style: dateAuthorStyle,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Icon(
              Icons.person,
              size: 14,
              color: context.textColors.secondary,
            ),
            const SizedBox(width: AppTheme.spacing4),
            SelectableText(
              post.author,
              style: dateAuthorStyle,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        // Title
        SelectableText(
          post.title,
          style: titleStyle,
          maxLines: 2,
        ),
        const SizedBox(height: AppTheme.spacing8),
        // Excerpt
        SelectableText(
          post.excerpt,
          style: excerptStyle,
          maxLines: 3,
        ),
        const SizedBox(height: AppTheme.spacing16),
        // Read more link
        TextButton.icon(
          onPressed: () async {
            if (post.link.isNotEmpty) {
              final url = Uri.parse(post.link);
              if (await canLaunchUrl(url)) {
                await launchUrl(url);
              }
            }
          },
          icon: const Icon(
            Icons.arrow_forward,
            color: AppTheme.primary,
          ),
          label: Text(
            'Read More',
            style: readMoreStyle,
          ),
        ),
      ],
    );
  }
}
