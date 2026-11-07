import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/blog_post_model.dart';
import '../../data/services/medium_service.dart';

/// Latest posts. Empty list means "hide the section".
class BlogCubit extends Cubit<List<BlogPostModel>> {
  BlogCubit({MediumService? service})
      : _service = service ?? MediumService(),
        super(const []);

  final MediumService _service;

  Future<void> load() async {
    final posts = await _service.fetchBlogPosts();
    if (!isClosed) emit(posts.take(3).toList());
  }
}
