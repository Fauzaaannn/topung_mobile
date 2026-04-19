import 'package:equatable/equatable.dart';

abstract class ChatbotEvent extends Equatable {
  const ChatbotEvent();

  @override
  List<Object?> get props => [];
}

class AskChatbotEvent extends ChatbotEvent {
  const AskChatbotEvent({
    required this.question,
    this.conversationId,
  });

  final String question;
  final String? conversationId;

  @override
  List<Object?> get props => [question, conversationId];
}
