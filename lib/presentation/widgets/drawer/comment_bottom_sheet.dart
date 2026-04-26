import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/data/model/interaction_model/interaction_model.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_bloc.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_state.dart';
import 'package:topung_mobile/presentation/bloc/interaction_bloc/interaction_event.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';

class CommentItem {
  final String id;
  final String username;
  final String comment;
  final String timeAgo;
  final bool isReply;

  const CommentItem({
    required this.id,
    required this.username,
    required this.comment,
    required this.timeAgo,
    this.isReply = false,
  });
}

class CommentBottomSheet extends StatefulWidget {
  final String? materialId;
  final List<CommentItem> comments;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;
  final void Function(String comment, String? parentCommentId)? onSend;

  const CommentBottomSheet({
    super.key,
    this.materialId,
    this.comments = const [],
    this.initialChildSize = 0.6,
    this.minChildSize = 0.4,
    this.maxChildSize = 0.9,
    this.onSend,
  });

  static void show(
    BuildContext context, {
    required String materialId,
    double initialChildSize = 0.6,
    double minChildSize = 0.4,
    double maxChildSize = 0.9,
  }) {
    final interactionBloc = context.read<InteractionBloc>();
    interactionBloc.add(GetCommentsEvent(materialId: materialId));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BlocProvider.value(
        value: interactionBloc,
        child: CommentBottomSheet(
          materialId: materialId,
          initialChildSize: initialChildSize,
          minChildSize: minChildSize,
          maxChildSize: maxChildSize,
          onSend: (text, parentCommentId) {
            interactionBloc.add(
              AddCommentEvent(
                materialId: materialId,
                content: text,
                parentCommentId: parentCommentId,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  State<CommentBottomSheet> createState() => _CommentBottomSheetState();
}

class _CommentBottomSheetState extends State<CommentBottomSheet> {
  final _commentController = TextEditingController();
  final _focusNode = FocusNode();
  String? _replyingToId;
  String? _replyingToUser;

  @override
  void dispose() {
    _commentController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _handleSend() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    widget.onSend?.call(text, _replyingToId);
    _commentController.clear();
    _focusNode.unfocus();
    setState(() {
      _replyingToId = null;
      _replyingToUser = null;
    });
  }

  void _handleReply(String commentId, String username) {
    setState(() {
      _replyingToId = commentId;
      _replyingToUser = username;
    });
    _commentController.text = '@$username ';
    _commentController.selection = TextSelection.fromPosition(
      TextPosition(offset: _commentController.text.length),
    );
    _focusNode.requestFocus();
  }

  void _onScroll() {
    final scrollController = _currentScrollController;
    if (scrollController == null) return;

    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent * 0.8) {
      final state = context.read<InteractionBloc>().state;
      if (state is CommentsLoaded &&
          !state.hasReachedMax &&
          !state.isLoadingMore) {
        context.read<InteractionBloc>().add(
          GetCommentsEvent(
            materialId: widget.materialId ?? '', // Need materialId
            page: state.currentPage + 1,
          ),
        );
      }
    }
  }

  ScrollController? _currentScrollController;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: widget.initialChildSize,
      minChildSize: widget.minChildSize,
      maxChildSize: widget.maxChildSize,
      expand: false,
      builder: (context, scrollController) {
        if (_currentScrollController != scrollController) {
          _currentScrollController?.removeListener(_onScroll);
          _currentScrollController = scrollController;
          _currentScrollController?.addListener(_onScroll);
        }
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
                child: BlocBuilder<InteractionBloc, InteractionState>(
                  builder: (context, state) {
                    if (state is CommentsLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    List<CommentItem> items = [];
                    bool hasReachedMax = true;
                    bool isLoadingMore = false;

                    if (state is CommentsLoaded) {
                      hasReachedMax = state.hasReachedMax;
                      isLoadingMore = state.isLoadingMore;

                      // 1. Pisahkan root comments dan replies
                      final allComments = state.comments;
                      final rootComments = allComments
                          .where((c) => c.parentCommentId == null)
                          .toList();
                      final replies = allComments
                          .where((c) => c.parentCommentId != null)
                          .toList();

                      // 2. Susun ulang: Root diikuti oleh semua keturunannya (flat)
                      final List<CommentModel> sortedList = [];
                      final Map<String, List<CommentModel>> parentToChildren =
                          {};

                      for (var c in allComments) {
                        if (c.parentCommentId != null) {
                          parentToChildren
                              .putIfAbsent(c.parentCommentId!, () => [])
                              .add(c);
                        }
                      }

                      // Fungsi untuk mengambil semua keturunan secara rekursif
                      void addDescendants(String parentId) {
                        final children = parentToChildren[parentId] ?? [];
                        // Urutkan anak berdasarkan waktu (terlama ke terbaru)
                        children.sort(
                          (a, b) => a.createdAt.compareTo(b.createdAt),
                        );

                        for (var child in children) {
                          if (!sortedList.contains(child)) {
                            sortedList.add(child);
                            addDescendants(
                              child.id,
                            ); // Rekursi untuk mencari cucu, dst
                          }
                        }
                      }

                      for (var root in rootComments) {
                        sortedList.add(root);
                        addDescendants(root.id);
                      }

                      // Tambahkan komentar yang mungkin "yatim" (induknya tidak ada di list karena pagination)
                      for (var c in allComments) {
                        if (!sortedList.contains(c)) {
                          sortedList.add(c);
                        }
                      }

                      items = sortedList
                          .map(
                            (e) => CommentItem(
                              id: e.id,
                              username: e.user?['name'] ?? 'User',
                              comment: e.content,
                              timeAgo: _formatDate(e.createdAt),
                              isReply: e.parentCommentId != null,
                            ),
                          )
                          .toList();
                    }

                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'Belum ada komentar',
                          style: TextStyle(
                            fontSize: FontConstant.fontSize14,
                            color: ColorConstant.grey,
                            fontFamily: FontConstant.robotoFontFamily,
                          ),
                        ),
                      );
                    }

                    return ListView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 16,
                      ),
                      itemCount: items.length + (hasReachedMax ? 0 : 1),
                      itemBuilder: (context, index) {
                        if (index == items.length) {
                          return isLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        }
                        return _CommentTile(
                          item: items[index],
                          onReply: () => _handleReply(
                            items[index].id,
                            items[index].username,
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              // Input area
              if (_replyingToUser != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  color: ColorConstant.fieldBackground,
                  child: Row(
                    children: [
                      Text(
                        'Replying to @$_replyingToUser',
                        style: TextStyle(
                          fontSize: FontConstant.fontSize12,
                          color: ColorConstant.greyDark,
                        ),
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () => setState(() {
                          _replyingToId = null;
                          _replyingToUser = null;
                        }),
                        child: const Icon(
                          Icons.cancel,
                          size: 16,
                          color: ColorConstant.grey,
                        ),
                      ),
                    ],
                  ),
                ),
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
              BlocListener<InteractionBloc, InteractionState>(
                listener: (context, state) {
                  if (state is AddCommentSuccess) {
                    context.read<InteractionBloc>().add(
                      GetCommentsEvent(materialId: state.comment.materialId),
                    );
                  }
                },
                child: const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inDays > 0) return '${diff.inDays}d';
      if (diff.inHours > 0) return '${diff.inHours}h';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m';
      return 'just now';
    } catch (_) {
      return 'recently';
    }
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
