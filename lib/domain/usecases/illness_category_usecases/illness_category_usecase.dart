import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/illness_model/illness_category_model.dart';
import 'package:topung_mobile/domain/repositories/illness_category_repository.dart';

class IllnessCategoryUsecase {
  IllnessCategoryUsecase(this._repository);

  final IllnessCategoryRepository _repository;

  Future<Either<String, IllnessCategoryPaginationModel>> call({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) {
    return _repository.getCategoriesPagination(
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }
}
