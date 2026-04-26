import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/pagination_meta_model/pagination_meta_model.dart';

class IllnessTypeModel extends Equatable {
  const IllnessTypeModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.videoUrl,
    required this.textContent,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    this.myInteractions = const [],
  });

  final String id;
  final String categoryId;
  final String title;
  final String videoUrl;
  final String textContent;
  final String imageUrl;
  final String createdAt;
  final String updatedAt;
  final List<String> myInteractions;

  factory IllnessTypeModel.fromJson(Map<String, dynamic> json) =>
      IllnessTypeModel(
        id: json['id'] as String,
        categoryId: json['categoryId'] as String,
        title: json['title'] as String,
        videoUrl: json['videoUrl'] as String,
        textContent: json['textContent'] as String,
        imageUrl: json['imageUrl'] as String,
        createdAt: json['createdAt'] as String,
        updatedAt: json['updatedAt'] as String,
        myInteractions: (json['myInteractions'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );

  @override
  List<Object?> get props => [
    id,
    categoryId,
    title,
    videoUrl,
    textContent,
    imageUrl,
    createdAt,
    updatedAt,
    myInteractions,
  ];
}

class IllnessTypePaginationModel extends Equatable {
  const IllnessTypePaginationModel({
    required this.items,
    required this.pagination,
  });

  final List<IllnessTypeModel> items;
  final PaginationMetaModel pagination;

  factory IllnessTypePaginationModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return IllnessTypePaginationModel(
      items: (data['items'] as List<dynamic>)
          .map((e) => IllnessTypeModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationMetaModel.fromJson(
        data['pagination'] as Map<String, dynamic>,
      ),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}
