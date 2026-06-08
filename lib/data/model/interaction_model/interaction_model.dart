import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/pagination_meta_model/pagination_meta_model.dart';

class CommentModel extends Equatable {
  const CommentModel({
    required this.id,
    required this.content,
    required this.userId,
    this.username,
    required this.materialId,
    this.parentCommentId,
    required this.createdAt,
    required this.updatedAt,
    this.user,
  });

  final String id;
  final String content;
  final String userId;
  final String? username;
  final String materialId;
  final String? parentCommentId;
  final String createdAt;
  final String updatedAt;
  final Map<String, dynamic>? user;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
    id: json['id'] as String,
    content: json['content'] as String,
    userId: json['userId'] as String,
    username: json['username'] as String?,
    materialId: json['materialId'] as String,
    parentCommentId: json['parentCommentId'] as String?,
    createdAt: json['createdAt'] as String,
    updatedAt: (json['updatedAt'] ?? json['createdAt']) as String,
    user: json['user'] as Map<String, dynamic>?,
  );

  @override
  List<Object?> get props => [
    id,
    content,
    userId,
    username,
    materialId,
    parentCommentId,
    createdAt,
    updatedAt,
    user,
  ];
}

class CommentPaginationResponseModel extends Equatable {
  const CommentPaginationResponseModel({
    required this.comments,
    required this.meta,
  });

  final List<CommentModel> comments;
  final PaginationMetaModel meta;

  factory CommentPaginationResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    final items = data['items'] as List<dynamic>;
    final pagination = data['pagination'] as Map<String, dynamic>;

    return CommentPaginationResponseModel(
      comments: items
          .map((e) => CommentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMetaModel(
        page: pagination['page'] as int,
        pageSize: (pagination['pageSize'] ?? pagination['pagesize']) as int,
        totalItems:
            (pagination['totalItems'] ?? pagination['totalitems']) as int,
        totalPages:
            (pagination['totalPages'] ?? pagination['totalpages']) as int,
      ),
    );
  }

  @override
  List<Object?> get props => [comments, meta];
}

class InteractionPayload extends Equatable {
  const InteractionPayload({required this.interactionType});

  final String interactionType;

  Map<String, dynamic> toJson() => {'interactionType': interactionType};

  @override
  List<Object?> get props => [interactionType];
}

class CommentPayload extends Equatable {
  const CommentPayload({required this.content, this.parentCommentId});

  final String content;
  final String? parentCommentId;

  Map<String, dynamic> toJson() => {
    'content': content,
    'parentCommentId': parentCommentId,
  };

  @override
  List<Object?> get props => [content, parentCommentId];
}
