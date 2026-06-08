import 'package:dartz/dartz.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';

class RegisterUsecase {
  RegisterUsecase(this._repository);

  final AuthRepository _repository;

  Future<Either<String, void>> call({
    required String username,
    required String email,
    required String password,
    required int usia,
    required String jenisKelamin,
  }) async {
    return _repository.register(
      username: username,
      email: email,
      password: password,
      usia: usia,
      jenisKelamin: jenisKelamin,
    );
  }
}
