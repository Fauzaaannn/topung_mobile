import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/domain/usecases/chatbot_usecases/chatbot_history_usecase.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_event.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_state.dart';

class ChatbotHistoryBloc extends Bloc<ChatbotHistoryEvent, ChatbotHistoryState> {
  ChatbotHistoryBloc(this._usecase) : super(ChatbotHistoryInitial()) {
    on<GetChatbotHistoriesPaginationEvent>(_onGetChatbotHistoriesPagination);
    on<GetChatbotHistoryByIdPaginationEvent>(_onGetChatbotHistoryByIdPagination);
  }

  final ChatbotHistoryUsecase _usecase;

  Future<void> _onGetChatbotHistoriesPagination(
    GetChatbotHistoriesPaginationEvent event,
    Emitter<ChatbotHistoryState> emit,
  ) async {
    if (event.isLoadMore && state is ChatbotHistoryLoaded) {
      final currentState = state as ChatbotHistoryLoaded;
      if (event.page <= currentState.pagination.page) return;
    } else {
      emit(ChatbotHistoryLoading());
    }

    final result = await _usecase.getChatbotHistoriesPagination(
      page: event.page,
      pageSize: event.pageSize,
      search: event.search,
      filter: event.filter,
      sort: event.sort,
    );

    result.fold(
      (failure) {
        emit(ChatbotHistoryError(failure));
      },
      (data) {
        if (event.isLoadMore && state is ChatbotHistoryLoaded) {
          final currentState = state as ChatbotHistoryLoaded;
          emit(
            currentState.copyWith(
              histories: [...currentState.histories, ...data.items],
              pagination: data.pagination,
            ),
          );
        } else {
          emit(
            ChatbotHistoryLoaded(
              histories: data.items,
              pagination: data.pagination,
            ),
          );
        }
      },
    );
  }

  Future<void> _onGetChatbotHistoryByIdPagination(
    GetChatbotHistoryByIdPaginationEvent event,
    Emitter<ChatbotHistoryState> emit,
  ) async {
    if (event.isLoadMore && state is ChatbotMessageLoaded) {
      final currentState = state as ChatbotMessageLoaded;
      if (event.page <= currentState.pagination.page) return;
    } else {
      emit(ChatbotMessageLoading());
    }

    final result = await _usecase.getChatbotHistoryByIdPagination(
      conversationId: event.conversationId,
      page: event.page,
      pageSize: event.pageSize,
    );

    result.fold(
      (failure) {
        emit(ChatbotMessageError(failure));
      },
      (data) {
        if (event.isLoadMore && state is ChatbotMessageLoaded) {
          final currentState = state as ChatbotMessageLoaded;
          emit(
            currentState.copyWith(
              messages: [...currentState.messages, ...data.items],
              pagination: data.pagination,
            ),
          );
        } else {
          emit(
            ChatbotMessageLoaded(
              messages: data.items,
              pagination: data.pagination,
            ),
          );
        }
      },
    );
  }
}
