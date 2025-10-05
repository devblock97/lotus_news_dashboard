import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';
import 'package:lotus_news_web/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final AuthRepository _repository;
  LoginUseCase(this._repository);

  Future<AuthUser> call(String email, String password) async =>
      await _repository.login(email, password);
}
