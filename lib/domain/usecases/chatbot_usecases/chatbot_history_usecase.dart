import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';
import 'package:topung_mobile/domain/repositories/chatbot_history_repository.dart';

class ChatbotHistoryUsecase {
  const ChatbotHistoryUsecase(this._repository);

  final ChatbotHistoryRepository _repository;

  Future<Either<String, ChatbotHistoryPaginationModel>> getChatbotHistoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
    List<Map<String, dynamic>>? filter,
    List<Map<String, dynamic>>? sort,
  }) {
    return _repository.getChatbotHistoriesPagination(
      page: page,
      pageSize: pageSize,
      search: search,
      filter: filter,
      sort: sort,
    );
  }

  Future<Either<String, ChatbotMessagePaginationModel>> getChatbotHistoryByIdPagination({
    required String conversationId,
    int page = 1,
    int pageSize = 10,
  }) {
    return _repository.getChatbotHistoryByIdPagination(
      conversationId: conversationId,
      page: page,
      pageSize: pageSize,
    );
  }
}
