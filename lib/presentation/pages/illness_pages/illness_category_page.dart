import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/presentation/widgets/cards/illness_category_card.dart';

@RoutePage()
class IllnessCategoryPage extends StatelessWidget {
  const IllnessCategoryPage({super.key});

  static const _categories = [
    {
      'title': 'Penyakit Jantung',
      'description': 'Kumpulan penyakit yang mempengaruhi jantung.',
    },
    {
      'title': 'Diabetes',
      'description': 'Kumpulan penyakit yang mempengaruhi kadar gula darah.',
    },
    {
      'title': 'Penyakit Paru-paru',
      'description': 'Kumpulan penyakit yang mempengaruhi paru-paru.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        title: Text(
          'Kategori Penyakit',
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.white,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: _categories.length,
        separatorBuilder: (_, __) =>
            Divider(color: ColorConstant.greyLight, height: 1),
        itemBuilder: (context, index) {
          final category = _categories[index];
          return IllnessCategoryCard(
            title: category['title']!,
            description: category['description']!,
            // imageUrl: category['imageUrl']!,
            imageUrl: null,
            onTap: () {
              context.router.push(
                IllnessTypeRoute(categoryTitle: category['title']!),
              );
            },
          );
        },
      ),
    );
  }
}
