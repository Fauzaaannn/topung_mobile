import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/profile_model/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<String, ProfileModel>> getMe();
}
