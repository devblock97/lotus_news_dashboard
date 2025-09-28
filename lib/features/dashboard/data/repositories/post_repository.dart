import 'package:lotus_news_web/features/dashboard/data/data_source/remote_data_source/post_remote_data_source.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

import '../../domain/repositories/post_repository.dart';

class PostRepositoryImpl implements PostRepository {
  final PostRemoteDataSource remoteDataSource;
  PostRepositoryImpl(this.remoteDataSource);

  @override
  Future<Post> createPost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<List<Post>> getPosts() async {
    return remoteDataSource.getPosts();
  }

  @override
  Future<Post> updatePost(Post post) async {
    return remoteDataSource.updatePost(post);
  }
}
