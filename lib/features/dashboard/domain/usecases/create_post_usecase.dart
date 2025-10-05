import 'package:lotus_news_web/features/dashboard/data/models/create_post.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';

class CreatePostUseCase {
  final PostRepository _repository;
  CreatePostUseCase(this._repository);

  Future<Post> call(CreatePost post) async =>
      await _repository.createPost(post);
}
