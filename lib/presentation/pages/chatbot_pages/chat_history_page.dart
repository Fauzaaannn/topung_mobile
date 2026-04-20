import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/domain/usecases/chatbot_usecases/chatbot_history_usecase.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_bloc.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_event.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_state.dart';
import 'package:topung_mobile/presentation/widgets/cards/chat_history_card.dart';

@RoutePage()
class ChatHistoryPage extends StatefulWidget {
  const ChatHistoryPage({super.key});

  @override
  State<ChatHistoryPage> createState() => _ChatHistoryPageState();
}

class _ChatHistoryPageState extends State<ChatHistoryPage> {
  final _scrollController = ScrollController();
  late ChatbotHistoryBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = ChatbotHistoryBloc(GetIt.instance<ChatbotHistoryUsecase>());
    _bloc.add(const GetChatbotHistoriesPaginationEvent());

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        final state = _bloc.state;
        if (state is ChatbotHistoryLoaded) {
          if (state.pagination.page < state.pagination.totalPages) {
            _bloc.add(
              GetChatbotHistoriesPaginationEvent(
                page: state.pagination.page + 1,
                isLoadMore: true,
              ),
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _bloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _bloc.add(const GetChatbotHistoriesPaginationEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _bloc,
      child: Scaffold(
        backgroundColor: ColorConstant.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: ColorConstant.primary,
          elevation: 0,
          title: Text(
            'Chat History',
            style: TextStyle(
              fontSize: FontConstant.fontSize18,
              fontWeight: FontConstant.bold,
              color: ColorConstant.white,
              fontFamily: FontConstant.robotoFontFamily,
            ),
          ),
          centerTitle: true,
        ),
        body: BlocBuilder<ChatbotHistoryBloc, ChatbotHistoryState>(
          builder: (context, state) {
            if (state is ChatbotHistoryLoading) {
              return const Center(
                child: CircularProgressIndicator(color: ColorConstant.primary),
              );
            } else if (state is ChatbotHistoryError) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.message,
                      style: TextStyle(
                        fontSize: FontConstant.fontSize14,
                        color: ColorConstant.greyDark,
                        fontFamily: FontConstant.robotoFontFamily,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _onRefresh,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorConstant.primary,
                      ),
                      child: const Text(
                        'Coba Lagi',
                        style: TextStyle(color: ColorConstant.white),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is ChatbotHistoryLoaded) {
              if (state.histories.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada riwayat chat',
                    style: TextStyle(
                      fontSize: FontConstant.fontSize14,
                      color: ColorConstant.grey,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                );
              }

              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: ColorConstant.primary,
                child: ListView.separated(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  itemCount:
                      state.histories.length +
                      (state.pagination.page < state.pagination.totalPages
                          ? 1
                          : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == state.histories.length) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: ColorConstant.primary,
                          ),
                        ),
                      );
                    }

                    final history = state.histories[index];
                    return ChatHistoryCard(
                      title: history.title,
                      subtitle: history.updatedAt != null
                          ? '${history.updatedAt!.day}/${history.updatedAt!.month}/${history.updatedAt!.year}'
                          : 'Sesi Chatbot',
                      onTap: () {
                        context.router
                            .push(ChatRoute(chatId: history.conversationId))
                            .then((_) {
                              // Memperbarui history jika ada perubahan sesudah keluar chat
                              _onRefresh();
                            });
                      },
                    );
                  },
                ),
              );
            }

            return const SizedBox();
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            context.router.push(ChatRoute()).then((_) {
              _onRefresh();
            });
          },
          backgroundColor: ColorConstant.primaryLight,
          elevation: 2,
          child: const Icon(
            Icons.chat_bubble_outline_rounded,
            color: ColorConstant.primary,
          ),
        ),
      ),
    );
  }
}
