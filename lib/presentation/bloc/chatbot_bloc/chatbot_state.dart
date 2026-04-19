import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_response_model.dart';

abstract class ChatbotState extends Equatable {
  const ChatbotState();

  @override
  List<Object?> get props => [];
}

class ChatbotInitial extends ChatbotState {}

class ChatbotLoading extends ChatbotState {}

class ChatbotSuccess extends ChatbotState {
  const ChatbotSuccess(this.response);

  final ChatbotResponseModel response;

  @override
  List<Object?> get props => [response];
}

class ChatbotError extends ChatbotState {
  const ChatbotError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
