import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';
import 'package:topung_mobile/presentation/widgets/cards/chat_history_card.dart';

@RoutePage()
class ChatHistoryPage extends StatelessWidget {
  const ChatHistoryPage({super.key});

  // Nanti akan berasal dari BLoC/repository
  static const _histories = [
    {
      'title': 'Bagaimana cara mengatasi sakit ke...',
      'subtitle': 'Teknik ini didasarkan pada teori mengenai titik-tit...',
    },
    {'title': 'Pertanyaan pertama', 'subtitle': 'Jawaban pertama chatbot'},
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
          'Chat History',
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.white,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
      ),
      body: _histories.isEmpty
          ? Center(
              child: Text(
                'Belum ada riwayat chat',
                style: TextStyle(
                  fontSize: FontConstant.fontSize14,
                  color: ColorConstant.grey,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: _histories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final history = _histories[index];
                return ChatHistoryCard(
                  title: history['title']!,
                  subtitle: history['subtitle']!,
                  onTap: () {},
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.router.push(ChatRoute());
        },
        backgroundColor: ColorConstant.primaryLight,
        elevation: 2,
        child: const Icon(
          Icons.chat_bubble_outline_rounded,
          color: ColorConstant.primary,
        ),
      ),
    );
  }
}
