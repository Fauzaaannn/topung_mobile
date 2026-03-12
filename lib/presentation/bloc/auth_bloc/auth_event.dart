part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LoginSubmitted extends AuthEvent {
  LoginSubmitted({required this.email, required this.password});

  final String email;
  final String password;
}

class LogoutRequested extends AuthEvent {}