import 'package:flutter/material.dart';
import 'package:lotus_news_web/features/dashboard/data/models/post.dart';
import 'package:lotus_news_web/features/dashboard/domain/usecases/get_post_usecase.dart';
import 'package:lotus_news_web/features/dashboard/domain/usecases/update_post_usecase.dart';
import 'package:lotus_news_web/features/dashboard/presentation/lotus_flow/post_event.dart';
import 'package:lotus_news_web/features/dashboard/presentation/lotus_flow/post_state.dart';
import 'package:rxdart/rxdart.dart';

class PostLotusFlow {
  final GetPostUseCase getPostUseCase;
  final UpdatePostUseCase updatePostUseCase;

  // Use BehaviorSubject for state so new subscribers get the latest state immediately
  final _stateController = BehaviorSubject<PostState>.seeded(PostLoading());
  Stream<PostState> get state => _stateController.stream;

  // Use PublishSubject for events (Intents)
  final _eventController = PublishSubject<PostEvent>();
  Sink<PostEvent> get eventSink => _eventController.sink;

  // Internal stream for post list (managed by LotusFlow)
  final _posts = BehaviorSubject<List<Post>>.seeded([]);
  Stream<List<Post>> get _postsStream => _posts.stream;

  PostLotusFlow({
    required this.getPostUseCase,
    required this.updatePostUseCase,
  }) {
    _eventController.listen(_mapEventToState);
  }

  void _mapEventToState(PostEvent event) async {
    if (event is LoadPostEvent) {
      await _loadPosts();
    } else if (event is UpdatePostEvent) {
      await _updatePost(event.post);
    }
  }

  Future<void> _loadPosts() async {
    _stateController.add(PostLoading());
    try {
      final posts = await getPostUseCase();
      _posts.add(posts); // Update internal product stream
      _stateController.add(PostLoaded(posts)); // Emit loaded state
    } catch (e, stackTrace) {
      debugPrint('stack trace error: ${stackTrace.toString()}');
      _stateController.add(PostError(message: 'Failed to post post: $e'));
    }
  }

  Future<void> _updatePost(Post post) async {
    try {
      await updatePostUseCase(post);
      final postUpdated = _posts.value.map((p) => p.id == post.id ? post : p).toList();
      _posts.add(postUpdated);
    } catch (e) {
      _stateController.add(PostError(message: 'Failed to update post: $e '));
    }
  }

  void dispose() {
    _stateController.close();
    _eventController.close();
    _posts.close();
  }

}