import 'package:umkm_store/model/StoreNearby.dart';

abstract class StoreByCategoryEvent {}

class FetchStoresByCategory extends StoreByCategoryEvent {
  final String categorySlug;
  final double? latitude;
  final double? longitude;

  FetchStoresByCategory({
    required this.categorySlug,
    this.latitude,
    this.longitude,
  });
}
