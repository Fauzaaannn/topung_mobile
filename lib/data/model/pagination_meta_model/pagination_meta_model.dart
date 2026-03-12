import 'package:equatable/equatable.dart';

class PaginationMetaModel extends Equatable {
  const PaginationMetaModel({
    required this.page,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  final int page;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) =>
      PaginationMetaModel(
        page: json['page'] as int,
        pageSize: json['pageSize'] as int,
        totalItems: json['totalItems'] as int,
        totalPages: json['totalPages'] as int,
      );

  @override
  List<Object?> get props => [page, pageSize, totalItems, totalPages];
}
