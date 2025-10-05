import 'package:lotus_news_web/features/auth/data/data_source/local_data_source/auth_local_data_source.dart';
import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';
import 'package:lotus_news_web/features/auth/domain/repositories/token_storage_repository.dart';

class TokenStorageRepositoryImpl implements TokenStorageRepository {
  final AuthLocalDataSource _localDataSource;

  TokenStorageRepositoryImpl(this._localDataSource);

  @override
  Future<void> clearTokens() {
    // TODO: implement clearTokens
    throw UnimplementedError();
  }

  @override
  Future<void> clearUser() {
    // TODO: implement clearUser
    throw UnimplementedError();
  }

  @override
  Future<String?> getAccessToken() {
    return _localDataSource.getAccessToken();
  }

  @override
  Future<AuthUser?> getAuthUser() {
    // TODO: implement getAuthUser
    throw UnimplementedError();
  }

  @override
  Future<String?> getAuthorizationHeader() async {
    final token = await getAccessToken();
    if (token != null && token.isNotEmpty) {
      return 'Bearer $token';
    }
    return null;
  }

  @override
  Future<String?> getRefreshToken() {
    // TODO: implement getRefreshToken
    throw UnimplementedError();
  }

  @override
  Future<bool> hasValidToken() {
    // TODO: implement hasValidToken
    throw UnimplementedError();
  }

  @override
  Future<bool> isTokenExpired() {
    // TODO: implement isTokenExpired
    throw UnimplementedError();
  }

  @override
  Future<void> saveAuthToken(AuthUser auth) {
    return _localDataSource.saveAuthToken(auth);
  }

  @override
  Future<void> saveUser(User user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
