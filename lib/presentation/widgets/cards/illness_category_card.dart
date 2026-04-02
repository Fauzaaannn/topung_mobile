import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';

class IllnessCategoryCard extends StatelessWidget {
  final String title;
  final String description;
  final String? imageUrl;
  final VoidCallback? onTap;

  const IllnessCategoryCard({
    super.key,
    required this.title,
    required this.description,
    this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl != null
                  ? Image.network(
                      imageUrl!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: FontConstant.fontSize18,
                      fontWeight: FontConstant.bold,
                      color: ColorConstant.black,
                      fontFamily: FontConstant.robotoFontFamily,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: FontConstant.fontSize14,
                      fontWeight: FontConstant.regular,
                      color: ColorConstant.greyDark,
                      fontFamily: FontConstant.robotoFontFamily,
                      height: 1.4,
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

  Widget _placeholder() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: ColorConstant.greyLight,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}
