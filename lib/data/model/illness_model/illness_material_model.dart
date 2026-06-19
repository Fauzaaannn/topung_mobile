import 'package:equatable/equatable.dart';

class MaterialInteractionModel extends Equatable {
  const MaterialInteractionModel({required this.interactionType});

  final String interactionType;

  factory MaterialInteractionModel.fromJson(Map<String, dynamic> json) =>
      MaterialInteractionModel(
        interactionType: json['interactionType'] as String,
      );

  @override
  List<Object?> get props => [interactionType];
}

class IllnessMaterialModel extends Equatable {
  const IllnessMaterialModel({
    required this.id,
    required this.categoryId,
    required this.title,
    required this.videoUrl,
    required this.textContent,
    required this.imageUrl,
    this.embedImageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.myInteractions,
    this.myStatus,
  });

  final String id;
  final String categoryId;
  final String title;
  final String videoUrl;
  final String textContent;
  final String imageUrl;
  final String? embedImageUrl;
  final String createdAt;
  final String updatedAt;
  final List<MaterialInteractionModel> myInteractions;
  final String? myStatus;

  factory IllnessMaterialModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return IllnessMaterialModel(
      id: data['id'] as String,
      categoryId: data['categoryId'] as String,
      title: data['title'] as String,
      videoUrl: data['videoUrl'] as String,
      textContent: data['textContent'] as String,
      imageUrl: data['imageUrl'] as String,
      embedImageUrl: data['embedImageUrl'] as String?,
      createdAt: data['createdAt'] as String,
      updatedAt: data['updatedAt'] as String,
      myInteractions: (data['myInteractions'] as List<dynamic>)
          .map((e) => MaterialInteractionModel(interactionType: e.toString()))
          .toList(),
      myStatus: data['myStatus'] as String?,
    );
  }

  @override
  List<Object?> get props => [
    id,
    categoryId,
    title,
    videoUrl,
    textContent,
    imageUrl,
    embedImageUrl,
    createdAt,
    updatedAt,
    myInteractions,
    myStatus,
  ];
}
