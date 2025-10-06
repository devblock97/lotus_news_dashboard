import 'package:lotus_news_web/features/dashboard/data/models/create_post.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();
  Future<Post> createPost(CreatePost post);
  Future<Post> updatePost(Post post);
  Future<void> deletePost(String id);
}
