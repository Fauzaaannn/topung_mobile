import 'package:equatable/equatable.dart';

abstract class ChatbotHistoryEvent extends Equatable {
  const ChatbotHistoryEvent();

  @override
  List<Object?> get props => [];
}

class GetChatbotHistoriesPaginationEvent extends ChatbotHistoryEvent {
  const GetChatbotHistoriesPaginationEvent({
    this.page = 1,
    this.pageSize = 10,
    this.search = '',
    this.filter,
    this.sort,
    this.isLoadMore = false,
  });

  final int page;
  final int pageSize;
  final String search;
  final List<Map<String, dynamic>>? filter;
  final List<Map<String, dynamic>>? sort;
  final bool isLoadMore;

  @override
  List<Object?> get props => [page, pageSize, search, filter, sort, isLoadMore];
}

class GetChatbotHistoryByIdPaginationEvent extends ChatbotHistoryEvent {
  const GetChatbotHistoryByIdPaginationEvent({
    required this.conversationId,
    this.page = 1,
    this.pageSize = 10,
    this.isLoadMore = false,
  });

  final String conversationId;
  final int page;
  final int pageSize;
  final bool isLoadMore;

  @override
  List<Object?> get props => [conversationId, page, pageSize, isLoadMore];
}
