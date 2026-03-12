part of 'illness_material_bloc.dart';

abstract class IllnessMaterialState {}

class IllnessMaterialInitial extends IllnessMaterialState {}

class IllnessMaterialLoading extends IllnessMaterialState {}

class IllnessMaterialSuccess extends IllnessMaterialState {
  IllnessMaterialSuccess({required this.data});

  final IllnessMaterialModel data;
}

class IllnessMaterialFailure extends IllnessMaterialState {
  IllnessMaterialFailure({required this.message});

  final String message;
}
