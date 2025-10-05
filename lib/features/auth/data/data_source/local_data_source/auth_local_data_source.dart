import 'dart:convert';

import 'package:lotus_news_web/core/utils/app_logger.dart';
import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
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

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  static const String _accessTokenKey = 'access_token';
  static const String _authTokenKey = 'authToken';

  @override
  Future<void> clearTokens() {
    throw UnimplementedError();
  }

  @override
  Future<void> clearUser() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_accessTokenKey);
    } catch (e) {
      throw Exception('Failed to get access token: ${e.toString()}');
    }
  }

  @override
  Future<AuthUser?> getAuthUser() {
    throw UnimplementedError();
  }

  @override
  Future<String?> getAuthorizationHeader() {
    throw UnimplementedError();
  }

  @override
  Future<String> getRefreshToken() {
    throw UnimplementedError();
  }

  @override
  Future<bool> hasValidToken() {
    throw UnimplementedError();
  }

  @override
  Future<bool> isTokenExpired() {
    throw UnimplementedError();
  }

  @override
  Future<void> saveAuthToken(AuthUser auth) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.setString(_authTokenKey, jsonEncode(auth.toJson()));
      await prefs.setString(_accessTokenKey, auth.token);

      logger.i('AuthLocalDataSource [saveAuthToken]: Token saved successfully');
    } catch (e) {
      throw Exception('Failed to save authentication token');
    }
  }

  @override
  Future<void> saveUser(User user) {
    throw UnimplementedError();
  }
}
