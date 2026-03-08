import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/presentation/widgets/cards/illness_category_card.dart';

@RoutePage()
class IllnessCategoryPage extends StatelessWidget {
  const IllnessCategoryPage({super.key});

  // Nanti ini akan berasal dari BLoC/provider/repository
  static const _categories = [
    {
      'title': 'Penyakit Jantung',
      'description': 'Kumpulan penyakit yang mempengaruhi jantung.',
      'imageUrl':
          'https://images.unsplash.com/photo-1588776814546-1c9b8e5f1a2c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Diabetes',
      'description': 'Kumpulan penyakit yang mempengaruhi kadar gula darah.',
      'imageUrl':
          'https://images.unsplash.com/photo-1588776814546-1c9b8e5f1a2c?auto=format&fit=crop&w=800&q=80',
    },
    {
      'title': 'Penyakit Paru-paru',
      'description': 'Kumpulan penyakit yang mempengaruhi paru-paru.',
      'imageUrl':
          'https://images.unsplash.com/photo-1588776814546-1c9b8e5f1a2c?auto=format&fit=crop&w=800&q=80',
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
            imageUrl: category['imageUrl']!,
            onTap: () {
              // Navigate to detail page
            },
          );
        },
      ),
    );
  }
}
