import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/domain/usecases/chatbot_usecases/chatbot_usecase.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_bloc/chatbot_event.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_bloc/chatbot_state.dart';

class ChatbotBloc extends Bloc<ChatbotEvent, ChatbotState> {
  ChatbotBloc(this._usecase) : super(ChatbotInitial()) {
    on<AskChatbotEvent>(_onAskChatbotEvent);
  }

  final ChatbotUsecase _usecase;

  Future<void> _onAskChatbotEvent(
    AskChatbotEvent event,
    Emitter<ChatbotState> emit,
  ) async {
    emit(ChatbotLoading());

    final result = await _usecase.askChatbot(
      question: event.question,
      conversationId: event.conversationId,
    );

    result.fold(
      (failure) => emit(ChatbotError(failure)),
      (data) => emit(ChatbotSuccess(data)),
    );
  }
}
