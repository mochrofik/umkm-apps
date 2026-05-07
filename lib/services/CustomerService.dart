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

  Future<List<StoreNearby>> getStoreByCategory(
      {required String category, String? lat, String? lng}) async {
    try {
      final response = await _customerRepository.getStoreByCategory(
          category: category, lat: lat, lng: lng);

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => StoreNearby.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      _logger.e("Error CustomerService getStoreByCategory: $e");
      throw Exception(e);
    }
  }

  Future<StoreNearby> getStoreBySlug(String slug) async {
    try {
      final response = await _customerRepository.getStoreBySlug(slug);

      if (response.statusCode == 200) {
        _logger.d(response.data['data']);
        return StoreNearby.fromJson(response.data['data']);
      }
      throw Exception("Toko tidak ditemukan");
    } catch (e) {
      _logger.e("Error CustomerService getStoreBySlug: $e");
      throw Exception(e);
    }
  }
}
