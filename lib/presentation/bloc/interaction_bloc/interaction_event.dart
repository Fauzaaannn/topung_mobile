import 'package:equatable/equatable.dart';

abstract class InteractionEvent extends Equatable {
  const InteractionEvent();

  @override
  List<Object?> get props => [];
}

class GetCommentsEvent extends InteractionEvent {
  const GetCommentsEvent({
    required this.materialId,
    this.page = 1,
    this.pageSize = 10,
    this.search,
  });

  final String materialId;
  final int page;
  final int pageSize;
  final String? search;

  @override
  List<Object?> get props => [materialId, page, pageSize, search];
}

class AddCommentEvent extends InteractionEvent {
  const AddCommentEvent({
    required this.materialId,
    required this.content,
    this.parentCommentId,
  });

  final String materialId;
  final String content;
  final String? parentCommentId;

  @override
  List<Object?> get props => [materialId, content, parentCommentId];
}

class PostInteractionEvent extends InteractionEvent {
  const PostInteractionEvent({
    required this.materialId,
    required this.interactionType,
  });

  final String materialId;
  final String interactionType;

  @override
  List<Object?> get props => [materialId, interactionType];
}
