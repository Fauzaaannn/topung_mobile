part of 'illness_type_bloc.dart';

abstract class IllnessTypeEvent {}

class IllnessTypeFetched extends IllnessTypeEvent {
  IllnessTypeFetched({
    required this.categoryId,
    this.page = 1,
    this.pageSize = 10,
    this.search = '',
  });

  final String categoryId;
  final int page;
  final int pageSize;
  final String search;
}
