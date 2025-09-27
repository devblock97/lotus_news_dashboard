import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';

class UpdatePostUseCase {
  final PostRepository _repository;
  UpdatePostUseCase(this._repository);

  Future<void> call(Post post) async => await _repository.updatePost(post);
}