part of 'illness_type_bloc.dart';

abstract class IllnessTypeState {}

class IllnessTypeInitial extends IllnessTypeState {}

class IllnessTypeLoading extends IllnessTypeState {}

class IllnessTypeSuccess extends IllnessTypeState {
  IllnessTypeSuccess({required this.data});

  final IllnessTypePaginationModel data;
}

class IllnessTypeFailure extends IllnessTypeState {
  IllnessTypeFailure({required this.message});

  final String message;
}
