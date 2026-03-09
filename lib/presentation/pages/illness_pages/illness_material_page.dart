import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

@RoutePage()
class IllnessMaterialPage extends StatefulWidget {
  final String illnessName;
  final String materialTitle;
  final String? youtubeUrl;
  final String? imageUrl;
  final String content;

  const IllnessMaterialPage({
    super.key,
    required this.illnessName,
    required this.materialTitle,
    this.youtubeUrl,
    this.imageUrl,
    required this.content,
  });

  @override
  State<IllnessMaterialPage> createState() => _IllnessMaterialPageState();
}

class _IllnessMaterialPageState extends State<IllnessMaterialPage> {
  YoutubePlayerController? _youtubeController;
  bool _isLiked = false;
  bool _isDisliked = false;

  @override
  void initState() {
    super.initState();
    final videoId = YoutubePlayer.convertUrlToId(widget.youtubeUrl ?? '');
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (context, scrollController) => Column(
          children: [
            const SizedBox(height: 12),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: ColorConstant.greyLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Komentar',
              style: TextStyle(
                fontSize: FontConstant.fontSize16,
                fontWeight: FontConstant.bold,
                color: ColorConstant.black,
                fontFamily: FontConstant.robotoFontFamily,
              ),
            ),
            const Divider(),
            Expanded(
              child: Center(
                child: Text(
                  'Belum ada komentar',
                  style: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    color: ColorConstant.grey,
                    fontFamily: FontConstant.robotoFontFamily,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
                onPressed: () => context.router.pop(),
              ),
              title: Text(
                widget.illnessName,
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
                player, // fixed di atas, tidak ikut scroll
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildTitleRow(),
                        Divider(color: ColorConstant.greyLight, height: 32),
                        if (widget.imageUrl != null) ...[
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

    // Fallback tanpa video — placeholder fixed, konten scrollable
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstant.white),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          widget.illnessName,
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
          _buildVideoSection(), // placeholder fixed di atas
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleRow(),
                  Divider(color: ColorConstant.greyLight, height: 32),
                  if (widget.imageUrl != null) ...[
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
    // Hanya ditampilkan jika tidak ada youtubeController (placeholder)
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
            widget.materialTitle,
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
        widget.imageUrl!,
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
    return Text(
      widget.content,
      style: TextStyle(
        fontSize: FontConstant.fontSize14,
        fontWeight: FontConstant.regular,
        color: ColorConstant.greyDark,
        fontFamily: FontConstant.robotoFontFamily,
        height: 1.6,
      ),
      textAlign: TextAlign.justify,
    );
  }
}
