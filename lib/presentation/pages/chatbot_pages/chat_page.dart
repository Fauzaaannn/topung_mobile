import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';
import 'package:topung_mobile/core/app_theme/font_constant.dart';
import 'package:topung_mobile/core/routing/app_route_service.gr.dart';

enum _MessageRole { user, ai }

class _ChatSource {
  final String id;
  final String title;
  final String videoUrl;
  final String imageUrl;

  const _ChatSource({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.imageUrl,
  });
}

class _ChatMessage {
  final String text;
  final _MessageRole role;
  final List<_ChatSource>? sources;

  const _ChatMessage({required this.text, required this.role, this.sources});
}

@RoutePage()
class ChatPage extends StatefulWidget {
  final String? chatId;

  const ChatPage({super.key, this.chatId});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  final _focusNode = FocusNode();

  // Nanti akan berasal dari BLoC/repository
  final List<_ChatMessage> _messages = [
    const _ChatMessage(
      text: 'Halo, ada yang bisa saya bantu?',
      role: _MessageRole.ai,
    ),
    const _ChatMessage(
      text:
          'Bagaimana cara melakukan General Treatment totok punggung menurut Ustadz Abdurrahman?',
      role: _MessageRole.user,
    ),
    const _ChatMessage(
      role: _MessageRole.ai,
      text: '''# Cara Melakukan General Treatment Totok Punggung

Berdasarkan materi dari Ustadz Abdurrahman (Channel KTPI TV), terdapat **dua versi** General Treatment yang bisa Anda praktikkan:

---

## Versi Pertama (4 Bagian Utama)

### 1. **Ginjal ke Bawah**
- Mulai dari area ginjal (rusuk paling bawah)
- Gerakan horizontal ke bawah hingga pinggul
- Lakukan di sisi kanan, tengah, dan sisi kiri

### 2. **Bahu Belikat**
- Fokus pada area tulang belikat
- Gerakan horizontal sepanjang tulang belikat
- Lakukan di sisi kanan dan kiri
- *Baik untuk mengatasi hipertensi, migrain, vertigo, dan gangguan otak*

### 3. **Tengkuk ke Bawah**
- Mulai dari area tengkuk (bagian leher yang menonjol)
- Gerakan horizontal ke bawah tepat di atas tulang belakang
- Tekanan lebih lembut jika lemak tipis, lebih kuat jika ada penebalan lemak

### 4. **Samping Tulang Belakang**
- Meliputi sisi kanan dan kiri tulang belakang
- Gerakan horizontal dari tengkuk hingga ginjal
- Sentuhkan tekanan hingga mengenai pinggiran tulang belakang

---

## Versi Kedua (3 Hitungan Utama) - Lebih Sederhana

### Hitungan Pertama: Sepanjang Tulang Belakang
- Dimulai dari samping tulang belakang kanan → tengah → samping kiri
- Dilakukan dari tengkuk hingga pinggul

### Hitungan Kedua: Area Pinggul
- Sentuhan horizontal di sepanjang tulang pinggul
- Lakukan hingga batas area yang nyaman

### Hitungan Ketiga: Area Bahu Belikat
- Sentuh bahu belikat kanan, lalu kiri
- Pastikan menyentuh seluruh tulang belikat

---

## Prinsip Dasar Penting

| Aspek | Panduan |
|-------|---------|
| **Tekanan** | Sesuaikan kenyamanan pasien; tidak terlalu keras atau lemah |
| **Arah Gerakan** | Horizontal adalah yang paling efektif |
| **Sentuhan Tulang** | Arahkan tekanan hingga menyentuh tulang belakang/belikat |
| **Minyak** | Gunakan sedikit di ujung jari, tidak perlu banyak |
| **Durasi** | ±10-15 menit per putaran (minimal 2-3 putaran untuk hasil maksimal) |

---

## Catatan
- Teknik ini aman untuk siapa saja (termasuk anak-anak)
- Dapat dilakukan setelah makan atau sebelum tidur
- Tidak ada kontraindikasi khusus
- Bisa dikombinasikan dengan versi pertama untuk hasil lebih optimal

Apakah ada bagian tertentu yang ingin Anda tanyakan lebih lanjut? 😊''',
      sources: [
        _ChatSource(
          id: '5',
          title:
              'TUTORIAL: B. General Treatment Versi Kedua - Totok Punggung - Channel KTPI TV - Ust. Abdurrahman',
          videoUrl: 'https://www.youtube.com/watch?v=FfHa_WoGlKo',
          imageUrl:
              'https://i.ytimg.com/vi/FfHa_WoGlKo/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLAff2QyOOozqUkhQoBzKlcGZ5M33g',
        ),
        _ChatSource(
          id: '4',
          title:
              'TUTORIAL: A. General Treatment Versi Pertama - Totok Punggung - Channel KTPI TV - Ust Abdurrahman',
          videoUrl: 'https://www.youtube.com/watch?v=uTIi2gmMBS8',
          imageUrl:
              'https://i.ytimg.com/vi/uTIi2gmMBS8/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLCvYWmAB_1Lqd7i_IgMrYG17xaNPA',
        ),
        _ChatSource(
          id: '6',
          title:
              'TUTORIAL: C. Finishing & fokosing untuk deteksi penyakit - Totok Punggung  Bersama Ust Abdurrahman',
          videoUrl: 'https://www.youtube.com/watch?v=V4yo_ZSAwJA',
          imageUrl:
              'https://i.ytimg.com/vi/V4yo_ZSAwJA/hqdefault.jpg?sqp=-oaymwEcCNACELwBSFXyq4qpAw4IARUAAIhCGAFwAcABBg==&rs=AOn4CLBftrLrh2FQZRFAgEjjM2ws0KqJXg',
        ),
      ],
    ),
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add(_ChatMessage(text: text, role: _MessageRole.user));
      _messageController.clear();
    });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstant.white,
      appBar: AppBar(
        backgroundColor: ColorConstant.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: ColorConstant.black),
          onPressed: () => context.router.pop(),
        ),
        title: Text(
          'AI Assistant',
          style: TextStyle(
            fontSize: FontConstant.fontSize18,
            fontWeight: FontConstant.bold,
            color: ColorConstant.black,
            fontFamily: FontConstant.robotoFontFamily,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                return _buildBubble(_messages[index]);
              },
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildBubble(_ChatMessage message) {
    final isUser = message.role == _MessageRole.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * (isUser ? 0.7 : 0.85),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isUser ? ColorConstant.primaryLight : ColorConstant.greyLight,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isUser ? 16 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (isUser)
              Text(
                message.text,
                style: TextStyle(
                  fontSize: FontConstant.fontSize14,
                  fontWeight: FontConstant.regular,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                  height: 1.4,
                ),
              )
            else
              MarkdownBody(
                data: message.text,
                styleSheet: MarkdownStyleSheet(
                  p: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    fontWeight: FontConstant.regular,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                    height: 1.4,
                  ),
                  strong: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    fontWeight: FontConstant.bold,
                    color: ColorConstant.black,
                    fontFamily: FontConstant.robotoFontFamily,
                    height: 1.4,
                  ),
                  listBullet: TextStyle(
                    fontSize: FontConstant.fontSize14,
                    color: ColorConstant.black,
                  ),
                ),
              ),
            if (message.sources != null && message.sources!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Divider(
                color: ColorConstant.greyDark.withOpacity(0.2),
                height: 1,
              ),
              const SizedBox(height: 12),
              Text(
                'Sumber materi terkait:',
                style: TextStyle(
                  fontSize: FontConstant.fontSize12,
                  fontWeight: FontConstant.bold,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                ),
              ),
              const SizedBox(height: 8),
              ...message.sources!.map((source) => _buildSourceItem(source)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSourceItem(_ChatSource source) {
    return GestureDetector(
      onTap: () {
        context.router.push(IllnessMaterialRoute(materialId: source.id));
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: ColorConstant.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: ColorConstant.greyLight, width: 1.5),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: Image.network(
                source.imageUrl,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  width: 50,
                  height: 50,
                  color: ColorConstant.greyLight,
                  child: const Icon(
                    Icons.image_not_supported,
                    size: 20,
                    color: ColorConstant.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                source.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: FontConstant.fontSize12,
                  fontWeight: FontConstant.medium,
                  color: ColorConstant.black,
                  fontFamily: FontConstant.robotoFontFamily,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              color: ColorConstant.greyDark,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      color: ColorConstant.white,
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
              controller: _messageController,
              focusNode: _focusNode,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _sendMessage(),
              style: TextStyle(
                fontSize: FontConstant.fontSize14,
                fontFamily: FontConstant.robotoFontFamily,
                color: ColorConstant.black,
              ),
              decoration: InputDecoration(
                hintText: 'Ketik Pesan...',
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
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _sendMessage,
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
    );
  }
}
