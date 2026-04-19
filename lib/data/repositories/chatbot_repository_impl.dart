import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_response_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/chatbot_repository.dart';

class ChatbotRepositoryImpl implements ChatbotRepository {
  ChatbotRepositoryImpl(this._remoteProvider);

  final IChatbotRemoteProvider _remoteProvider;

  @override
  Future<Either<String, ChatbotResponseModel>> askChatbot({
    required String question,
    String? conversationId,
  }) async {
    try {
      final result = await _remoteProvider.askChatbot(
        question: question,
        conversationId: conversationId,
      );
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.response?.data?['error'] as String? ??
          e.message ??
          'Terjadi kesalahan';
      return Left(message.toString());
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }
}
