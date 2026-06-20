import 'package:topung_mobile/core/utils/dio_exception_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_material_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/illness_material_repository.dart';

class IllnessMaterialRepositoryImpl implements IllnessMaterialRepository {
  IllnessMaterialRepositoryImpl(this._remoteProvider);

  final IIllnessMaterialRemoteProvider _remoteProvider;

  @override
  Future<Either<String, IllnessMaterialModel>> getMaterialById(
    String id,
  ) async {
    try {
      final result = await _remoteProvider.getMaterialById(id);
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] as String? ??
          e.indonesianMessage ??
          'Terjadi kesalahan';
      return Left(message);
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }
}
