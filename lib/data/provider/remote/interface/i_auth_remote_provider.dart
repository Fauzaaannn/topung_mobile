import 'package:topung_mobile/data/model/auth_model/login_response_model.dart';

abstract class IAuthRemoteProvider {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required int usia,
    required String jenisKelamin,
  });
}
