import 'package:equatable/equatable.dart';

class ChatbotResponseModel extends Equatable {
  const ChatbotResponseModel({
    required this.id,
    required this.userId,
    required this.question,
    required this.answer,
    required this.conversationId,
    this.sources = const [],
    this.images = const [],
    this.timestamp,
  });

  final String id;
  final String userId;
  final String question;
  final String answer;
  final String conversationId;
  final List<dynamic> sources;
  final List<dynamic> images;
  final DateTime? timestamp;

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    // Handling nested raw data if wrapped in "data" according to the standard API response
    final data = json['data'] != null ? json['data'] as Map<String, dynamic> : json;
    
    return ChatbotResponseModel(
      id: data['id'] as String? ?? '',
      userId: data['userId'] as String? ?? '',
      question: data['question'] as String? ?? '',
      answer: data['answer'] as String? ?? data['message'] as String? ?? '',
      conversationId: data['conversationId'] as String? ?? '',
      sources: data['sources'] as List<dynamic>? ?? [],
      images: data['images'] as List<dynamic>? ?? [],
      timestamp: data['timestamp'] != null
          ? DateTime.tryParse(data['timestamp'] as String)
          : null,
    );
  }

  @override
  List<Object?> get props => [id, userId, question, answer, conversationId, sources, images, timestamp];
}
