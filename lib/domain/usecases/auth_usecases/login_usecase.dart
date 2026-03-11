import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/auth_model/login_response_model.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';

class LoginUsecase {
  LoginUsecase(this._repository);

  final AuthRepository _repository;

  Future<Either<String, LoginResponseModel>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
