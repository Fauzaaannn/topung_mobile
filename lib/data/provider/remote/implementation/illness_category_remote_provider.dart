import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/illness_model/illness_category_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_category_remote_provider.dart';

class IllnessCategoryRemoteProvider implements IIllnessCategoryRemoteProvider {
  IllnessCategoryRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<IllnessCategoryPaginationModel> getCategoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    final response = await _dio.post(
      EndpointConstant.categoriesPagination,
      data: {
        'data': {
          'filter': [],
          'sort': [
            {'field': 'name', 'direction': 'asc'},
          ],
          'search': search,
          'expression': '',
          'pagination': {'page': page, 'pageSize': pageSize},
        },
        'options': {
          'showError': true,
          'rollbackOnFailure': true,
          'showInfo': true,
        },
      },
    );
    return IllnessCategoryPaginationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
