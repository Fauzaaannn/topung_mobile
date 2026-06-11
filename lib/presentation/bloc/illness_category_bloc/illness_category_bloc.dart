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
    if (state is IllnessCategorySuccess) {
      final currentState = state as IllnessCategorySuccess;
      if (currentState.hasReachedMax && event.page != 1) return;
      
      if (event.page == 1) {
        emit(IllnessCategoryLoading());
      } else {
        if (currentState.isFetchingMore) return;
        emit(currentState.copyWith(isFetchingMore: true));
      }
    } else {
      emit(IllnessCategoryLoading());
    }

    final result = await _illnessCategoryUsecase(
      page: event.page,
      pageSize: event.pageSize,
      search: event.search,
    );

    result.fold(
      (failure) {
        if (state is IllnessCategorySuccess) {
           final currentState = state as IllnessCategorySuccess;
           emit(currentState.copyWith(isFetchingMore: false));
        } else {
           emit(IllnessCategoryFailure(message: failure));
        }
      },
      (data) {
        if (state is IllnessCategorySuccess && event.page > 1) {
          final currentState = state as IllnessCategorySuccess;
          final newItems = List<IllnessCategoryModel>.from(currentState.data.items)..addAll(data.items);
          final newData = IllnessCategoryPaginationModel(
            items: newItems,
            pagination: data.pagination,
          );
          emit(IllnessCategorySuccess(
            data: newData,
            hasReachedMax: data.items.isEmpty || data.pagination.page >= data.pagination.totalPages,
            isFetchingMore: false,
          ));
        } else {
          emit(IllnessCategorySuccess(
            data: data,
            hasReachedMax: data.items.isEmpty || data.pagination.page >= data.pagination.totalPages,
            isFetchingMore: false,
          ));
        }
      },
    );
  }
}
