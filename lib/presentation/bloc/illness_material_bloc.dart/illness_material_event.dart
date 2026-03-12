part of 'illness_material_bloc.dart';

abstract class IllnessMaterialEvent {}

class IllnessMaterialFetched extends IllnessMaterialEvent {
  IllnessMaterialFetched({required this.materialId});

  final String materialId;
}
