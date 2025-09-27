import 'package:lotus_news_web/features/dashboard/data/models/post.dart';

abstract class PostEvent {}

class LoadPostEvent extends PostEvent {}

class UpdatePostEvent extends PostEvent {
  final Post post;
  UpdatePostEvent(this.post);
}

class DeletePostEvent extends PostEvent {
  final String id;
  DeletePostEvent({required this.id});
}
