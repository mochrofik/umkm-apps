import 'package:logger/logger.dart';
import 'package:umkm_store/model/StoreNearby.dart';
import 'package:umkm_store/repository/CustomerRepository.dart';

class CustomerService {
  final CustomerRepository _customerRepository;
  final Logger _logger;
  // Minta repository dan logger lewat constructor
  CustomerService(this._customerRepository, this._logger);

  Future<List<StoreNearby>> getStoreNearby(
      {required String lat, required String lng}) async {
    try {
      final response =
          await _customerRepository.getStoreNearby(lat: lat, lng: lng);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => StoreNearby.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      _logger.e("Error CustomerService getStoreNearby: $e");
      throw Exception(e);
    }
  }
}
