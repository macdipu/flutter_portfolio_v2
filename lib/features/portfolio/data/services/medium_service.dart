import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/blog_post_model.dart';

/// Fetches the latest Medium posts through rss2json.
///
/// Returns an empty list on any failure. The UI hides the section when empty,
/// so a failed request never shows invented content.
class MediumService {
  static const _api =
      'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@c.dipu0';

  Future<List<BlogPostModel>> fetchBlogPosts() async {
    try {
      final response =
          await http.get(Uri.parse(_api)).timeout(const Duration(seconds: 8));
      if (response.statusCode != 200) return const [];
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data['status'] != 'ok') return const [];
      final items = data['items'] as List;
      return items
          .map((dynamic raw) {
            final item = raw as Map<String, dynamic>;
            final description = (item['description'] as String?) ?? '';
            return BlogPostModel(
              title: (item['title'] as String?) ?? 'Untitled',
              excerpt: _excerpt(description),
              link: (item['link'] as String?) ?? '',
              publishDate: (item['pubDate'] as String?) ?? '',
              imageUrl: '',
              author: (item['author'] as String?) ?? '',
            );
          })
          .where((p) => p.link.isNotEmpty)
          .toList();
    } catch (_) {
      return const [];
    }
  }

  String _excerpt(String html, [int wordLimit = 32]) {
    final text = html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll(RegExp(r'&[a-z#0-9]+;'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    final words = text.split(' ');
    final cut = words.take(wordLimit).join(' ');
    return words.length > wordLimit ? '$cut...' : cut;
  }
}
