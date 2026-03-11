import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/auth_model/login_response_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_auth_remote_provider.dart';

class AuthRemoteProvider implements IAuthRemoteProvider {
  AuthRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<LoginResponseModel> login({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post(
      EndpointConstant.login,
      data: {'email': email, 'password': password},
    );
    return LoginResponseModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    await _dio.post(
      EndpointConstant.register,
      data: {'name': name, 'email': email, 'password': password},
    );
  }
}
