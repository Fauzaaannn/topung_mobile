import 'package:topung_mobile/core/utils/dio_exception_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/chatbot_model/chatbot_history_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_chatbot_history_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/chatbot_history_repository.dart';

class ChatbotHistoryRepositoryImpl implements ChatbotHistoryRepository {
  ChatbotHistoryRepositoryImpl(this._remoteProvider);

  final IChatbotHistoryRemoteProvider _remoteProvider;

  @override
  Future<Either<String, ChatbotHistoryPaginationModel>> getChatbotHistoriesPagination({
    int page = 1,
    int pageSize = 10,
    String search = '',
  }) async {
    try {
      final result = await _remoteProvider.getChatbotHistoriesPagination(
        page: page,
        pageSize: pageSize,
        search: search,
      );
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.response?.data?['error'] as String? ??
          e.indonesianMessage ??
          'Terjadi kesalahan';
      return Left(message.toString());
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }

  @override
  Future<Either<String, ChatbotMessagePaginationModel>> getChatbotHistoryByIdPagination({
    required String conversationId,
    int page = 1,
    int pageSize = 10,
  }) async {
    try {
      final result = await _remoteProvider.getChatbotHistoryByIdPagination(
        conversationId: conversationId,
        page: page,
        pageSize: pageSize,
      );
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ?? e.response?.data?['error'] as String? ??
          e.indonesianMessage ??
          'Terjadi kesalahan';
      return Left(message.toString());
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }
}
