import 'package:lotus_news_web/features/dashboard/data/data_source/remote_data_source/post_remote_data_source.dart';
import 'package:lotus_news_web/features/dashboard/data/models/create_post.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource _remoteDataSource;

  PostRepositoryImpl(this._remoteDataSource);

  @override
  Future<Post> createPost(CreatePost post) {
    return _remoteDataSource.createPost(post);
  }

  @override
  Future<void> deletePost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() {
    return _remoteDataSource.getPosts();
  }

  @override
  Future<Post> updatePost(Post post) {
    return _remoteDataSource.updatePost(post);
  }
}
