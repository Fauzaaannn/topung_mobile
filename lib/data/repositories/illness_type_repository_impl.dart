import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/illness_model/illness_type_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_type_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/illness_type_repository.dart';

class IllnessTypeRepositoryImpl implements IllnessTypeRepository {
  IllnessTypeRepositoryImpl(this._remoteProvider);

  final IIllnessTypeRemoteProvider _remoteProvider;

  @override
  Future<Either<String, IllnessTypePaginationModel>> getMaterialsPagination({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    try {
      final result = await _remoteProvider.getMaterialsPagination(
        categoryId: categoryId,
        page: page,
        pageSize: pageSize,
        search: search,
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
}
