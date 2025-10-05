import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';

abstract class AuthRepository {
  Future<AuthUser> login(String email, String password) =>
      throw UnimplementedError('Stub');

  Future<void> logout() => throw UnimplementedError('Stub');

  Future<void> saveAuthToken(AuthUser auth) => throw UnimplementedError('Stub');

  Future<String?> getAccessToken() => throw UnimplementedError('Stub');

  Future<String?> getRefreshToken() => throw UnimplementedError('Stub');

  Future<AuthUser?> getAuthUser() => throw UnimplementedError('Stub');

  Future<bool> isTokenExpired() => throw UnimplementedError('Stub');

  Future<bool> hasValidToken() => throw UnimplementedError('Stub');

  Future<void> clearTokens() => throw UnimplementedError('Stub');

  Future<String?> getAuthorizationHeader() => throw UnimplementedError('Stub');

  Future<void> saveUser(User user) => throw UnimplementedError('Stub');

  Future<void> clearUser() => throw UnimplementedError('Stub');
}
