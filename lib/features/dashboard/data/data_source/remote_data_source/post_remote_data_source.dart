import 'package:dio/dio.dart';
import 'package:lotus_news_web/core/network/client_network.dart';
import 'package:lotus_news_web/core/utils/app_logger.dart';
import 'package:lotus_news_web/features/dashboard/data/models/create_post.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

abstract class PostRemoteDataSource {
  Future<List<Post>> getPosts();
  Future<Post> createPost(CreatePost post);
  Future<Post> updatePost(Post post);
  Future<void> deletePost(Post post);
}

class PostRemoteDataSourceImpl implements PostRemoteDataSource {
  final ClientNetwork _client;
  const PostRemoteDataSourceImpl(this._client);

  @override
  Future<Post> createPost(CreatePost post) async {
    try {
      final response = await _client.post('/posts', data: post);
      logger.e(
        'PostRemoteDataSource [createPost - statusCode]: ${response.statusCode}',
      );
      logger.e(
        'PostRemoteDataSource [createPost - response]: ${response.data}',
      );
      if (response.statusCode! >= 200 && response.statusCode! <= 299) {
        final data = Post.fromJson(response.data);
        return data;
      }
      throw Exception('Can\'t create post. Please try again');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> deletePost(Post post) async {
    throw UnimplementedError('Stub');
  }

  @override
  Future<List<Post>> getPosts() async {
    try {
      final response = await _client.get('/posts');

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
      logger.e(
        'PostRemoteDataSource [getPost - UnknownException]: $stackTrace',
      );
      throw Exception('get post exception: ${e.toString()}');
    }
  }

  @override
  Future<Post> updatePost(Post post) async {
    try {
      final response = await _client.put(
        '/posts/${post.id}',
        data: post.toJson(),
      );
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
