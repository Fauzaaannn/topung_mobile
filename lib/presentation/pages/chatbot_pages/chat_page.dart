import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';

enum _MessageRole { user, ai }

class _ChatMessage {
  final String text;
  final _MessageRole role;

  const _ChatMessage({required this.text, required this.role});
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

  // Nanti akan berasal dari BLoC/repository
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Halo, ada yang bisa saya bantu?',
      role: _MessageRole.ai,
    ),
    const _ChatMessage(
      text: 'Apa itu serangan jantung?',
      role: _MessageRole.user,
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, role: _MessageRole.user));
      _messageController.clear();
    });

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstant.black),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'AI Assistant',
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.black,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildBubble(_messages[index]);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMessage message) {
    final isUser = message.role == _MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
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
        child: Text(
          message.text,
          style: TextStyle(
            fontSize: FontConstant.fontSize14,
            fontWeight: FontConstant.regular,
            color: ColorConstant.black,
            fontFamily: FontConstant.robotoFontFamily,
            height: 1.4,
          ),
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: ColorConstant.white,
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              focusNode: _focusNode,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(
                fontSize: FontConstant.fontSize14,
                fontFamily: FontConstant.robotoFontFamily,
                color: ColorConstant.black,
              ),
              decoration: InputDecoration(
                hintText: 'Ketik Pesan...',
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
            onTap: _sendMessage,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: ColorConstant.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.send_rounded,
                color: ColorConstant.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
