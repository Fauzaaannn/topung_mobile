import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';

abstract class ChatbotHistoryRepository {
  Future<Either<String, ChatbotHistoryPaginationModel>> getChatbotHistoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
    List<Map<String, dynamic>>? filter,
    List<Map<String, dynamic>>? sort,
  });

  Future<Either<String, ChatbotMessagePaginationModel>> getChatbotHistoryByIdPagination({
    required String conversationId,
    int page = 1,
    int pageSize = 10,
  });
}
