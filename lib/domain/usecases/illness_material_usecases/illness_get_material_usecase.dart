import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';
import 'package:topung_mobile/domain/repositories/illness_material_repository.dart';

class IllnessGetMaterialUsecase {
  IllnessGetMaterialUsecase(this._repository);

  final IllnessMaterialRepository _repository;

  Future<Either<String, IllnessMaterialModel>> call(String id) {
    return _repository.getMaterialById(id);
  }
}
