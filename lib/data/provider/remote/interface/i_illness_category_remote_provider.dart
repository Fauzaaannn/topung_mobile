import 'package:topung_mobile/data/model/illness_model/illness_category_model.dart';

abstract class IIllnessCategoryRemoteProvider {
  Future<IllnessCategoryPaginationModel> getCategoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
  });
}