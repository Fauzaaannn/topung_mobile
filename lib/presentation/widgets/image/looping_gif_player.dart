import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:topung_mobile/core/app_theme/color_constant.dart';

// Queue global untuk memastikan GIF di-load satu per satu
// Mencegah CPU spike dan crash device akibat multi-decoding serentak
class GifLoadQueue {
  static final Queue<Function> _queue = Queue<Function>();
  static bool _isProcessing = false;

  static void add(Function task) {
    _queue.add(task);
    _processNext();
  }

  static Future<void> _processNext() async {
    if (_isProcessing || _queue.isEmpty) return;
    _isProcessing = true;
    final task = _queue.removeFirst();
    try {
      await task();
    } catch (e) {
      // Abaikan error individual task agar queue terus berjalan
    }
    _isProcessing = false;
    _processNext();
  }
}

class LoopingGifPlayer extends StatefulWidget {
  final String gifUrl;
  final BoxFit fit;

  const LoopingGifPlayer({
    super.key,
    required this.gifUrl,
    this.fit = BoxFit.contain,
  });

  @override
  State<LoopingGifPlayer> createState() => _LoopingGifPlayerState();
}

class _LoopingGifPlayerState extends State<LoopingGifPlayer>
    with AutomaticKeepAliveClientMixin {
  bool _isAllowedToLoad = false;

  @override
  void initState() {
    super.initState();
    // Masukkan ke antrian agar tidak semua GIF di-render bersamaan saat chat page dibuka
    GifLoadQueue.add(() async {
      if (mounted) {
        setState(() {
          _isAllowedToLoad = true;
        });
        // Jeda untuk memberikan ruang napas bagi CPU saat parsing/decoding frame GIF
        await Future.delayed(const Duration(milliseconds: 600));
      }
    });
  }

  // Memastikan widget tidak di-dispose/re-decode ulang saat di-scroll ke luar layar
  // (ngeload hanya sekali ketika chat page dibuka)
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Wajib dipanggil untuk AutomaticKeepAliveClientMixin

    if (!_isAllowedToLoad) {
      return Container(
        width: double.infinity,
        height: 150,
        decoration: BoxDecoration(
          color: ColorConstant.greyLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Center(
          child: CircularProgressIndicator(color: ColorConstant.primary),
        ),
      );
    }

    // [PENTING] Mohon jangan dihapus!
    // GIF berukuran 1150x1528 dengan 285 frame memakan RAM murni sebesar ~2 GB per GIF.
    // 3 GIF = 6 GB RAM! Inilah alasan persis mengapa HP langsung mematikan paksa (Force Close) aplikasi Anda.
    // Kode ini meminta Cloudinary mengecilkan gambar sebelum didownload agar RAM dan Kuota Internet aman.
    String optimizedUrl = widget.gifUrl;
    if (widget.gifUrl.contains('res.cloudinary.com') &&
        widget.gifUrl.contains('/upload/')) {
      if (!widget.gifUrl.contains('/upload/w_')) {
        // Dinaikkan ke w_400 agar lebih jelas di list. Aman karena sekarang sudah antri (queued)
        optimizedUrl = widget.gifUrl.replaceFirst(
          '/upload/',
          '/upload/w_400,c_scale/',
        );
      }
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenGifPage(originalUrl: widget.gifUrl),
          ),
        );
      },
      child: RepaintBoundary(
        child: GifView.network(
          optimizedUrl,
          fit: widget.fit,
          frameRate: 30, // Mengatur batas maksimal frame rate ke 30fps
          progressBuilder: (context) => Container(
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              color: ColorConstant.greyLight,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: CircularProgressIndicator(color: ColorConstant.primary),
            ),
          ),
          errorBuilder: (context, error, tryAgain) {
            return Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: ColorConstant.greyLight,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: ColorConstant.grey,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Gagal memuat GIF',
                    style: TextStyle(color: ColorConstant.grey, fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 4.0,
                    ),
                    child: Text(
                      error.toString(),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 10,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ElevatedButton(
                    onPressed: tryAgain,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorConstant.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      minimumSize: const Size(0, 30),
                    ),
                    child: const Text(
                      'Coba Lagi',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class FullScreenGifPage extends StatelessWidget {
  final String originalUrl;

  const FullScreenGifPage({super.key, required this.originalUrl});

  @override
  Widget build(BuildContext context) {
    // Untuk layar penuh, kita beri resolusi lebih besar (w_800) agar teks bisa dibaca dengan jernih.
    // Tidak menggunakan resolusi asli (1150px) agar terhindar dari OOM Crash saat di-zoom.
    String fullScreenUrl = originalUrl;
    if (originalUrl.contains('res.cloudinary.com') &&
        originalUrl.contains('/upload/')) {
      if (!originalUrl.contains('/upload/w_')) {
        fullScreenUrl = originalUrl.replaceFirst(
          '/upload/',
          '/upload/w_800,c_scale/',
        );
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: Center(
        child: InteractiveViewer(
          panEnabled: true,
          boundaryMargin: const EdgeInsets.all(20),
          minScale: 1,
          maxScale: 4,
          child: GifView.network(
            fullScreenUrl,
            fit: BoxFit.contain,
            progressBuilder: (context) => const Center(
              child: CircularProgressIndicator(color: Colors.white),
            ),
            errorBuilder: (context, error, tryAgain) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.white54,
                      size: 40,
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Gagal memuat GIF',
                      style: TextStyle(color: Colors.white54),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: tryAgain,
                      child: const Text('Coba Lagi'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
