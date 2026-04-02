import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

enum IllnessTypeCardStatus { none, bookmarked, completed }

class IllnessTypeCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final IllnessTypeCardStatus status;
  final VoidCallback? onTap;
  final VoidCallback? onStatusTap;
  final double imageWidth;
  final double imageHeight;

  const IllnessTypeCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.status = IllnessTypeCardStatus.none,
    this.onTap,
    this.onStatusTap,
    this.imageWidth = 80,
    this.imageHeight = 80,
  });
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: imageWidth,
                      height: imageHeight,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: FontConstant.fontSize18,
                      fontWeight: FontConstant.bold,
                      color: ColorConstant.black,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                  const SizedBox(height: 6),
                  SizedBox(
                    height: 54, // Maksimal 3 baris (12 * 1.5 * 3)
                    child: ShaderMask(
                      shaderCallback: (Rect bounds) {
                        return LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Colors.white.withOpacity(0.0)],
                          stops: const [0.7, 1.0],
                        ).createShader(bounds);
                      },
                      blendMode: BlendMode.dstIn,
                      child: SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: MarkdownBody(
                          data: description,
                          styleSheet: MarkdownStyleSheet(
                            p: TextStyle(
                              fontSize: FontConstant.fontSize12,
                              fontWeight: FontConstant.regular,
                              color: ColorConstant.greyDark,
                              fontFamily: FontConstant.robotoFontFamily,
                              height: 1.5,
                            ),
                            pPadding: EdgeInsets.zero,
                            listIndent: 12,
                            listBulletPadding: const EdgeInsets.only(right: 4),
                            strong: TextStyle(
                              fontSize: FontConstant.fontSize12,
                              fontWeight: FontConstant.bold,
                              color: ColorConstant.greyDark,
                              fontFamily: FontConstant.robotoFontFamily,
                              height: 1.5,
                            ),
                            listBullet: TextStyle(
                              fontSize: FontConstant.fontSize12,
                              color: ColorConstant.greyDark,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(onTap: onStatusTap, child: _buildStatusIcon()),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusIcon() {
    switch (status) {
      case IllnessTypeCardStatus.bookmarked:
        return Icon(Icons.bookmark, color: ColorConstant.primary, size: 24);
      case IllnessTypeCardStatus.completed:
        return Icon(
          Icons.check_circle_outline,
          color: ColorConstant.primary,
          size: 24,
        );
      case IllnessTypeCardStatus.none:
        return Icon(
          Icons.bookmark_border,
          color: ColorConstant.primary,
          size: 24,
        );
    }
  }

  Widget _placeholder() {
    return Container(
      width: imageWidth,
      height: imageHeight,
      decoration: BoxDecoration(
        color: ColorConstant.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
