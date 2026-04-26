import 'package:dartz/dartz.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';

abstract class InteractionRepository {
  Future<Either<String, CommentPaginationResponseModel>> getCommentsPagination({
    required String materialId,
    required int page,
    required int pageSize,
    String? search,
  });

  Future<Either<String, CommentModel>> addComment({
    required String materialId,
    required String content,
    String? parentCommentId,
  });

  Future<Either<String, bool>> postInteraction({
    required String materialId,
    required String interactionType,
  });
}
