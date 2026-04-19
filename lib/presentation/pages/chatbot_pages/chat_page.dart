import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';

import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';

import 'package:topung_mobile/domain/usecases/chatbot_usecases/chatbot_usecase.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_bloc/chatbot_bloc.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_bloc/chatbot_event.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_bloc/chatbot_state.dart';

import 'package:topung_mobile/domain/usecases/chatbot_usecases/chatbot_history_usecase.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_bloc.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_event.dart';
import 'package:topung_mobile/presentation/bloc/chatbot_history_bloc/chatbot_history_state.dart';

enum _MessageRole { user, ai }

class _ChatSource {
  final String id;
  final String title;
  final String videoUrl;
  final String imageUrl;

  const _ChatSource({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.imageUrl,
  });
}

class _ChatMessage {
  final String text;
  final _MessageRole role;
  final List<_ChatSource>? sources;

  const _ChatMessage({required this.text, required this.role, this.sources});
}

@RoutePage()
class ChatPage extends StatefulWidget {
  final String? chatId;

  const ChatPage({super.key, this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  final Uuid _uuid = const Uuid();

  late ChatbotBloc _chatbotBloc;
  ChatbotHistoryBloc? _historyBloc;

  List<_ChatMessage> _messages = [];
  String? _currentConversationId;

  @override
  void initState() {
    super.initState();
    _chatbotBloc = ChatbotBloc(GetIt.instance<ChatbotUsecase>());

    // Konfigurasi Conversation ID
    if (widget.chatId != null && widget.chatId!.isNotEmpty) {
      _currentConversationId = widget.chatId;

      // Jika membuka percakapan lama, load history
      _historyBloc = ChatbotHistoryBloc(
        GetIt.instance<ChatbotHistoryUsecase>(),
      );
      _historyBloc!.add(
        GetChatbotHistoryByIdPaginationEvent(
          conversationId: _currentConversationId!,
          pageSize: 50, // Load cukup banyak pesan ke belakang
        ),
      );
    } else {
      // Jika chat baru, _currentConversationId akan didefinisikan dengan UUID v4
      _currentConversationId = _uuid.v4();

      // Berikan ucapan selamat datang / greeting lokal
      _messages.add(
        const _ChatMessage(
          text: 'Halo, ada yang bisa saya bantu?',
          role: _MessageRole.ai,
        ),
      );
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    _chatbotBloc.close();
    _historyBloc?.close();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    if (_chatbotBloc.state is ChatbotLoading) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, role: _MessageRole.user));
    });

    _messageController.clear();
    _scrollToBottom();

