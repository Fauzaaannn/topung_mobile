import 'package:dio/dio.dart';

extension DioExceptionExtension on DioException {
  String get indonesianMessage {
    switch (type) {
      case DioExceptionType.connectionTimeout:
        return 'Waktu koneksi habis. Silakan coba lagi.';
      case DioExceptionType.sendTimeout:
        return 'Waktu pengiriman data habis. Silakan coba lagi.';
      case DioExceptionType.receiveTimeout:
        return 'Waktu penerimaan data habis. Silakan coba lagi.';
      case DioExceptionType.badCertificate:
        return 'Sertifikat keamanan tidak valid.';
      case DioExceptionType.badResponse:
        return 'Terjadi kesalahan pada server. Silakan coba lagi nanti.';
      case DioExceptionType.cancel:
        return 'Permintaan dibatalkan.';
      case DioExceptionType.connectionError:
        return 'Koneksi terputus. Pastikan koneksi internet Anda stabil.';
      case DioExceptionType.unknown:
      default:
        return 'Terjadi kesalahan tidak terduga. Silakan periksa koneksi Anda.';
    }
  }
}
