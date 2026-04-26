import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';
import 'package:topung_mobile/domain/usecases/interaction_usecases/interaction_usecase.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_event.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_state.dart';

class InteractionBloc extends Bloc<InteractionEvent, InteractionState> {
  InteractionBloc(this._usecase) : super(InteractionInitial()) {
    on<GetCommentsEvent>(_onGetComments);
    on<AddCommentEvent>(_onAddComment);
    on<PostInteractionEvent>(_onPostInteraction);
  }

  final InteractionUsecase _usecase;

  Future<void> _onGetComments(
    GetCommentsEvent event,
    Emitter<InteractionState> emit,
  ) async {
    final currentState = state;
    List<CommentModel> oldComments = [];
    int currentPage = event.page;

    if (currentPage > 1 && currentState is CommentsLoaded) {
      oldComments = currentState.comments;
      emit(
        CommentsLoaded(
          comments: oldComments,
          currentPage: currentState.currentPage,
          totalPages: currentState.totalPages,
          isLoadingMore: true,
        ),
      );
    } else {
      emit(CommentsLoading());
    }

    final result = await _usecase.getCommentsPagination(
      materialId: event.materialId,
      page: event.page,
      pageSize: event.pageSize,
      search: event.search,
    );

    result.fold((l) => emit(CommentsError(l)), (r) {
      emit(
        CommentsLoaded(
          comments: event.page == 1 ? r.comments : oldComments + r.comments,
          currentPage: r.meta.page,
          totalPages: r.meta.totalPages,
          isLoadingMore: false,
        ),
      );
    });
  }

  Future<void> _onAddComment(
    AddCommentEvent event,
    Emitter<InteractionState> emit,
  ) async {
    emit(AddCommentLoading());
    final result = await _usecase.addComment(
      materialId: event.materialId,
      content: event.content,
      parentCommentId: event.parentCommentId,
    );

    result.fold(
      (l) => emit(AddCommentError(l)),
      (r) => emit(AddCommentSuccess(r)),
    );
  }

  Future<void> _onPostInteraction(
    PostInteractionEvent event,
    Emitter<InteractionState> emit,
  ) async {
    emit(InteractionActionLoading());
    final result = await _usecase.postInteraction(
      materialId: event.materialId,
      interactionType: event.interactionType,
    );

    result.fold(
      (l) => emit(InteractionActionError(l)),
      (r) => emit(InteractionActionSuccess()),
    );
  }
}
