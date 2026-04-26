import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/profile_model/profile_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_profile_remote_provider.dart';

class ProfileRemoteProvider implements IProfileRemoteProvider {
  ProfileRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<ProfileModel> getMe() async {
    final response = await _dio.get(EndpointConstant.getMe);
    return ProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}
