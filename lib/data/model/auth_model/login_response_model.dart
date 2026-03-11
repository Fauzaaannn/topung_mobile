import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/auth_model/user_model.dart';

class LoginResponseModel extends Equatable {
  const LoginResponseModel({required this.accessToken, required this.user});

  final String accessToken;
  final UserModel user;

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return LoginResponseModel(
      accessToken: data['accessToken'] as String,
      user: UserModel.fromJson(data['user'] as Map<String, dynamic>),
    );
  }

  @override
  List<Object?> get props => [accessToken, user];
}
