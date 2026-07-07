import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_history_remote_provider.dart';

class ChatbotHistoryRemoteProvider implements IChatbotHistoryRemoteProvider {
  ChatbotHistoryRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<ChatbotHistoryPaginationModel> getChatbotHistoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
    List<Map<String, dynamic>>? filter,
    List<Map<String, dynamic>>? sort,
  }) async {
    final response = await _dio.post(
      EndpointConstant.chatbotHistoryPagination,
      data: {
        'data': {
          'filter': filter ?? [],
          'sort': sort ?? [
            {'field': 'lastActivity', 'direction': 'desc'},
          ],
          'search': search,
          'expression': '',
          'pagination': {'page': page, 'pageSize': pageSize},
        },
        'options': {
          'showError': true,
          'rollbackOnFailure': true,
          'showInfo': true,
        },
      },
    );
    return ChatbotHistoryPaginationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<ChatbotMessagePaginationModel> getChatbotHistoryByIdPagination({
    required String conversationId,
    int page = 1,
    int pageSize = 10,
  }) async {
    final response = await _dio.post(
      EndpointConstant.chatbotHistoryByIdPagination(conversationId),
      data: {
        'data': {
          'filter': [],
          'sort': [
            // Kronologis chat (lama ke baru)
            {'field': 'createdAt', 'direction': 'asc'},
          ],
          'search': '',
          'expression': '',
          'pagination': {'page': page, 'pageSize': pageSize},
        },
        'options': {
          'showError': true,
          'rollbackOnFailure': true,
          'showInfo': true,
        },
      },
    );
    return ChatbotMessagePaginationModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
