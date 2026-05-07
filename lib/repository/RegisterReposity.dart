import 'package:dio/dio.dart';
import 'package:umkm_store/constans/Constans.dart';
import 'package:umkm_store/model/request/RegisterRequest.dart';
import 'package:umkm_store/services/api_exception_handler.dart';

class RegisterRepository {
  final Dio _dio = Dio();

  Future<Response> registerUser(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        '${Constans.apiUrl}register-from-google',
        data: request.toJson(),
        options: Options(
          headers: {
            'Accept': 'application/json',
          },
        ),
      );
      return response;
    } on DioException catch (e) {
      throw ApiExceptionHandler.handleException(e);
    }
  }
}
