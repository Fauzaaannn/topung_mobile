part of 'illness_category_bloc.dart';

abstract class IllnessCategoryEvent {}

class IllnessCategoryFetched extends IllnessCategoryEvent {
  IllnessCategoryFetched({this.page = 1, this.pageSize = 10, this.search = ''});

  final int page;
  final int pageSize;
  final String search;
}