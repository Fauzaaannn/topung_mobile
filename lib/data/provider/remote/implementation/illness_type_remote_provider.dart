import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/illness_model/illness_type_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_type_remote_provider.dart';

class IllnessTypeRemoteProvider implements IIllnessTypeRemoteProvider {
  IllnessTypeRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<IllnessTypePaginationModel> getMaterialsPagination({
    required String categoryId,
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    final response = await _dio.post(
      EndpointConstant.materialsPagination,
      data: {
        'data': {
          'filter': [
            {'field': 'category_id', 'operator': 'eq', 'value': categoryId},
          ],
          'sort': [
            {'field': 'created_at', 'direction': 'desc'},
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
    return IllnessTypePaginationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
