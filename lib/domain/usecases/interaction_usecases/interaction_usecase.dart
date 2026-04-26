import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';
import 'package:topung_mobile/domain/repositories/interaction_repository.dart';

class InteractionUsecase {
  const InteractionUsecase(this._repository);

  final InteractionRepository _repository;

  Future<Either<String, CommentPaginationResponseModel>> getCommentsPagination({
    required String materialId,
    required int page,
    required int pageSize,
    String? search,
  }) {
    return _repository.getCommentsPagination(
      materialId: materialId,
      page: page,
      pageSize: pageSize,
      search: search,
    );
  }

  Future<Either<String, CommentModel>> addComment({
    required String materialId,
    required String content,
    String? parentCommentId,
  }) {
    return _repository.addComment(
      materialId: materialId,
      content: content,
      parentCommentId: parentCommentId,
    );
  }

  Future<Either<String, bool>> postInteraction({
    required String materialId,
    required String interactionType,
  }) {
    return _repository.postInteraction(
      materialId: materialId,
      interactionType: interactionType,
    );
  }
}
