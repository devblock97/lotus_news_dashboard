import 'package:lotus_news_web/features/dashboard/data/models/create_post.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

abstract class PostEvent {}

class LoadPostEvent extends PostEvent {}

class UpdatePostEvent extends PostEvent {
  final Post post;
  UpdatePostEvent(this.post);
}

class CreatePostEvent extends PostEvent {
  final CreatePost post;
  CreatePostEvent({required this.post});
}

class DeletePostEvent extends PostEvent {
  final String id;
  DeletePostEvent({required this.id});
}
