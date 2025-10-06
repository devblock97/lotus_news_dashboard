import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';

class DeletePostUseCase {
  final PostRepository _repository;
  DeletePostUseCase(this._repository);

  Future<void> call(String id) async => _repository.deletePost(id);
}
