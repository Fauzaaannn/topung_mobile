import 'package:dio/dio.dart';
import 'package:topung_mobile/core/constant/endpoint_constant.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';
import 'package:topung_mobile/data/provider/remote/interface/i_interaction_remote_provider.dart';

class InteractionRemoteProvider implements IInteractionRemoteProvider {
  InteractionRemoteProvider(this._dio);

  final Dio _dio;

  @override
  Future<CommentPaginationResponseModel> getCommentsPagination({
    required String materialId,
    required Map<String, dynamic> paginationPayload,
  }) async {
    final response = await _dio.post(
      EndpointConstant.materialCommentsPagination(materialId),
      data: paginationPayload,
    );

    return CommentPaginationResponseModel.fromJson(
      response.data as Map<String, dynamic>,
    );
  }

  @override
  Future<CommentModel> addComment({
    required String materialId,
    required Map<String, dynamic> commentPayload,
  }) async {
    final response = await _dio.post(
      EndpointConstant.materialComments(materialId),
      data: commentPayload,
    );

    final data = response.data['data'] as Map<String, dynamic>;
    return CommentModel.fromJson(data);
  }

  @override
  Future<void> postInteraction({
    required String materialId,
    required Map<String, dynamic> interactionPayload,
  }) async {
    await _dio.post(
      EndpointConstant.materialInteractions(materialId),
      data: interactionPayload,
    );
  }
}
