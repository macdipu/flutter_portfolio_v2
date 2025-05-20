import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' as parser;

import '../models/blog_post_model.dart';

class MediumService {
  static const String _rssToJsonApi = 'https://api.rss2json.com/v1/api.json?rss_url=https://medium.com/feed/@c.dipu0';

  Future<List<BlogPostModel>> fetchBlogPosts() async {
    try {
      final response = await http.get(Uri.parse('$_rssToJsonApi'));

      if (response.statusCode != 200) {
        throw Exception('Failed to load blog posts: ${response.statusCode}');
      }

      final data = json.decode(response.body);
      if (data['status'] != 'ok') {
        throw Exception('API error: ${data['message']}');
      }

      final items = data['items'] as List;
      return items.map((item) {
        final document = parser.parse(item['description']);
        final excerpt = _generateExcerpt(document.body?.text ?? '');
        final imageUrl = _extractImageUrl(item['description']);

        return BlogPostModel(
          title: item['title'] ?? 'Untitled',
          excerpt: excerpt,
          link: item['link'] ?? '',
          publishDate: item['pubDate'] ?? '',
          imageUrl: imageUrl,
          author: item['author'] ?? 'Unknown',
        );
      }).toList();
    } catch (e) {
      return _getMockBlogPosts();
    }
  }

  String _generateExcerpt(String text, [int wordLimit = 50]) {
    final words = text.split(' ');
    final excerpt = words.take(wordLimit).join(' ');
    return words.length > wordLimit ? '$excerpt...' : excerpt;
  }

  String _extractImageUrl(String htmlContent) {
    final document = parser.parse(htmlContent);
    final imgElement = document.querySelector('img');
    return imgElement?.attributes['src'] ?? '';
  }

  List<BlogPostModel> _getMockBlogPosts() {
    return [
      BlogPostModel(
        title: 'Building Beautiful UIs with Flutter',
        excerpt: 'Flutter\'s widget system makes it easy to create beautiful, responsive UIs...',
        link: 'https://medium.com/@username/building-beautiful-uis-with-flutter',
        publishDate: '2023-10-15',
        imageUrl: 'https://images.pexels.com/photos/4383918/pexels-photo-4383918.jpeg',
        author: 'Flutter Developer',
      ),
      BlogPostModel(
        title: 'State Management in Flutter: BLoC vs Provider',
        excerpt: 'Choosing the right state management solution is crucial for Flutter apps...',
        link: 'https://medium.com/@username/state-management-in-flutter',
        publishDate: '2023-09-20',
        imageUrl: 'https://images.pexels.com/photos/5935794/pexels-photo-5935794.jpeg',
        author: 'Flutter Developer',
      ),
      BlogPostModel(
        title: 'Flutter Web: Building Responsive Websites',
        excerpt: 'Flutter Web allows you to build responsive websites using the same codebase...',
        link: 'https://medium.com/@username/flutter-web-responsive-design',
        publishDate: '2023-08-05',
        imageUrl: 'https://images.pexels.com/photos/5584052/pexels-photo-5584052.jpeg',
        author: 'Flutter Developer',
      ),
    ];
  }
}
