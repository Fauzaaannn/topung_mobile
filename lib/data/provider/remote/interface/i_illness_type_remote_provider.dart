import 'package:topung_mobile/data/model/illness_model/illness_type_model.dart';

abstract class IIllnessTypeRemoteProvider {
  Future<IllnessTypePaginationModel> getMaterialsPagination({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
    String search = '',
  });
}
