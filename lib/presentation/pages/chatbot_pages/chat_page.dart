import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:topung_mobile/presentation/widgets/image/looping_gif_player.dart';

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

class _ChatImage {
  final String imageUrl;
  final String? imageCaption;

  const _ChatImage({required this.imageUrl, this.imageCaption});
}

class _ChatMessage {
  final String text;
  final _MessageRole role;
  final List<_ChatSource>? sources;
  final List<_ChatImage>? images;

  const _ChatMessage({
    required this.text,
    required this.role,
    this.sources,
    this.images,
  });
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

    if (widget.chatId != null && widget.chatId!.isNotEmpty) {
      _currentConversationId = widget.chatId;
      _historyBloc = ChatbotHistoryBloc(
        GetIt.instance<ChatbotHistoryUsecase>(),
      );
      _historyBloc!.add(
        GetChatbotHistoryByIdPaginationEvent(
          conversationId: _currentConversationId!,
          pageSize: 50,
        ),
      );
    } else {
      _currentConversationId = _uuid.v4();
      _messages.add(
        const _ChatMessage(
          text: 'Halo, ada yang bisa saya bantu hari ini?',
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
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOutCirc,
        );
      }
    });
  }

  void _handleError(String rawError) {
    String displayError =
        "Terjadi kesalahan saat memproses permintaan Anda. Silakan coba lagi.";
    if (rawError.contains("503") ||
        rawError.contains("Service Unavailable") ||
        rawError.contains("high demand")) {
      displayError =
          "Layanan AI sedang sibuk karena tingginya permintaan. Silakan coba beberapa saat lagi.";
    } else if (rawError.toLowerCase().contains("timeout") ||
        rawError.toLowerCase().contains("deadline")) {
      displayError =
          "Koneksi terputus atau waktu tunggu habis. Pastikan koneksi internet Anda stabil.";
    } else if (rawError.contains("SocketException")) {
      displayError =
          "Tidak ada koneksi internet. Silakan periksa jaringan Anda.";
    }

    String failedQuestion = "";
    setState(() {
      if (_messages.isNotEmpty && _messages.last.role == _MessageRole.user) {
        failedQuestion = _messages.last.text;
        _messages.removeLast();
      }
    });

    if (failedQuestion.isNotEmpty) {
      _messageController.text = failedQuestion;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Row(
            children: [
              const Icon(Icons.error_outline_rounded, color: Colors.red),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "Gagal Mengirim",
                  style: TextStyle(
                    fontWeight: FontConstant.bold,
                    fontSize: FontConstant.fontSize16,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            displayError,
            style: TextStyle(
              fontSize: FontConstant.fontSize14,
              fontFamily: FontConstant.robotoFontFamily,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                if (failedQuestion.isNotEmpty) {
                  _sendMessage();
                }
              },
              child: const Text("Coba Lagi",
                  style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
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

                  final mappedImages = state.response.images.map((e) {
                    final mapData = e as Map<String, dynamic>;
                    return _ChatImage(
                      imageUrl: mapData['imageUrl']?.toString() ?? '',
                      imageCaption: mapData['imageCaption']?.toString(),
                    );
                  }).toList();

                  _messages.add(
                    _ChatMessage(
                      text: state.response.answer,
                      role: _MessageRole.ai,
                      sources: mappedSources,
                      images: mappedImages,
                    ),
                  );
                });
                _scrollToBottom();
              } else if (state is ChatbotError) {
                _handleError(state.message);
              }
            },
          ),
          if (_historyBloc != null)
            BlocListener<ChatbotHistoryBloc, ChatbotHistoryState>(
              listener: (context, state) {
                if (state is ChatbotMessageLoaded) {
                  setState(() {
                    _messages.clear();
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
                          images:
                              msg.images?.map((e) {
                                final mapData = e as Map<String, dynamic>;
                                return _ChatImage(
                                  imageUrl:
                                      mapData['imageUrl']?.toString() ?? '',
                                  imageCaption: mapData['imageCaption']
                                      ?.toString(),
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
          backgroundColor: const Color(0xFFF8FAFB),
          appBar: _buildAppBar(),
          body: Stack(
            children: [
              _historyBloc != null
                  ? BlocBuilder<ChatbotHistoryBloc, ChatbotHistoryState>(
                      builder: (context, state) {
                        if (state is ChatbotMessageLoading) {
                          return const Center(
                            child: CircularProgressIndicator(
                              color: ColorConstant.primary,
                            ),
                          );
                        }
                        return _buildChatView();
                      },
                    )
                  : _buildChatView(),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: ColorConstant.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new_rounded,
          color: ColorConstant.black,
          size: 20,
        ),
        onPressed: () => context.router.pop(),
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: ColorConstant.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.psychology_outlined,
              color: ColorConstant.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Topung AI',
                style: TextStyle(
                  fontSize: FontConstant.fontSize16,
                  fontWeight: FontConstant.bold,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
              ),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Online',
                    style: TextStyle(
                      fontSize: FontConstant.fontSize12,
                      color: ColorConstant.greyDark,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.more_vert_rounded, color: ColorConstant.black),
          onPressed: () {},
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: ColorConstant.greyLight.withOpacity(0.5),
          height: 1,
        ),
      ),
    );
  }

  Widget _buildChatView() {
    return BlocBuilder<ChatbotBloc, ChatbotState>(
      builder: (context, chatbotState) {
        final isLoading = chatbotState is ChatbotLoading;
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                itemCount: _messages.length + (isLoading ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _messages.length) {
                    return _buildThinkingBubble();
                  }
                  return _buildAnimatedBubble(
                    _messages[index],
                    index,
                    isLoading,
                  );
                },
              ),
            ),
            _buildFloatingInputBar(isLoading),
          ],
        );
      },
    );
  }

  Widget _buildThinkingBubble() {
    return _buildAnimatedBubble(
      const _ChatMessage(text: "", role: _MessageRole.ai),
      999, // Unique key for thinking bubble
      true,
    );
  }

  Widget _buildAnimatedBubble(_ChatMessage message, int index, bool isLoading) {
    bool isThinking = index == 999;
    return TweenAnimationBuilder<double>(
      key: ValueKey(isThinking ? 'thinking' : 'msg_$index'),
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuart,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 20 * (1 - value)),
            child: child,
          ),
        );
      },
      child: isThinking
          ? _buildThinkingContent()
          : _buildBubble(message, index, isLoading),
    );
  }

  Widget _buildThinkingContent() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: ColorConstant.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(20),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: ColorConstant.greyLight.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: const _ThinkingIndicator(),
        ),
      ),
    );
  }

  Widget _buildBubble(_ChatMessage message, int index, bool isLoading) {
    final isUser = message.role == _MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: isUser
              ? CrossAxisAlignment.end
              : CrossAxisAlignment.start,
          children: [
            if (!isUser && message.images != null && message.images!.isNotEmpty)
              ...message.images!.map(
                (img) => Padding(
                  padding: const EdgeInsets.only(bottom: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: img.imageUrl.toLowerCase().endsWith('.gif')
                            ? LoopingGifPlayer(
                                gifUrl: img.imageUrl,
                                fit: BoxFit.contain,
                              )
                            : CachedNetworkImage(
                                imageUrl: img.imageUrl,
                                width: double.infinity,
                                fit: BoxFit.contain,
                                memCacheWidth: 400,
                                errorWidget: (context, url, error) => Container(
                                  width: double.infinity,
                                  height: 150,
                                  color: ColorConstant.greyLight,
                                  child: const Icon(
                                    Icons.image_rounded,
                                    color: ColorConstant.grey,
                                    size: 40,
                                  ),
                                ),
                                placeholder: (context, url) => Container(
                                  width: double.infinity,
                                  height: 150,
                                  color: ColorConstant.greyLight,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: ColorConstant.primary,
                                    ),
                                  ),
                                ),
                              ),
                      ),
                      if (img.imageCaption != null &&
                          img.imageCaption!.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          img.imageCaption!,
                          style: TextStyle(
                            fontSize: FontConstant.fontSize12,
                            color: ColorConstant.greyDark,
                            fontStyle: FontStyle.italic,
                            fontFamily: FontConstant.robotoFontFamily,
                          ),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            Container(
              width: isUser ? null : double.infinity,
              constraints: BoxConstraints(
                maxWidth: isUser
                    ? MediaQuery.of(context).size.width * 0.8
                    : double.infinity,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
                color: isUser ? null : ColorConstant.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isUser ? 20 : 4),
                  bottomRight: Radius.circular(isUser ? 4 : 20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: isUser
                    ? null
                    : Border.all(
                        color: ColorConstant.greyLight.withOpacity(0.5),
                        width: 1,
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
                        color: ColorConstant.white,
                        fontFamily: FontConstant.robotoFontFamily,
                        height: 1.5,
                      ),
                    )
                  else
                    MarkdownBody(
                      data: message.text.replaceAllMapped(
                        RegExp(r'([a-z][\)\]\.\?!])([A-Z])'),
                        (m) => '${m[1]}\n\n${m[2]}',
                      ),
                      styleSheet: MarkdownStyleSheet(
                        p: TextStyle(
                          fontSize: FontConstant.fontSize14,
                          color: ColorConstant.black,
                          fontFamily: FontConstant.robotoFontFamily,
                          height: 1.5,
                        ),
                        h1: TextStyle(
                          fontSize: FontConstant.fontSize16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.black,
                          fontFamily: FontConstant.robotoFontFamily,
                          height: 1.5,
                        ),
                        h2: TextStyle(
                          fontSize: FontConstant.fontSize16,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.black,
                          fontFamily: FontConstant.robotoFontFamily,
                          height: 1.5,
                        ),
                        h3: TextStyle(
                          fontSize: FontConstant.fontSize14,
                          fontWeight: FontWeight.bold,
                          color: ColorConstant.black,
                          fontFamily: FontConstant.robotoFontFamily,
                          height: 1.5,
                        ),
                        strong: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
            ),
            if (message.sources != null && message.sources!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildSourceList(message.sources!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSourceList(List<_ChatSource> sources) {
    return Column(
      children: sources
          .map((source) => _buildPremiumSourceCard(source))
          .toList(),
    );
  }

  Widget _buildPremiumSourceCard(_ChatSource source) {
    return GestureDetector(
      onTap: () =>
          context.router.push(IllnessMaterialRoute(materialId: source.id)),
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: ColorConstant.primary.withOpacity(0.1)),
          boxShadow: [
            BoxShadow(
              color: ColorConstant.primary.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: RepaintBoundary(
                child: Image.network(
                  source.imageUrl,
                  key: ValueKey(source.imageUrl),
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 60,
                    height: 60,
                    color: ColorConstant.greyLight,
                    child: const Icon(
                      Icons.image_rounded,
                      color: ColorConstant.grey,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    source.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: FontConstant.fontSize12,
                      fontWeight: FontConstant.bold,
                      color: ColorConstant.black,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Baca Materi →',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: ColorConstant.primary,
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

  Widget _buildFloatingInputBar(bool isLoading) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      color: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _messageController,
                focusNode: _focusNode,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _sendMessage(),
                enabled: !isLoading,
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: isLoading
                      ? 'Topung sedang mengetik...'
                      : 'Ketik sesuatu...',
                  hintStyle: TextStyle(
                    color: ColorConstant.greyDark.withOpacity(0.6),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: isLoading ? null : _sendMessage,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00BCD4), Color(0xFF0097A7)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    if (!isLoading)
                      BoxShadow(
                        color: ColorConstant.primary.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                  ],
                ),
                child: Icon(
                  isLoading
                      ? Icons.hourglass_empty_rounded
                      : Icons.send_rounded,
                  color: ColorConstant.white,
                  size: 20,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThinkingIndicator extends StatefulWidget {
  const _ThinkingIndicator();

  @override
  State<_ThinkingIndicator> createState() => _ThinkingIndicatorState();
}

class _ThinkingIndicatorState extends State<_ThinkingIndicator>
    with TickerProviderStateMixin {
  final List<String> _thinkingTexts = [
    "Mendeteksi gejala yang ditanyakan...",
    "Menemukan kondisi terkait...",
    "Mencari materi dari penyakit...",
    "Menyusun jawaban...",
  ];

  int _currentTextIndex = 0;
  late Timer _timer;
  late AnimationController _dotController;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (mounted) {
        setState(() {
          _currentTextIndex = (_currentTextIndex + 1) % _thinkingTexts.length;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _dotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            return AnimatedBuilder(
              animation: _dotController,
              builder: (context, child) {
                double offset = index * 0.2;
                double value = (_dotController.value + offset) % 1.0;
                double opacity =
                    0.3 + (math.sin(value * math.pi * 2) + 1) / 2 * 0.7;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: ColorConstant.primary
                        .withOpacity(opacity.clamp(0.3, 1.0)),
                    shape: BoxShape.circle,
                  ),
                );
              },
            );
          }),
        ),
        const SizedBox(width: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            _thinkingTexts[_currentTextIndex],
            key: ValueKey<int>(_currentTextIndex),
            style: TextStyle(
              fontSize: FontConstant.fontSize12,
              color: ColorConstant.greyDark,
              fontStyle: FontStyle.italic,
              fontFamily: FontConstant.robotoFontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
