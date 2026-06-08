import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/auth_model/login_response_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_auth_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remoteProvider);

  final IAuthRemoteProvider _remoteProvider;

  @override
  Future<Either<String, LoginResponseModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _remoteProvider.login(
        email: email,
        password: password,
      );
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] as String? ??
          e.message ??
          'Terjadi kesalahan';
      return Left(message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }

  @override
  Future<Either<String, void>> register({
    required String username,
    required String email,
    required String password,
    required int usia,
    required String jenisKelamin,
  }) async {
    try {
      await _remoteProvider.register(
        username: username,
        email: email,
        password: password,
        usia: usia,
        jenisKelamin: jenisKelamin,
      );
      return const Right(null);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] as String? ??
          e.message ??
          'Terjadi kesalahan';
      return Left(message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }
}
