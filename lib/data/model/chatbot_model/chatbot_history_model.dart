import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/pagination_meta_model/pagination_meta_model.dart';

class ChatbotHistoryModel extends Equatable {
  const ChatbotHistoryModel({
    required this.conversationId,
    required this.title,
    this.updatedAt,
  });

  final String conversationId;
  final String title;
  final DateTime? updatedAt;

  factory ChatbotHistoryModel.fromJson(Map<String, dynamic> json) =>
      ChatbotHistoryModel(
        conversationId:
            json['conversationId'] as String? ?? json['id'] as String? ?? '',
        title:
            json['title'] as String? ??
            json['question'] as String? ??
            'Percakapan',
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'] as String)
            : json['lastActivity'] != null
            ? DateTime.tryParse(json['lastActivity'] as String)
            : json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [conversationId, title, updatedAt];
}

class ChatbotHistoryPaginationModel extends Equatable {
  const ChatbotHistoryPaginationModel({
    required this.items,
    required this.pagination,
  });

  final List<ChatbotHistoryModel> items;
  final PaginationMetaModel pagination;

  factory ChatbotHistoryPaginationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json.containsKey('data') && json['data'] != null
        ? json['data'] as Map<String, dynamic>
        : json;

    if (data['items'] == null) {
      return const ChatbotHistoryPaginationModel(
        items: [],
        pagination: PaginationMetaModel(
          page: 1,
          pageSize: 10,
          totalPages: 0,
          totalItems: 0,
        ),
      );
    }

    final itemsList = data['items'] as List<dynamic>? ?? [];
    return ChatbotHistoryPaginationModel(
      items: itemsList
          .map((e) => ChatbotHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationMetaModel.fromJson(
        data['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}

class ChatbotMessageModel extends Equatable {
  const ChatbotMessageModel({
    required this.id,
    required this.userId,
    required this.conversationId,
    required this.question,
    required this.answer,
    this.sources,
    this.images,
    this.createdAt,
  });

  final String id;
  final String userId;
  final String conversationId;
  final String question;
  final String answer;
  final List<dynamic>? sources;
  final List<dynamic>? images;
  final DateTime? createdAt;

  factory ChatbotMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatbotMessageModel(
        id: json['id'] as String? ?? '',
        userId: json['userId'] as String? ?? '',
        conversationId: json['conversationId'] as String? ?? '',
        question: json['question'] as String? ?? '',
        answer: json['answer'] as String? ?? '',
        sources: json['sources'] as List<dynamic>? ?? [],
        images: json['images'] as List<dynamic>? ?? [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : json['timestamp'] != null 
                ? DateTime.tryParse(json['timestamp'] as String) 
                : null,
      );

  @override
  List<Object?> get props => [id, userId, conversationId, question, answer, sources, images, createdAt];
}

class ChatbotMessagePaginationModel extends Equatable {
  const ChatbotMessagePaginationModel({
    required this.items,
    required this.pagination,
  });

  final List<ChatbotMessageModel> items;
  final PaginationMetaModel pagination;

  factory ChatbotMessagePaginationModel.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data =
        json.containsKey('data') && json['data'] != null
        ? json['data'] as Map<String, dynamic>
        : json;

    if (data['items'] == null) {
      return const ChatbotMessagePaginationModel(
        items: [],
        pagination: PaginationMetaModel(
          page: 1,
          pageSize: 10,
          totalPages: 0,
          totalItems: 0,
        ),
      );
    }

    final itemsList = data['items'] as List<dynamic>? ?? [];
    return ChatbotMessagePaginationModel(
      items: itemsList
          .map((e) => ChatbotMessageModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pagination: PaginationMetaModel.fromJson(
        data['pagination'] as Map<String, dynamic>? ?? {},
      ),
    );
  }

  @override
  List<Object?> get props => [items, pagination];
}
