import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_illness_material_remote_provider.dart';

class IllnessMaterialRemoteProvider implements IIllnessMaterialRemoteProvider {
  IllnessMaterialRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<IllnessMaterialModel> getMaterialById(String id) async {
    final response = await _dio.get(EndpointConstant.materialById(id));
    return IllnessMaterialModel.fromJson(response.data as Map<String, dynamic>);
  }
}
