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
    if (json['data'] == null) {
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
    final data = json['data'] as Map<String, dynamic>;
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
    required this.conversationId,
    required this.question,
    required this.answer,
    this.createdAt,
  });

  final String id;
  final String conversationId;
  final String question;
  final String answer;
  final DateTime? createdAt;

  factory ChatbotMessageModel.fromJson(Map<String, dynamic> json) =>
      ChatbotMessageModel(
        id: json['id'] as String? ?? '',
        conversationId: json['conversationId'] as String? ?? '',
        question: json['question'] as String? ?? '',
        answer: json['answer'] as String? ?? '',
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  @override
  List<Object?> get props => [id, conversationId, question, answer, createdAt];
}

class ChatbotMessagePaginationModel extends Equatable {
  const ChatbotMessagePaginationModel({
    required this.items,
    required this.pagination,
  });

  final List<ChatbotMessageModel> items;
  final PaginationMetaModel pagination;

  factory ChatbotMessagePaginationModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] == null) {
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
    final data = json['data'] as Map<String, dynamic>;
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
