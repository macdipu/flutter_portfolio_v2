import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_theme.dart';
import '../bloc/portfolio_bloc.dart';
import 'section_header.dart';

class BlogSection extends StatelessWidget {
  const BlogSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    final theme = Theme.of(context);
    
    return BlocBuilder<PortfolioBloc, PortfolioState>(
      builder: (context, state) {
        return Container(
          padding: EdgeInsets.only(
            left: AppTheme.spacing24,
            right: AppTheme.spacing24,
            top: AppTheme.spacing64,
            bottom: AppTheme.spacing64,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Blog',
                subtitle: 'My Latest Posts',
              ),
              const SizedBox(height: AppTheme.spacing32),
              
              if (state.isLoading && state.blogPosts.isEmpty)
                const Center(child: CircularProgressIndicator())
              else if (state.blogPosts.isEmpty)
                _buildEmptyState(theme)
              else
                // Blog posts vertical list
                SizedBox(
                  height: 600, // Adjust based on content
                  child: ListView.builder(
                    itemCount: state.blogPosts.length,
                    itemBuilder: (context, index) {
                      return _BlogPostCard(
                        post: state.blogPosts[index],
                        index: index,
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
  
  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.article_outlined,
            size: 64,
            color: theme.colorScheme.primary.withOpacity(0.5),
          ),
          const SizedBox(height: AppTheme.spacing16),
          Text(
            'No blog posts available',
            style: theme.textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.spacing8),
          Text(
            'Check back later for new content',
            style: theme.textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}

class _BlogPostCard extends StatelessWidget {
  final dynamic post;
  final int index;
  
  const _BlogPostCard({
    required this.post,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;
    final isDesktop = screenSize.width >= 1024;
    
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
      elevation: 3,
      margin: const EdgeInsets.only(bottom: AppTheme.spacing24),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius16),
      ),
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
          child: isDesktop
              ? _buildDesktopLayout(context, theme, formattedDate)
              : _buildMobileLayout(context, theme, formattedDate),
        ),
      ),
    ).animate().fade(duration: 600.ms, delay: Duration(milliseconds: 200 * index)).slideY(begin: 0.1, end: 0);
  }
  
  Widget _buildDesktopLayout(BuildContext context, ThemeData theme, String formattedDate) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Blog post image
        _buildBlogImage(theme),
        const SizedBox(width: AppTheme.spacing16),
        
        // Blog post content
        Expanded(
          child: _buildBlogContent(theme, formattedDate),
        ),
      ],
    );
  }
  
  Widget _buildMobileLayout(BuildContext context, ThemeData theme, String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Blog post image
        _buildBlogImage(theme),
        const SizedBox(height: AppTheme.spacing16),
        
        // Blog post content
        _buildBlogContent(theme, formattedDate),
      ],
    );
  }
  
  Widget _buildBlogImage(ThemeData theme) {
    return Container(
      width: 200,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppTheme.borderRadius8),
        color: theme.colorScheme.primary.withOpacity(0.1),
      ),
      clipBehavior: Clip.antiAlias,
      child: post.imageUrl.isNotEmpty
          ? Image.network(
              post.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Center(
                  child: Icon(
                    Icons.article,
                    size: 40,
                    color: theme.colorScheme.primary,
                  ),
                );
              },
            )
          : Center(
              child: Icon(
                Icons.article,
                size: 40,
                color: theme.colorScheme.primary,
              ),
            ),
    );
  }
  
  Widget _buildBlogContent(ThemeData theme, String formattedDate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date and author
        Row(
          children: [
            Icon(
              Icons.calendar_today,
              size: 14,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(width: AppTheme.spacing4),
            Text(
              formattedDate,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(width: AppTheme.spacing16),
            Icon(
              Icons.person,
              size: 14,
              color: theme.textTheme.bodySmall?.color,
            ),
            const SizedBox(width: AppTheme.spacing4),
            Text(
              post.author,
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacing8),
        
        // Title
        Text(
          post.title,
          style: theme.textTheme.titleLarge,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppTheme.spacing8),
        
        // Excerpt
        Text(
          post.excerpt,
          style: theme.textTheme.bodyMedium,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: AppTheme.spacing16),
        
        // Read more link
        Row(
          children: [
            TextButton.icon(
              onPressed: () async {
                if (post.link.isNotEmpty) {
                  final url = Uri.parse(post.link);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                }
              },
              icon: Icon(
                Icons.arrow_forward,
                color: theme.colorScheme.primary,
              ),
              label: Text(
                'Read More',
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}