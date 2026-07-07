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
    if (state is IllnessTypeSuccess) {
      final currentState = state as IllnessTypeSuccess;
      if (currentState.hasReachedMax && event.page != 1) return;
      
      if (event.page == 1) {
        emit(IllnessTypeLoading());
      } else {
        if (currentState.isFetchingMore) return;
        emit(currentState.copyWith(isFetchingMore: true));
      }
    } else {
      emit(IllnessTypeLoading());
    }

    final result = await _illnessTypeUsecase(
      categoryId: event.categoryId,
      page: event.page,
      pageSize: event.pageSize,
      search: event.search,
    );

    result.fold(
      (failure) {
        if (state is IllnessTypeSuccess) {
           final currentState = state as IllnessTypeSuccess;
           emit(currentState.copyWith(isFetchingMore: false));
        } else {
           emit(IllnessTypeFailure(message: failure));
        }
      },
      (data) {
        if (state is IllnessTypeSuccess && event.page > 1) {
          final currentState = state as IllnessTypeSuccess;
          final newItems = List<IllnessTypeModel>.from(currentState.data.items)..addAll(data.items);
          final newData = IllnessTypePaginationModel(
            items: newItems,
            pagination: data.pagination,
          );
          emit(IllnessTypeSuccess(
            data: newData,
            hasReachedMax: data.items.isEmpty || data.pagination.page >= data.pagination.totalPages,
            isFetchingMore: false,
          ));
        } else {
          emit(IllnessTypeSuccess(
            data: data,
            hasReachedMax: data.items.isEmpty || data.pagination.page >= data.pagination.totalPages,
            isFetchingMore: false,
          ));
        }
      },
    );
  }
}
