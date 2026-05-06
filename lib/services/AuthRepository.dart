import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:umkm_store/constans/Constans.dart';

class AuthRepository {
  final Dio _dio = Dio();
  Future<Response> login(String identifier, String password) async {
    try {
      final response = await _dio.post(
        "${Constans.apiUrl}login",
        data: {
          'email': identifier,
          'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan yang tidak diketahui";

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ?? "Error ${e.response?.statusCode}";
        log("Error API 401/422: $errorMessage");
      } else {
        errorMessage =
            "Tidak dapat terhubung ke server. Periksa koneksi internet.";
      }
      throw errorMessage;
    }
  }

  Future<Response> register() async {
    try {
      final response = await _dio.post(
        "${Constans.apiUrl}register",
        data: {
          // 'email': identifier,
          // 'password': password,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );

      return response;
    } on DioException catch (e) {
      String errorMessage = "Terjadi kesalahan yang tidak diketahui";

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ?? "Error ${e.response?.statusCode}";
        log("Error API 401/422: $errorMessage");
      } else {
        errorMessage =
            "Tidak dapat terhubung ke server. Periksa koneksi internet.";
      }
      throw errorMessage;
    }
  }
}
