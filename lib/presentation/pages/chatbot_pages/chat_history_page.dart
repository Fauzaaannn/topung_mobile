import 'dart:async';
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

class _ChatHistoryPageState extends State<ChatHistoryPage>
    with SingleTickerProviderStateMixin {
  final _scrollController = ScrollController();
  final _searchController = TextEditingController();
  Timer? _debounce;
  late ChatbotHistoryBloc _bloc;

  String _searchQuery = '';
  String _sortOption = 'desc';
  bool _isFetchingMore = false;

  late AnimationController _tooltipAnimController;
  late Animation<Offset> _tooltipOffsetAnim;
  late Animation<double> _tooltipSizeAnim;

  @override
  void initState() {
    super.initState();
    _bloc = ChatbotHistoryBloc(GetIt.instance<ChatbotHistoryUsecase>());
    _fetchData();

    _tooltipAnimController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _tooltipOffsetAnim =
        Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _tooltipAnimController,
            curve: Curves.easeOutBack,
          ),
        );

    _tooltipSizeAnim = CurvedAnimation(
      parent: _tooltipAnimController,
      curve: Curves.easeOutBack,
    );

    // Tampilkan tooltip setelah 1.5 detik
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _tooltipAnimController.forward();
        // Sembunyikan otomatis setelah 5 detik
        Future.delayed(const Duration(seconds: 5), () {
          if (mounted) _tooltipAnimController.reverse();
        });
      }
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent * 0.9) {
        final state = _bloc.state;
        if (state is ChatbotHistoryLoaded && !_isFetchingMore) {
          if (state.pagination.page < state.pagination.totalPages) {
            setState(() {
              _isFetchingMore = true;
            });
            _bloc.add(
              GetChatbotHistoriesPaginationEvent(
                page: state.pagination.page + 1,
                search: _searchQuery,
                sort: [
                  {'field': 'lastActivity', 'direction': _sortOption},
                ],
                isLoadMore: true,
              ),
            );
          }
        }
      }
    });
  }

  void _fetchData() {
    _bloc.add(
      GetChatbotHistoriesPaginationEvent(
        search: _searchQuery,
        sort: [
          {'field': 'lastActivity', 'direction': _sortOption},
        ],
      ),
    );
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      if (_searchQuery != query) {
        setState(() {
          _searchQuery = query;
        });
        _fetchData();
      }
    });
  }

  void _onSortChanged(String? newValue) {
    if (newValue != null && _sortOption != newValue) {
      setState(() {
        _sortOption = newValue;
      });
      _fetchData();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    _tooltipAnimController.dispose();
    _bloc.close();
    super.dispose();
  }

  Future<void> _onRefresh() async {
    _fetchData();
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
        body: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'Cari riwayat...',
                            hintStyle: TextStyle(
                              color: ColorConstant.greyDark,
                              fontSize: FontConstant.fontSize14,
                            ),
                            prefixIcon: const Icon(
                              Icons.search,
                              color: ColorConstant.greyDark,
                            ),
                            filled: true,
                            fillColor: ColorConstant.greyLight.withOpacity(0.3),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 0,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        height: 48,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: ColorConstant.greyLight.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _sortOption,
                            icon: const Icon(
                              Icons.sort_rounded,
                              color: ColorConstant.greyDark,
                            ),
                            style: TextStyle(
                              color: ColorConstant.black,
                              fontSize: FontConstant.fontSize14,
                              fontFamily: FontConstant.robotoFontFamily,
                            ),
                            items: const [
                              DropdownMenuItem(
                                value: 'desc',
                                child: Text('Terbaru'),
                              ),
                              DropdownMenuItem(
                                value: 'asc',
                                child: Text('Terlama'),
                              ),
                            ],
                            onChanged: _onSortChanged,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: BlocConsumer<ChatbotHistoryBloc, ChatbotHistoryState>(
                    listener: (context, state) {
                      if (state is ChatbotHistoryLoaded ||
                          state is ChatbotHistoryError) {
                        setState(() {
                          _isFetchingMore = false;
                        });
                      }
                    },
                    builder: (context, state) {
                      if (state is ChatbotHistoryLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: ColorConstant.primary,
                          ),
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
                              _searchQuery.isNotEmpty
                                  ? "Tidak ada riwayat yang ditemukan dari '$_searchQuery'"
                                  : 'Belum ada riwayat chat',
                              style: TextStyle(
                                fontSize: FontConstant.fontSize14,
                                color: ColorConstant.grey,
                                fontFamily: FontConstant.robotoFontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return RefreshIndicator(
                          onRefresh: _onRefresh,
                          color: ColorConstant.primary,
                          child: ListView.separated(
                            controller: _scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: const EdgeInsets.only(
                              left: 16,
                              right: 16,
                              bottom: 80,
                            ),
                            itemCount:
                                state.histories.length +
                                (_isFetchingMore ||
                                        state.pagination.page <
                                            state.pagination.totalPages
                                    ? 1
                                    : 0),
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
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
                                    ? "${history.updatedAt!.day}/${history.updatedAt!.month}/${history.updatedAt!.year}"
                                    : 'Sesi Chatbot',
                                onTap: () {
                                  context.router
                                      .push(
                                        ChatRoute(
                                          chatId: history.conversationId,
                                        ),
                                      )
                                      .then((_) {
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
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SlideTransition(
                    position: _tooltipOffsetAnim,
                    child: SizeTransition(
                      sizeFactor: _tooltipSizeAnim,
                      axis: Axis.horizontal,
                      axisAlignment: 1.0,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => _tooltipAnimController.reverse(),
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: ColorConstant.primary,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: const Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Mulai obrolan baru?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.router.push(ChatRoute()).then((_) {
                        _onRefresh();
                      });
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: ColorConstant.primary.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.chat_bubble_outline_rounded,
                        color: ColorConstant.white,
                        size: 24,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
