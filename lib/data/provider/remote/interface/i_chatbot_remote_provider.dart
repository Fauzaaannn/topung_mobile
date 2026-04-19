import 'package:topung_mobile/data/model/chatbot_model/chatbot_response_model.dart';

abstract class IChatbotRemoteProvider {
  Future<ChatbotResponseModel> askChatbot({
    required String question,
    String? conversationId,
  });
}
