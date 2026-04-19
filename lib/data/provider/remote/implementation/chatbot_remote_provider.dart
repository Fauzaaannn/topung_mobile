import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_response_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_remote_provider.dart';

class ChatbotRemoteProvider implements IChatbotRemoteProvider {
  ChatbotRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<ChatbotResponseModel> askChatbot({
    required String question,
    String? conversationId,
  }) async {
    final Map<String, dynamic> payload = {
      'question': question,
    };
    if (conversationId != null && conversationId.isNotEmpty) {
      payload['conversationId'] = conversationId;
    }

    final response = await _dio.post(
      EndpointConstant.chatbotAsk,
      data: payload,
    );

    return ChatbotResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
