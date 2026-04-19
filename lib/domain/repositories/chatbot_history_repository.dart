import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';

abstract class ChatbotHistoryRepository {
  Future<Either<String, ChatbotHistoryPaginationModel>> getChatbotHistoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
  });

  Future<Either<String, ChatbotMessagePaginationModel>> getChatbotHistoryByIdPagination({
    required String conversationId,
    int page = 1,
    int pageSize = 10,
  });
}
