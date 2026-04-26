import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';

abstract class IInteractionRemoteProvider {
  Future<CommentPaginationResponseModel> getCommentsPagination({
    required String materialId,
    required Map<String, dynamic> paginationPayload,
  });

  Future<CommentModel> addComment({
    required String materialId,
    required Map<String, dynamic> commentPayload,
  });

  Future<void> postInteraction({
    required String materialId,
    required Map<String, dynamic> interactionPayload,
  });
}
