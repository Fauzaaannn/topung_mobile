import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/profile_model/profile_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_profile_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  ProfileRepositoryImpl(this._remoteProvider);

  final IProfileRemoteProvider _remoteProvider;

  @override
  Future<Either<String, ProfileModel>> getMe() async {
    try {
      final result = await _remoteProvider.getMe();
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
}
