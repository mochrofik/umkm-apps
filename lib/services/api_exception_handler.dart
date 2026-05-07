import 'dart:developer';
import 'package:dio/dio.dart';

class ApiExceptionHandler {
  static String handleException(DioException e) {
    String errorMessage = "Terjadi kesalahan yang tidak diketahui";

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        errorMessage = "Koneksi ke server terputus (Timeout).";
        break;
      case DioExceptionType.sendTimeout:
        errorMessage = "Gagal mengirim data ke server (Timeout).";
        break;
      case DioExceptionType.receiveTimeout:
        errorMessage = "Gagal menerima data dari server (Timeout).";
        break;
      case DioExceptionType.badResponse:
        if (e.response != null) {
          // Handle specific status codes if needed
          final data = e.response?.data;
          if (data is Map && data.containsKey('message')) {
            errorMessage = data['message'];
          } else if (data is Map && data.containsKey('errors')) {
            // Handle validation errors (Laravel style usually)
            final errors = data['errors'] as Map;
            errorMessage = errors.values.first.first.toString();
          } else {
            errorMessage = "Error ${e.response?.statusCode}: ${e.response?.statusMessage}";
          }
        }
        break;
      case DioExceptionType.cancel:
        errorMessage = "Permintaan ke server dibatalkan.";
        break;
      case DioExceptionType.connectionError:
        errorMessage = "Tidak dapat terhubung ke server. Periksa koneksi internet.";
        break;
      default:
        errorMessage = "Terjadi kesalahan koneksi yang tidak terduga.";
    }

    log("DioException [${e.type}]: $errorMessage");
    if (e.response != null) {
      log("Response Data: ${e.response?.data}");
    }

    return errorMessage;
  }
}
