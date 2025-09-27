import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';

class GetPostUseCase {
  final PostRepository repository;
  GetPostUseCase(this.repository);

  Future<List<Post>> call() async => await repository.getPosts();
}