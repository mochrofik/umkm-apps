import 'package:dio/dio.dart';
import 'package:umkm_store/constans/Constans.dart';
import 'package:umkm_store/services/api_exception_handler.dart';

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
      throw ApiExceptionHandler.handleException(e);
    }
  }

  Future<Response> register(
    String email,
  ) async {
    try {
      final response = await _dio.post(
        "${Constans.apiUrl}register",
        data: {
          //  'email': identifier,
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
      throw ApiExceptionHandler.handleException(e);
    }
  }

  Future<Response> checkLoginGoogleApp(
      String uid, String email, String name) async {
    try {
      final response = await _dio.post(
        "${Constans.apiUrl}auth/google/login-app",
        data: {'email': email, 'google_id': uid, 'name': name},
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
