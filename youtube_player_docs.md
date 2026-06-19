Untuk memutar video YouTube di Flutter dengan dukungan fullscreen yang mulus (baik portrait maupun landscape), ada beberapa pilihan package di `pub.dev` yang bisa diandalkan. Karena ekosistem Flutter cukup dinamis, pendekatannya bergantung pada apakah kamu lebih nyaman dengan rendering *native wrapper* atau berbasis *iframe*.

Berikut adalah rekomendasi terbaiknya:

### 1. `Youtubeer_iframe` (Paling Direkomendasikan)

Package ini menggunakan IFrame Player API resmi dari YouTube. Saat ini, opsi ini adalah yang paling stabil untuk kebutuhan *cross-platform* dan lebih kebal terhadap bug *layouting* ketika layar diputar.

* **Dukungan Fullscreen:** Sangat mulus. Package ini secara otomatis menangani *landscape rotation* untuk masuk ke mode fullscreen, dan mendukung *swipe-up/down gesture* untuk keluar dari fullscreen.
* **Deteksi Portrait/Landscape:** Package ini tidak secara eksplisit memberi tahu "ini video portrait" sebelum dimuat. Namun, kamu bisa berinteraksi dengan API di controllernya untuk mendapatkan data setelah video siap (*onReady*).

### 2. `Youtubeer_flutter` (Terpopuler)

Ini adalah package klasik yang paling banyak di-download dan menggunakan WebView di bawah kapnya.

* **Dukungan Fullscreen:** Mendukung penuh, **tetapi** ada syaratnya. Kamu wajib membungkus keseluruhan halaman dengan `YoutubePlayerBuilder`. Builder ini yang akan mengambil alih *routing* layar saat orientasi berubah, sehingga UI di bawahnya tidak *break* saat transisi ke fullscreen.
* **Deteksi Portrait/Landscape:** Menyediakan objek `YoutubeMetaData` yang bisa diekstrak setelah inisialisasi video, yang berguna untuk merespons perubahan UI.

### 3. `custom_youtube_player`

Package alternatif ini secara spesifik menonjolkan fitur untuk menangani mode portrait (seperti Shorts) dan landscape.

* **Dukungan Fullscreen:** Transisi fullscreen dan penguncian rasio aspek ditangani secara internal.
* **Deteksi Portrait/Landscape:** Package ini sangat praktis karena menyediakan parameter `isPortrait` bertipe boolean langsung di widget-nya.

---

### Trik Deteksi Video Portrait vs Landscape

Mendeteksi orientasi *setelah* video dimuat dari API YouTube terkadang membuat UI berkedip (*flicker*) karena *player* harus menyesuaikan *aspect ratio* secara tiba-tiba. Praktik yang lebih mulus adalah dengan **mendeteksi pola URL sebelum me-render player**.

Kamu bisa membuat *helper function* sederhana:

```dart
bool isPortraitVideo(String url) {
  // Video YouTube Shorts selalu menggunakan path /shorts/
  if (url.contains('/shorts/')) {
    return true; // Pasti portrait
  }
  return false; // Asumsikan landscape untuk video reguler
}

```

Jika aplikasi menerapkan *Clean Architecture*, *logic* ekstraksi ID dan pengecekan jenis URL ini bisa diproses terlebih dahulu. Sehingga, saat masuk ke *layer* presentasi, *State* di Cubit atau BLoC sudah mengetahui apakah *player* harus dirender dalam konfigurasi portrait (rasio 9:16) atau landscape (rasio 16:9), dan memberikan *user experience* yang jauh lebih bersih.

Apakah kamu ingin melihat contoh implementasi kode yang menggunakan `Youtubeer_iframe` dipadukan dengan pengecekan URL *Shorts* tersebut?