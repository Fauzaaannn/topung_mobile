import 'package:equatable/equatable.dart';

class IllnessCategoryModel extends Equatable {
  const IllnessCategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final String description;
  final String imageUrl;

  factory IllnessCategoryModel.fromJson(Map<String, dynamic> json) =>
      IllnessCategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        imageUrl: json['imageUrl'] as String,
      );

  @override
  List<Object?> get props => [id, name, description, imageUrl];
}

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

class IllnessCategoryPaginationModel extends Equatable {
  const IllnessCategoryPaginationModel({
    required this.items,
    required this.pagination,
  });

  final List<IllnessCategoryModel> items;
  final PaginationMetaModel pagination;

  factory IllnessCategoryPaginationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return IllnessCategoryPaginationModel(
      items: (data['items'] as List<dynamic>)
          .map((e) => IllnessCategoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationMetaModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}