    // Mengirim ke API menggunakan _currentConversationId
    _chatbotBloc.add(
      AskChatbotEvent(question: text, conversationId: _currentConversationId),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: _chatbotBloc),
        if (_historyBloc != null) BlocProvider.value(value: _historyBloc!),
      ],
      child: MultiBlocListener(
        listeners: [
          BlocListener<ChatbotBloc, ChatbotState>(
            listener: (context, state) {
              if (state is ChatbotSuccess) {
                setState(() {
                  final mappedSources = state.response.sources.map((e) {
                    final mapData = e as Map<String, dynamic>;
                    return _ChatSource(
                      id: mapData['id']?.toString() ?? '',
                      title: mapData['title']?.toString() ?? 'Materi Rujukan',
                      videoUrl: mapData['videoUrl']?.toString() ?? '',
                      imageUrl: mapData['imageUrl']?.toString() ?? '',
                    );
                  }).toList();

                  _messages.add(
                    _ChatMessage(
                      text: state.response.answer,
                      role: _MessageRole.ai,
                      sources: mappedSources,
                    ),
                  );
                });
                _scrollToBottom();
              } else if (state is ChatbotError) {
                setState(() {
                  _messages.add(
                    _ChatMessage(
                      text: 'Maaf, terjadi kesalahan: ${state.message}',
                      role: _MessageRole.ai,
                    ),
                  );
                });
                _scrollToBottom();
              }
            },
          ),
          if (_historyBloc != null)
            BlocListener<ChatbotHistoryBloc, ChatbotHistoryState>(
              listener: (context, state) {
                if (state is ChatbotMessageLoaded) {
                  setState(() {
                    _messages.clear();
                    // Load berurutan kronologis dari list state.messages
                    for (var msg in state.messages) {
                      _messages.add(
                        _ChatMessage(
                          text: msg.question,
                          role: _MessageRole.user,
                        ),
                      );
                      _messages.add(
                        _ChatMessage(
                          text: msg.answer,
                          role: _MessageRole.ai,
                          sources:
                              msg.sources?.map((e) {
                                final mapData = e as Map<String, dynamic>;
                                return _ChatSource(
                                  id: mapData['id']?.toString() ?? '',
                                  title:
                                      mapData['title']?.toString() ??
                                      'Materi Rujukan',
                                  videoUrl:
                                      mapData['videoUrl']?.toString() ?? '',
                                  imageUrl:
                                      mapData['imageUrl']?.toString() ?? '',
                                );
                              }).toList() ??
                              [],
                        ),
                      );
                    }
                  });
                  _scrollToBottom();
                }
              },
            ),
        ],
        child: Scaffold(
          backgroundColor: ColorConstant.white,
          appBar: _buildAppBar(),
          body: _historyBloc != null
              ? BlocBuilder<ChatbotHistoryBloc, ChatbotHistoryState>(
                  builder: (context, state) {
                    if (state is ChatbotMessageLoading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: ColorConstant.primary,
                        ),
                      );
                    } else if (state is ChatbotMessageError) {
                      return Center(
                        child: Text(
                          state.message,
                          style: TextStyle(
                            fontFamily: FontConstant.robotoFontFamily,
                            color: ColorConstant.greyDark,
                          ),
                        ),
                      );
                    }
                    return _buildChatView();
                  },
                )
              : _buildChatView(),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: ColorConstant.primary,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
        onPressed: () => context.router.pop(),
      ),
      title: Text(
        'AI Assistant',
        style: TextStyle(
          fontSize: FontConstant.fontSize18,
          fontWeight: FontConstant.bold,
          color: ColorConstant.white,
          fontFamily: FontConstant.robotoFontFamily,
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      builder: (context, chatbotState) {
        final isLoading = chatbotState is ChatbotLoading;
        return SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  itemCount: _messages.length,
                  itemBuilder: (context, index) {
                    return _buildBubble(_messages[index], index, isLoading);
                  },
                ),
              ),
              _buildInputBar(isLoading),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBubble(_ChatMessage message, int index, bool isLoading) {
    final isUser = message.role == _MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * (isUser ? 0.7 : 0.85),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? ColorConstant.primaryLight : ColorConstant.greyLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUser)
              Text(
                message.text,
                style: TextStyle(
                  fontSize: FontConstant.fontSize14,
                  fontWeight: FontConstant.regular,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                  height: 1.4,
                ),
              )
            else
              MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    fontWeight: FontConstant.regular,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                    height: 1.4,
                  ),
                  strong: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    fontWeight: FontConstant.bold,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                    height: 1.4,
                  ),
                  listBullet: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    color: ColorConstant.black,
                  ),
                ),
              ),

            // Render Widget Indicator Loading saat posisi sedang menunggu jawaban BLoC
            if (!isUser && index == _messages.length - 1 && isLoading)
              const Padding(
                padding: EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    color: ColorConstant.primary,
                    strokeWidth: 2,
                  ),
                ),
              ),

            if (message.sources != null && message.sources!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(
                color: ColorConstant.greyDark.withOpacity(0.2),
                height: 1,
              ),
              const SizedBox(height: 12),
              Text(
                'Sumber materi terkait:',
                style: TextStyle(
                  fontSize: FontConstant.fontSize12,
                  fontWeight: FontConstant.bold,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
              ),
              const SizedBox(height: 8),
              ...message.sources!.map((source) => _buildSourceItem(source)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSourceItem(_ChatSource source) {
    return GestureDetector(
      onTap: () {
        context.router.push(IllnessMaterialRoute(materialId: source.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorConstant.greyLight, width: 1.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                source.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: ColorConstant.greyLight,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 20,
                    color: ColorConstant.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                source.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontConstant.fontSize12,
                  fontWeight: FontConstant.medium,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: ColorConstant.greyDark,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isLoading) {
    return Container(
      color: ColorConstant.white,
      padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 12),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              enabled: !isLoading,
              style: TextStyle(
                fontSize: FontConstant.fontSize14,
                fontFamily: FontConstant.robotoFontFamily,
                color: ColorConstant.black,
              ),
              decoration: InputDecoration(
                hintText: isLoading
                    ? 'AI sedang mengetik...'
                    : 'Ketik Pesan...',
                hintStyle: TextStyle(
                  fontSize: FontConstant.fontSize14,
                  color: ColorConstant.grey,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
                filled: true,
                fillColor: ColorConstant.fieldBackground,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: isLoading ? null : _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isLoading
                    ? ColorConstant.greyLight
                    : ColorConstant.primary,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.send_rounded,
                color: isLoading ? ColorConstant.grey : ColorConstant.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
