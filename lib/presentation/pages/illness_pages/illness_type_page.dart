import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/presentation/widgets/cards/illness_type_card.dart';

@RoutePage()
class IllnessTypePage extends StatefulWidget {
  final String categoryTitle;

  const IllnessTypePage({
    super.key,
    @PathParam('categoryTitle') required this.categoryTitle,
  });

  @override
  State<IllnessTypePage> createState() => _IllnessTypePageState();
}

class _IllnessTypePageState extends State<IllnessTypePage> {
  final Set<int> _bookmarkedIndexes = <int>{};

  // Nanti akan berasal dari BLoC/repository
  static const _illnesses = [
    {
      'title': 'Serangan Jantung',
      'description':
          'Terjadi ketika aliran darah ke bagian otot jantung terhambat, biasanya karena sumbatan di pembuluh darah jantung. Gejala umum meliputi nyeri dada yang menjalar ke lengan kiri, leher, rahang, atau punggung, sesak napas...',
      'imageUrl': null,
    },
    {
      'title': 'Gagal Jantung',
      'description':
          'Kondisi kronis di mana jantung tidak mampu memompa darah secara efektif untuk memenuhi kebutuhan tubuh. Gejala utama meliputi sesak napas, kelelahan, dan pembengkakan pada kaki...',
      'imageUrl': null,
    },
    {
      'title': 'Aritmia',
      'description':
          'Gangguan irama jantung yang menyebabkan jantung berdetak terlalu cepat, terlalu lambat, atau tidak teratur. Bisa menyebabkan palpitasi, pusing, hingga pingsan...',
      'imageUrl': null,
    },
  ];

  @override
  Widget build(BuildContext context) {
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
          widget.categoryTitle,
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
        itemCount: _illnesses.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final illness = _illnesses[index];
          return IllnessTypeCard(
            title: illness['title'] as String,
            description: illness['description'] as String,
            imageUrl: illness['imageUrl'],
            status: _bookmarkedIndexes.contains(index)
                ? IllnessTypeCardStatus.bookmarked
                : IllnessTypeCardStatus.none,
            onTap: () {
              // TODO: navigasi ke detail penyakit
            },
            onStatusTap: () {
              setState(() {
                if (!_bookmarkedIndexes.add(index)) {
                  _bookmarkedIndexes.remove(index);
                }
              });
            },
          );
        },
      ),
    );
  }
}
