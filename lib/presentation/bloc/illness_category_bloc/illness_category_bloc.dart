import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/data/model/illness_model/illness_category_model.dart';
import 'package:topung_mobile/domain/usecases/illness_category_usecases/illness_category_usecase.dart';

part 'illness_category_event.dart';
part 'illness_category_state.dart';

class IllnessCategoryBloc
    extends Bloc<IllnessCategoryEvent, IllnessCategoryState> {
  IllnessCategoryBloc({required IllnessCategoryUsecase illnessCategoryUsecase})
    : _illnessCategoryUsecase = illnessCategoryUsecase,
      super(IllnessCategoryInitial()) {
    on<IllnessCategoryFetched>(_onIllnessCategoryFetched);
  }

  final IllnessCategoryUsecase _illnessCategoryUsecase;

  Future<void> _onIllnessCategoryFetched(
    IllnessCategoryFetched event,
    Emitter<IllnessCategoryState> emit,
  ) async {
    emit(IllnessCategoryLoading());

    final result = await _illnessCategoryUsecase(
      page: event.page,
      pageSize: event.pageSize,
      search: event.search,
    );

    result.fold(
      (failure) => emit(IllnessCategoryFailure(message: failure)),
      (data) => emit(IllnessCategorySuccess(data: data)),
    );
  }
}
