import 'package:umkm_store/model/response/RegisterCustomerResponse.dart';
import 'package:logger/logger.dart';
import 'package:umkm_store/model/request/RegisterRequest.dart';
import 'package:umkm_store/repository/RegisterReposity.dart';

class RegisterService {
  final RegisterRepository _registerRepository = RegisterRepository();
  final Logger logger = Logger();

  Future<RegisterCustomerResponse?> register(RegisterRequest request) async {
    try {
      final response = await _registerRepository.registerUser(request);

      logger.d(
          " response data ${response.data}  response status code ${response.statusCode}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Jika data dibungkus dalam key 'data'
        if (response.data['data'] != null) {
          return RegisterCustomerResponse.fromJson(response.data['data']);
        }
        // Jika data langsung di root response
        return RegisterCustomerResponse.fromJson(response.data);
      }
      return null;
    } catch (e) {
      throw Exception(e);
    }
  }
}
