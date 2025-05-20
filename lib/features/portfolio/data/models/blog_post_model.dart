import 'package:equatable/equatable.dart';

class BlogPostModel extends Equatable {
  final String title;
  final String excerpt;
  final String link;
  final String publishDate;
  final String imageUrl;
  final String author;
  
  const BlogPostModel({
    required this.title,
    required this.excerpt,
    required this.link,
    required this.publishDate,
    required this.imageUrl,
    required this.author,
  });
  
  @override
  List<Object> get props => [title, excerpt, link, publishDate, imageUrl, author];
}