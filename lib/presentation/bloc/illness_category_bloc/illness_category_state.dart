part of 'illness_category_bloc.dart';

abstract class IllnessCategoryState {}

class IllnessCategoryInitial extends IllnessCategoryState {}

class IllnessCategoryLoading extends IllnessCategoryState {}

class IllnessCategorySuccess extends IllnessCategoryState {
  IllnessCategorySuccess({
    required this.data,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  final IllnessCategoryPaginationModel data;
  final bool hasReachedMax;
  final bool isFetchingMore;

  IllnessCategorySuccess copyWith({
    IllnessCategoryPaginationModel? data,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return IllnessCategorySuccess(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class IllnessCategoryFailure extends IllnessCategoryState {
  IllnessCategoryFailure({required this.message});

  final String message;
}