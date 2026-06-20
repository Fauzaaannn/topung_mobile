import 'package:topung_mobile/core/utils/dio_exception_extension.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_interaction_remote_provider.dart';
import 'package:topung_mobile/domain/repositories/interaction_repository.dart';

class InteractionRepositoryImpl implements InteractionRepository {
  InteractionRepositoryImpl(this._remoteProvider);

  final IInteractionRemoteProvider _remoteProvider;

  @override
  Future<Either<String, CommentPaginationResponseModel>> getCommentsPagination({
    required String materialId,
    required int page,
    required int pageSize,
    String? search,
  }) async {
    try {
      final Map<String, dynamic> payload = {'page': page, 'pageSize': pageSize};
      if (search != null) {
        payload['search'] = search;
      }

      final result = await _remoteProvider.getCommentsPagination(
        materialId: materialId,
        paginationPayload: payload,
      );
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] as String? ??
          e.indonesianMessage ??
          'Terjadi kesalahan';
      return Left(message.toString());
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }

  @override
  Future<Either<String, CommentModel>> addComment({
    required String materialId,
    required String content,
    String? parentCommentId,
  }) async {
    try {
      final Map<String, dynamic> payload = {
        'content': content,
        'parentCommentId': parentCommentId,
      };

      print('DEBUG: Sending Comment Payload: $payload');

      final result = await _remoteProvider.addComment(
        materialId: materialId,
        commentPayload: payload,
      );
      return Right(result);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] as String? ??
          e.indonesianMessage ??
          'Terjadi kesalahan';
      return Left(message.toString());
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }

  @override
  Future<Either<String, bool>> postInteraction({
    required String materialId,
    required String interactionType,
  }) async {
    try {
      final Map<String, dynamic> payload = {'interactionType': interactionType};

      await _remoteProvider.postInteraction(
        materialId: materialId,
        interactionPayload: payload,
      );
      return const Right(true);
    } on DioException catch (e) {
      final message =
          e.response?.data?['message'] ??
          e.response?.data?['error'] as String? ??
          e.indonesianMessage ??
          'Terjadi kesalahan';
      return Left(message.toString());
    } catch (_) {
      return const Left('Terjadi kesalahan tidak terduga');
    }
  }
}
