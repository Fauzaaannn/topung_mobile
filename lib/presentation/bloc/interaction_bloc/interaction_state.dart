import 'package:equatable/equatable.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';

abstract class InteractionState extends Equatable {
  const InteractionState();

  @override
  List<Object?> get props => [];
}

class InteractionInitial extends InteractionState {}

// Get Comments States
class CommentsLoading extends InteractionState {}

class CommentsLoaded extends InteractionState {
  const CommentsLoaded(this.response);

  final CommentPaginationResponseModel response;

  @override
  List<Object?> get props => [response];
}

class CommentsError extends InteractionState {
  const CommentsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// Add Comment States
class AddCommentLoading extends InteractionState {}

class AddCommentSuccess extends InteractionState {
  const AddCommentSuccess(this.comment);

  final CommentModel comment;

  @override
  List<Object?> get props => [comment];
}

class AddCommentError extends InteractionState {
  const AddCommentError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

// Post Interaction States
class InteractionActionLoading extends InteractionState {}

class InteractionActionSuccess extends InteractionState {}

class InteractionActionError extends InteractionState {
  const InteractionActionError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
