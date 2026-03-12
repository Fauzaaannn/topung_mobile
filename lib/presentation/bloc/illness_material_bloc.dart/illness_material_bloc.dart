import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';
import 'package:topung_mobile/domain/usecases/illness_material_usecases/illness_get_material_usecase.dart';

part 'illness_material_event.dart';
part 'illness_material_state.dart';

class IllnessMaterialBloc
    extends Bloc<IllnessMaterialEvent, IllnessMaterialState> {
  IllnessMaterialBloc({
    required IllnessGetMaterialUsecase illnessGetMaterialUsecase,
  }) : _illnessGetMaterialUsecase = illnessGetMaterialUsecase,
       super(IllnessMaterialInitial()) {
    on<IllnessMaterialFetched>(_onIllnessMaterialFetched);
  }

  final IllnessGetMaterialUsecase _illnessGetMaterialUsecase;

  Future<void> _onIllnessMaterialFetched(
    IllnessMaterialFetched event,
    Emitter<IllnessMaterialState> emit,
  ) async {
    emit(IllnessMaterialLoading());

    final result = await _illnessGetMaterialUsecase(event.materialId);

    result.fold(
      (failure) => emit(IllnessMaterialFailure(message: failure)),
      (data) => emit(IllnessMaterialSuccess(data: data)),
    );
  }
}
