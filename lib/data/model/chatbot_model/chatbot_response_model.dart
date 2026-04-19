import 'package:equatable/equatable.dart';

class ChatbotResponseModel extends Equatable {
  const ChatbotResponseModel({
    required this.answer,
    required this.conversationId,
    this.sources = const [],
  });

  final String answer;
  final String conversationId;
  final List<dynamic> sources;

  factory ChatbotResponseModel.fromJson(Map<String, dynamic> json) {
    // Handling nested raw data if wrapped in "data" according to the standard API response
    final data = json['data'] != null ? json['data'] as Map<String, dynamic> : json;
    
    return ChatbotResponseModel(
      answer: data['answer'] as String? ?? data['message'] as String? ?? '',
      conversationId: data['conversationId'] as String? ?? '',
      sources: data['sources'] as List<dynamic>? ?? [],
    );
  }

  @override
  List<Object?> get props => [answer, conversationId, sources];
}
