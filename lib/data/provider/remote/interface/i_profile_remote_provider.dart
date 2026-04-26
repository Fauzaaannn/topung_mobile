import 'package:topung_mobile/data/model/profile_model/profile_model.dart';

abstract class IProfileRemoteProvider {
  Future<ProfileModel> getMe();
}
