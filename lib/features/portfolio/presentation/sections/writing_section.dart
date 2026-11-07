import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design/tokens.dart';
import '../../../../core/motion/pressable.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/utils/launch.dart';
import '../../../../core/widgets/ui.dart';
import '../../data/models/blog_post_model.dart';
import '../bloc/blog_cubit.dart';

/// Hidden entirely when the Medium feed returns nothing.
class WritingSection extends StatelessWidget {
  const WritingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BlogCubit, List<BlogPostModel>>(
      builder: (context, posts) {
        if (posts.isEmpty) return const SizedBox.shrink();
        return SectionShell(
          title: 'Writing',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [for (final p in posts) _Post(post: p)],
          ),
        );
      },
    );
  }
}

class _Post extends StatelessWidget {
  const _Post({required this.post});
  final BlogPostModel post;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final date =
        post.publishDate.length >= 10 ? post.publishDate.substring(0, 10) : '';
    return Reveal(
      kind: RevealKind.fade,
      child: Pressable(
        onTap: () => openUrl(post.link),
        semanticLabel: post.title,
        pressScale: 1,
        builder: (context, s) => AnimatedContainer(
          duration: Motion.scaled(context, Motion.hover),
          padding: const EdgeInsets.symmetric(
              vertical: Space.l, horizontal: Space.s),
          decoration: BoxDecoration(
            color: s.active ? c.surface : Colors.transparent,
            border: Border(bottom: BorderSide(color: c.line)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(post.title,
                  style: AppType.h3(context)
                      .copyWith(color: s.active ? c.signal : c.ink)),
              if (date.isNotEmpty) Text(date, style: AppType.caption(context)),
              if (post.excerpt.isNotEmpty) ...[
                const SizedBox(height: Space.s),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: Widths.reading),
                  child: Text(post.excerpt, style: AppType.body(context)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
