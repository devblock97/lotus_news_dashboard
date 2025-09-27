import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

abstract class PostState { }

class PostLoading extends PostState { }

class PostLoaded extends PostState {
  final List<Post> posts;

  PostLoaded(this.posts);

  PostLoaded copyWith({List<Post>? posts}) {
    return PostLoaded(posts ?? this.posts);
  }
}

class PostError extends PostState {

  final String message;

  PostError({required this.message});
}