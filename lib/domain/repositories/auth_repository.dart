import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/auth_model/login_response_model.dart';

abstract class AuthRepository {
  Future<Either<String, LoginResponseModel>> login({
    required String email,
    required String password,
  });

  Future<Either<String, void>> register({
    required String username,
    required String email,
    required String password,
    required int usia,
    required String jenisKelamin,
  });
}
