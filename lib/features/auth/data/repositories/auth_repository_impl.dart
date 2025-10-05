import 'package:lotus_news_web/features/auth/data/data_source/remote_data_source/auth_remote_data_source.dart';
import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';
import 'package:lotus_news_web/features/auth/domain/repositories/auth_repository.dart';
import '../data_source/local_data_source/auth_local_data_source.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl(this._remoteDataSource, this._localDataSource);

  @override
  Future<AuthUser> login(String email, String password) async {
    final authUser = await _remoteDataSource.login(email, password);
    _localDataSource.saveAuthToken(authUser);
    return authUser;
  }

  @override
  Future<void> logout() {
    throw UnimplementedError();
  }

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
    // TODO: implement getAccessToken
    throw UnimplementedError();
  }

  @override
  Future<AuthUser?> getAuthUser() {
    // TODO: implement getAuthUser
    throw UnimplementedError();
  }

  @override
  Future<String?> getAuthorizationHeader() {
    // TODO: implement getAuthorizationHeader
    throw UnimplementedError();
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
    // TODO: implement saveAuthToken
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(User user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
