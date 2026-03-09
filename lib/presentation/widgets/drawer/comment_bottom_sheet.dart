import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';

class CommentItem {
  final String username;
  final String comment;
  final String timeAgo;
  final bool isReply;

  const CommentItem({
    required this.username,
    required this.comment,
    required this.timeAgo,
    this.isReply = false,
  });
}

class CommentBottomSheet extends StatefulWidget {
  final List<CommentItem> comments;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final void Function(String comment)? onSend;

  const CommentBottomSheet({
    super.key,
    this.comments = const [],
    this.initialChildSize = 0.6,
    this.minChildSize = 0.4,
    this.maxChildSize = 0.9,
    this.onSend,
  });

  static void show(
    BuildContext context, {
    List<CommentItem> comments = const [],
    double initialChildSize = 0.6,
    double minChildSize = 0.4,
    double maxChildSize = 0.9,
    void Function(String)? onSend,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => CommentBottomSheet(
        comments: comments,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        onSend: onSend,
      ),
    );
  }

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text);
    _commentController.clear();
    _focusNode.unfocus();
  }

  void _handleReply(String username) {
    _commentController.text = '@$username ';
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _commentController.text.length),
    );
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: ColorConstant.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Komentar',
                      style: TextStyle(
                        fontSize: FontConstant.fontSize18,
                        fontWeight: FontConstant.bold,
                        color: ColorConstant.black,
                        fontFamily: FontConstant.robotoFontFamily,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        color: ColorConstant.greyDark,
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),
              // Comment list
              Expanded(
                child: widget.comments.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada komentar',
                          style: TextStyle(
                            fontSize: FontConstant.fontSize14,
                            color: ColorConstant.grey,
                            fontFamily: FontConstant.robotoFontFamily,
                          ),
                        ),
                      )
                    : ListView.builder(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        itemCount: widget.comments.length,
                        itemBuilder: (context, index) {
                          return _CommentTile(
                            item: widget.comments[index],
                            onReply: () =>
                                _handleReply(widget.comments[index].username),
                          );
                        },
                      ),
              ),
              // Input area
              const Divider(height: 1),
              Padding(
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
                        controller: _commentController,
                        focusNode: _focusNode,
                        style: TextStyle(
                          fontSize: FontConstant.fontSize14,
                          fontFamily: FontConstant.robotoFontFamily,
                          color: ColorConstant.black,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Ketik Komentar',
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
                        onSubmitted: (_) => _handleSend(),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _handleSend,
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
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentItem item;
  final VoidCallback? onReply;

  const _CommentTile({required this.item, this.onReply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 10,
        bottom: 10,
        left: item.isReply ? 52 : 0, // menjorok jika reply
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: item.isReply ? 16 : 20,
            backgroundColor: ColorConstant.greyLight,
            child: Icon(
              Icons.person,
              color: ColorConstant.grey,
              size: item.isReply ? 18 : 24,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.username,
                  style: TextStyle(
                    fontSize: FontConstant.fontSize12,
                    fontWeight: FontConstant.medium,
                    color: ColorConstant.grey,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.comment,
                  style: TextStyle(
                    fontSize: FontConstant.fontSize16,
                    fontWeight: FontConstant.regular,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      item.timeAgo,
                      style: TextStyle(
                        fontSize: FontConstant.fontSize12,
                        color: ColorConstant.grey,
                        fontFamily: FontConstant.robotoFontFamily,
                      ),
                    ),
                    const SizedBox(width: 12),
                    GestureDetector(
                      onTap: onReply, // <-- pakai callback
                      child: Text(
                        'Reply',
                        style: TextStyle(
                          fontSize: FontConstant.fontSize12,
                          color: ColorConstant.grey,
                          fontWeight: FontConstant.medium,
                          fontFamily: FontConstant.robotoFontFamily,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
