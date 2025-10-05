import 'package:lotus_news_web/features/auth/data/models/auth_user.dart';

abstract class AuthState {}

class AuthInitialize extends AuthState {}

class Authenticated extends AuthState {}

class LoginSuccess extends AuthState {
  final AuthUser data;
  LoginSuccess({required this.data});
}

class LoginLoading extends AuthState {}

class LoginError extends AuthState {
  final String? code;
  final String? message;

  LoginError({this.code, this.message});
}
