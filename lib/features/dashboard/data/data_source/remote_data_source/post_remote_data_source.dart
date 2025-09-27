import 'package:dio/dio.dart';
import 'package:lotus_news_web/core/network/client_network.dart';
import 'package:lotus_news_web/core/utils/app_logger.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/domain/repositories/post_repository.dart';

class PostRemoteDataSource implements PostRepository {
  final ClientNetwork client;
  const PostRemoteDataSource({required this.client});

  @override
  Future<Post> createPost(Post post) {
    throw UnimplementedError();
  }

  @override
  Future<void> deletePost(Post post) async {
    throw UnimplementedError('Stub');
  }

  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await client.get('/posts');

      if (response.statusCode == 200) {
        final posts = (response.data['posts'] as List)
            .map((p) => Post.fromJson(p))
            .toList();
        return posts;
      } else {
        return [];
      }
    } on DioException catch (e, stackTrace) {
      logger.e('PostRemoteDataSource [getPost - DioException]: $stackTrace');
      throw Exception('dio exception: ${e.toString()}');
    } catch (e, stackTrace) {
      logger
          .e('PostRemoteDataSource [getPost - UnknownException]: $stackTrace');
      throw Exception('get post exception: ${e.toString()}');
    }
  }

  @override
  Future<Post> updatePost(Post post) async {
    try {
      final response =
          await client.put('/posts/${post.id}', data: post.toJson());
      if (response.statusCode == 200) {
        final data = Post.fromJson(response.data);
        return data;
      } else {
        throw Exception('Failed to update');
      }
    } catch (e) {
      throw Exception();
    }
  }
}
