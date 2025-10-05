import 'package:lotus_news_web/core/constants/endpoint.dart';
import 'package:lotus_news_web/core/network/client_network.dart';
import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';

abstract class AuthRemoteDataSource {
  Future<AuthUser> login(String email, String password) =>
      throw UnimplementedError('Stub');

  Future<void> logout() => throw UnimplementedError('Stub');
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ClientNetwork _client;

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AuthUser> login(String email, String password) async {
    try {
      final body = {'email': email, 'password': password};
      final response = await _client.post(AppConstants.login, data: body);
      if (response.statusCode != 200) {
        throw Exception('Something went wrong');
      }

      final authUser = AuthUser.fromJson(response.data);
      return authUser;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }
}
