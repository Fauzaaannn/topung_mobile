import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/data/model/illness_model/illness_type_model.dart';
import 'package:topung_mobile/domain/usecases/illness_type_usecases/illness_type_usecase.dart';

part 'illness_type_event.dart';
part 'illness_type_state.dart';

class IllnessTypeBloc extends Bloc<IllnessTypeEvent, IllnessTypeState> {
  IllnessTypeBloc({required IllnessTypeUsecase illnessTypeUsecase})
    : _illnessTypeUsecase = illnessTypeUsecase,
      super(IllnessTypeInitial()) {
    on<IllnessTypeFetched>(_onIllnessTypeFetched);
  }

  final IllnessTypeUsecase _illnessTypeUsecase;

  Future<void> _onIllnessTypeFetched(
    IllnessTypeFetched event,
    Emitter<IllnessTypeState> emit,
  ) async {
    emit(IllnessTypeLoading());

    final result = await _illnessTypeUsecase(
      categoryId: event.categoryId,
      page: event.page,
      pageSize: event.pageSize,
      search: event.search,
    );

    result.fold(
      (failure) => emit(IllnessTypeFailure(message: failure)),
      (data) => emit(IllnessTypeSuccess(data: data)),
    );
  }
}
