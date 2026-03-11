import 'package:topung_mobile/data/model/auth_model/login_response_model.dart';

abstract class IAuthRemoteProvider {
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  });

  Future<void> register({
    required String name,
    required String email,
    required String password,
  });
}
