import 'package:dio/dio.dart';
import 'package:umkm_store/constans/Constans.dart';
import 'package:umkm_store/services/StorageService.dart';
import 'package:umkm_store/services/api_exception_handler.dart';

class CustomerRepository {
  final Dio _dio = Dio();
  final StorageService storageService = StorageService();

  Future<Response> getStoreNearby(
      {required String lat, required String lng}) async {
    try {
      final String? token = await storageService.getToken();

      Response response = await _dio.get(
        "${Constans.apiUrl}get-nearby",
        queryParameters: {
          "lat": lat,
          "lng": lng,
        },
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );
      return response;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }
}
