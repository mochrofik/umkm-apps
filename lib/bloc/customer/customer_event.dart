import 'package:umkm_store/model/StoreNearby.dart';

abstract class CustomerEvent {}

class CustomerInitialized extends CustomerEvent {}

class FetchNearbyStores extends CustomerEvent {
  final double latitude;
  final double longitude;

  FetchNearbyStores({required this.latitude, required this.longitude});
}

class SelectStore extends CustomerEvent {
  final StoreNearby store;
  SelectStore(this.store);
}
