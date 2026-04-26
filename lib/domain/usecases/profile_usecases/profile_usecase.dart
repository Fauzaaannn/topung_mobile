import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/profile_model/profile_model.dart';
import 'package:topung_mobile/domain/repositories/profile_repository.dart';

class ProfileUsecase {
  ProfileUsecase(this._repository);

  final ProfileRepository _repository;

  Future<Either<String, ProfileModel>> call() {
    return _repository.getMe();
  }
}
