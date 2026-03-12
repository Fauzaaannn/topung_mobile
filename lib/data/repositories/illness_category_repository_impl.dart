import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/illness_model/illness_category_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_category_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/illness_category_repository.dart';

class IllnessCategoryRepositoryImpl implements IllnessCategoryRepository {
  IllnessCategoryRepositoryImpl(this._remoteProvider);

  final IIllnessCategoryRemoteProvider _remoteProvider;

  @override
  Future<Either<String, IllnessCategoryPaginationModel>>
  getCategoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    try {
      final result = await _remoteProvider.getCategoriesPagination(
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
