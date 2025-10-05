class AuthUser {
  final String token;
  final User user;

  const AuthUser({required this.token, required this.user});

  factory AuthUser.fromJson(Map<String, dynamic> json) {
    return AuthUser(token: json['token'], user: User.fromJson(json['user']));
  }

  Map<String, dynamic> toJson() => {'token': token, 'user': user.toJson()};
}

class User {
  final String id;
  final String? avatar;
  final String? createdAt;
  final String email;
  final String username;

  const User({
    required this.id,
    required this.email,
    required this.username,
    this.avatar,
    this.createdAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      username: json['username'],
      avatar: json['avatar'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'email': email,
    'username': username,
    'avatar': avatar,
    'created_at': createdAt,
  };
}
