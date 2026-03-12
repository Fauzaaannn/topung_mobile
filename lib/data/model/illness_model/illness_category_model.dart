import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/pagination_meta_model/pagination_meta_model.dart';

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
