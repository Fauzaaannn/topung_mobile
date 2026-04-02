import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/modules/app_module.dart';
import 'package:topung_mobile/data/model/illness_model/illness_material_model.dart';
import 'package:topung_mobile/domain/usecases/illness_material_usecases/illness_get_material_usecase.dart';
import 'package:topung_mobile/presentation/bloc/illness_material_bloc.dart/illness_material_bloc.dart';
import 'package:topung_mobile/presentation/widgets/drawer/comment_bottom_sheet.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

@RoutePage()
class IllnessMaterialPage extends StatelessWidget {
  const IllnessMaterialPage({super.key, required this.materialId});

  final String materialId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => IllnessMaterialBloc(
        illnessGetMaterialUsecase: serviceLocator<IllnessGetMaterialUsecase>(),
      )..add(IllnessMaterialFetched(materialId: materialId)),
      child: const _IllnessMaterialView(),
    );
  }
}

class _IllnessMaterialView extends StatelessWidget {
  const _IllnessMaterialView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IllnessMaterialBloc, IllnessMaterialState>(
      builder: (context, state) {
        if (state is IllnessMaterialLoading ||
            state is IllnessMaterialInitial) {
          return Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: AppBar(
              backgroundColor: ColorConstant.primary,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is IllnessMaterialFailure) {
          return Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: AppBar(
              backgroundColor: ColorConstant.primary,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    state.message,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: ColorConstant.black,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<IllnessMaterialBloc>().add(
                      IllnessMaterialFetched(
                        materialId:
                            context.read<IllnessMaterialBloc>().state
                                is IllnessMaterialFailure
                            ? (context.read<IllnessMaterialBloc>().state
                                      as IllnessMaterialFailure)
                                  .message
                            : '',
                      ),
                    ),
                    child: const Text('Coba Lagi'),
                  ),
                ],
              ),
            ),
          );
        }

        final data = (state as IllnessMaterialSuccess).data;
        return _IllnessMaterialContent(data: data);
      },
    );
  }
}

class _IllnessMaterialContent extends StatefulWidget {
  const _IllnessMaterialContent({required this.data});

  final IllnessMaterialModel data;

  @override
  State<_IllnessMaterialContent> createState() =>
      _IllnessMaterialContentState();
}

class _IllnessMaterialContentState extends State<_IllnessMaterialContent> {
  YoutubePlayerController? _youtubeController;
  bool _isLiked = false;
  bool _isDisliked = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.data.videoUrl);
    if (videoId != null) {
      _youtubeController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          enableCaption: false,
        ),
      );
    }
  }

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  void _showCommentBottomSheet() {
    CommentBottomSheet.show(
      context,
      initialChildSize: 0.65,
      comments: const [
        CommentItem(
          username: 'Nama Pengguna',
          comment: 'Komentar dari pengguna',
          timeAgo: '10s',
        ),
        CommentItem(
          username: 'Nama Pengguna',
          comment: 'Komentar dari pengguna',
          timeAgo: '10s',
        ),
        CommentItem(
          username: 'Nama Pengguna',
          comment: 'Komentar dari pengguna',
          timeAgo: '10s',
          isReply: true,
        ),
      ],
      onSend: (text) {
        // TODO: kirim komentar
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_youtubeController != null) {
      return YoutubePlayerBuilder(
        player: YoutubePlayer(
          controller: _youtubeController!,
          showVideoProgressIndicator: true,
          progressIndicatorColor: ColorConstant.primary,
          progressColors: ProgressBarColors(
            playedColor: ColorConstant.primary,
            handleColor: ColorConstant.primaryMedium3,
          ),
        ),
        builder: (context, player) {
          return Scaffold(
            backgroundColor: ColorConstant.white,
            appBar: AppBar(
              backgroundColor: ColorConstant.primary,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                widget.data.title,
                style: TextStyle(
                  fontSize: FontConstant.fontSize18,
                  fontWeight: FontConstant.bold,
                  color: ColorConstant.white,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
              ),
            ),
            body: Column(
              children: [
                player,
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleRow(),
                        Divider(color: ColorConstant.greyLight, height: 32),
                        if (widget.data.imageUrl.isNotEmpty) ...[
                          _buildImage(),
                          const SizedBox(height: 16),
                        ],
                        _buildContent(),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    }

    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          widget.data.title,
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.white,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
      ),
      body: Column(
        children: [
          _buildVideoSection(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(),
                  Divider(color: ColorConstant.greyLight, height: 32),
                  if (widget.data.imageUrl.isNotEmpty) ...[
                    _buildImage(),
                    const SizedBox(height: 16),
                  ],
                  _buildContent(),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoSection() {
    return Container(
      height: 220,
      color: ColorConstant.greyLight,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white,
                size: 36,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Video embed dari youtube',
              style: TextStyle(
                fontSize: FontConstant.fontSize14,
                color: ColorConstant.greyDark,
                fontFamily: FontConstant.robotoFontFamily,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleRow() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            widget.data.title,
            style: TextStyle(
              fontSize: FontConstant.fontSize18,
              fontWeight: FontConstant.bold,
              color: ColorConstant.black,
              fontFamily: FontConstant.robotoFontFamily,
              height: 1.3,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () => setState(() {
                _isLiked = !_isLiked;
                if (_isLiked) _isDisliked = false;
              }),
              child: Icon(
                _isLiked ? Icons.thumb_up : Icons.thumb_up_outlined,
                color: _isLiked ? ColorConstant.primary : ColorConstant.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () => setState(() {
                _isDisliked = !_isDisliked;
                if (_isDisliked) _isLiked = false;
              }),
              child: Icon(
                _isDisliked ? Icons.thumb_down : Icons.thumb_down_outlined,
                color: _isDisliked ? ColorConstant.primary : ColorConstant.grey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: _showCommentBottomSheet,
              child: Icon(
                Icons.chat_bubble_outline,
                color: ColorConstant.grey,
                size: 22,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: ColorConstant.greyLight, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      clipBehavior: Clip.hardEdge,
      child: Image.network(
        widget.data.imageUrl,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Container(
          height: 200,
          color: ColorConstant.greyLight,
          child: Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: ColorConstant.grey,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return MarkdownBody(
      data: widget.data.textContent,
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          fontSize: FontConstant.fontSize14,
          fontWeight: FontConstant.regular,
          color: ColorConstant.greyDark,
          fontFamily: FontConstant.robotoFontFamily,
          height: 1.6,
        ),
        strong: TextStyle(
          fontSize: FontConstant.fontSize14,
          fontWeight: FontConstant.bold,
          color: ColorConstant.greyDark,
          fontFamily: FontConstant.robotoFontFamily,
          height: 1.6,
        ),
        listBullet: TextStyle(
          fontSize: FontConstant.fontSize14,
          color: ColorConstant.greyDark,
        ),
      ),
    );
  }
}
