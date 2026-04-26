import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/data/model/profile_model/profile_model.dart';
import 'package:topung_mobile/domain/usecases/profile_usecases/profile_usecase.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit({required ProfileUsecase profileUsecase})
    : _profileUsecase = profileUsecase,
      super(ProfileInitial());

  final ProfileUsecase _profileUsecase;

  Future<void> getMe() async {
    emit(ProfileLoading());
    final result = await _profileUsecase();
    result.fold(
      (failure) => emit(ProfileError(failure)),
      (profile) => emit(ProfileLoaded(profile)),
    );
  }
}
