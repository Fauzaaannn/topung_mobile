import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_response_model.dart';

abstract class ChatbotRepository {
  Future<Either<String, ChatbotResponseModel>> askChatbot({
    required String question,
    String? conversationId,
  });
}
