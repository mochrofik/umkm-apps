import 'package:dio/dio.dart';
import 'package:umkm_store/constans/Constans.dart';
import 'package:umkm_store/services/StorageService.dart';

class CategoryRepository {
  final Dio _dio = Dio();
  final StorageService storageService = StorageService();

  Future<Response> getCategories(
      {String search = "", int page = 1, int limit = 10}) async {
    try {
      final String? token = await storageService.getToken();

      final response = await _dio.get(
        "${Constans.apiUrl}category/get",
        queryParameters: {
          "search": search,
          "page": page,
          "limit": limit,
        },
        options: Options(
          headers: {
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );

      print(response.toString());

      return response;
    } on DioException catch (e) {
      print("e $e");
      String errorMessage = "Terjadi kesalahan yang tidak diketahui";

      if (e.response != null) {
        errorMessage =
            e.response?.data['message'] ?? "Error ${e.response?.statusCode}";
      } else {
        errorMessage =
            "Tidak dapat terhubung ke server. Periksa koneksi internet.";
      }
      throw errorMessage;
    }
  }

  Future<Response> getCategoriesUser() async {
    try {
      final response = await _dio.get(
        "${Constans.apiUrl}categories-user",
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
      } else {
        errorMessage =
            "Tidak dapat terhubung ke server. Periksa koneksi internet.";
      }
      throw errorMessage;
    }
  }
}
