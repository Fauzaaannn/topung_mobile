part of 'illness_category_bloc.dart';

abstract class IllnessCategoryState {}

class IllnessCategoryInitial extends IllnessCategoryState {}

class IllnessCategoryLoading extends IllnessCategoryState {}

class IllnessCategorySuccess extends IllnessCategoryState {
  IllnessCategorySuccess({required this.data});

  final IllnessCategoryPaginationModel data;
}

class IllnessCategoryFailure extends IllnessCategoryState {
  IllnessCategoryFailure({required this.message});

  final String message;
}