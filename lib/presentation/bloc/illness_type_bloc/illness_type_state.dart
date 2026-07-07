part of 'illness_type_bloc.dart';

abstract class IllnessTypeState {}

class IllnessTypeInitial extends IllnessTypeState {}

class IllnessTypeLoading extends IllnessTypeState {}

class IllnessTypeSuccess extends IllnessTypeState {
  IllnessTypeSuccess({
    required this.data,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });

  final IllnessTypePaginationModel data;
  final bool hasReachedMax;
  final bool isFetchingMore;

  IllnessTypeSuccess copyWith({
    IllnessTypePaginationModel? data,
    bool? hasReachedMax,
    bool? isFetchingMore,
  }) {
    return IllnessTypeSuccess(
      data: data ?? this.data,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isFetchingMore: isFetchingMore ?? this.isFetchingMore,
    );
  }
}

class IllnessTypeFailure extends IllnessTypeState {
  IllnessTypeFailure({required this.message});

  final String message;
}
