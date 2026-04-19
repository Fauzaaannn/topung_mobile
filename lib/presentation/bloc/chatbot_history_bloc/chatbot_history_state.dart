import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';
import 'package:topung_mobile/data/model/pagination_meta_model/pagination_meta_model.dart';

abstract class ChatbotHistoryState extends Equatable {
  const ChatbotHistoryState();

  @override
  List<Object?> get props => [];
}

class ChatbotHistoryInitial extends ChatbotHistoryState {}

class ChatbotHistoryLoading extends ChatbotHistoryState {}

class ChatbotHistoryLoaded extends ChatbotHistoryState {
  const ChatbotHistoryLoaded({
    required this.histories,
    required this.pagination,
  });

  final List<ChatbotHistoryModel> histories;
  final PaginationMetaModel pagination;

  ChatbotHistoryLoaded copyWith({
    List<ChatbotHistoryModel>? histories,
    PaginationMetaModel? pagination,
  }) {
    return ChatbotHistoryLoaded(
      histories: histories ?? this.histories,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [histories, pagination];
}

class ChatbotHistoryError extends ChatbotHistoryState {
  const ChatbotHistoryError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ChatbotMessageLoading extends ChatbotHistoryState {}

class ChatbotMessageLoaded extends ChatbotHistoryState {
  const ChatbotMessageLoaded({
    required this.messages,
    required this.pagination,
  });

  final List<ChatbotMessageModel> messages;
  final PaginationMetaModel pagination;

  ChatbotMessageLoaded copyWith({
    List<ChatbotMessageModel>? messages,
    PaginationMetaModel? pagination,
  }) {
    return ChatbotMessageLoaded(
      messages: messages ?? this.messages,
      pagination: pagination ?? this.pagination,
    );
  }

  @override
  List<Object?> get props => [messages, pagination];
}

class ChatbotMessageError extends ChatbotHistoryState {
  const ChatbotMessageError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
