
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

abstract class PostRepository {
  Future<List<Post>> getPosts();

  Future<Post> createPost(Post post);

  Future<void> updatePost(Post post);

  Future<void> deletePost(Post post);
}