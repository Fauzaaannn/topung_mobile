import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/illness_model/illness_type_model.dart';
import 'package:topung_mobile/domain/repositories/illness_type_repository.dart';

class IllnessTypeUsecase {
  IllnessTypeUsecase(this._repository);

  final IllnessTypeRepository _repository;

  Future<Either<String, IllnessTypePaginationModel>> call({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) {
    return _repository.getMaterialsPagination(
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }
}
