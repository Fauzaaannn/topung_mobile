import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';

abstract class IIllnessMaterialRemoteProvider {
  Future<IllnessMaterialModel> getMaterialById(String id);
}
