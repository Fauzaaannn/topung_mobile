part of 'auth_bloc.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class LoginSuccess extends AuthState {
  LoginSuccess({required this.role});

  final String role;
}

class LogoutSuccess extends AuthState {}

class AuthFailure extends AuthState {
  AuthFailure({required this.message});

  final String message;
}