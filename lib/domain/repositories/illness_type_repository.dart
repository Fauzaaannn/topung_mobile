import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/illness_model/illness_type_model.dart';

abstract class IllnessTypeRepository {
  Future<Either<String, IllnessTypePaginationModel>> getMaterialsPagination({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
    String search = '',
  });
}
