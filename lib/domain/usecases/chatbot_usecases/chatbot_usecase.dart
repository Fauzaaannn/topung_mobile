import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_response_model.dart';
import 'package:topung_mobile/domain/repositories/chatbot_repository.dart';

class ChatbotUsecase {
  const ChatbotUsecase(this._repository);

  final ChatbotRepository _repository;

  Future<Either<String, ChatbotResponseModel>> askChatbot({
    required String question,
    String? conversationId,
  }) {
    return _repository.askChatbot(
      question: question,
      conversationId: conversationId,
    );
  }
}
