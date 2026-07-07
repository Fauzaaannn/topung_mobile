import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';

abstract class IChatbotHistoryRemoteProvider {
  Future<ChatbotHistoryPaginationModel> getChatbotHistoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
    List<Map<String, dynamic>>? filter,
    List<Map<String, dynamic>>? sort,
  });

  Future<ChatbotMessagePaginationModel> getChatbotHistoryByIdPagination({
    required String conversationId,
    int page = 1,
    int pageSize = 10,
  });
}
