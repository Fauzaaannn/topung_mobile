import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';

abstract class IllnessMaterialRepository {
  Future<Either<String, IllnessMaterialModel>> getMaterialById(String id);
}
