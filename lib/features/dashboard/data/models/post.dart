import 'package:flutter/cupertino.dart';

class Post {
  final String authorUsername;
  final String avatar;
  final String body;
  final DateTime createdAt;
  final String id;
  final int score;
  final String shortDescription;
  final String title;
  final String url;
  final String userId;

  Post({
    required this.authorUsername,
    required this.avatar,
    required this.body,
    required this.createdAt,
    required this.id,
    required this.score,
    required this.shortDescription,
    required this.title,
    required this.url,
    required this.userId,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    try {
      return Post(
        authorUsername: json['author_username'] as String,
        avatar: json['avatar'] as String,
        body: json['body'] ?? '',
        // Parse the timestamp string into a DateTime object
        createdAt: DateTime.parse(json['created_at'] as String),
        id: json['id'] as String,
        score: json['score'] as int,
        shortDescription: json['short_description'] as String,
        title: json['title'] as String,
        url: json['url'] as String,
        userId: json['user_id'] as String,
      );
    } catch (e, stackTrace) {
      debugPrint('stack trace: from json: $stackTrace');
      throw Exception(e.toString());
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'author_username': authorUsername,
      'avatar': avatar,
      'body': body,
      'created_at': createdAt.toIso8601String(),
      'id': id,
      'score': score,
      'short_description': shortDescription,
      'title': title,
      'url': url,
      'user_id': userId,
    };
  }

  Post copyWith({
    String? authorUsername,
    String? avatar,
    String? body,
    DateTime? createdAt,
    String? id,
    int? score,
    String? shortDescription,
    String? title,
    String? url,
    String? userId,
  }) {
    return Post(
      authorUsername: authorUsername ?? this.authorUsername,
      avatar: avatar ?? this.avatar,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      id: id ?? this.id,
      score: score ?? this.score,
      shortDescription: shortDescription ?? this.shortDescription,
      title: title ?? this.title,
      url: url ?? this.url,
      userId: userId ?? this.userId,
    );
  }

  @override
  String toString() {
    return 'Post('
        'authorUsername: $authorUsername, '
        'title: $title, '
        'score: $score, '
        'createdAt: $createdAt)';
  }
}
