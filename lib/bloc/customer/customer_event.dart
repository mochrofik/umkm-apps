abstract class CustomerEvent {}

class CustomerInitialized extends CustomerEvent {}

class FetchNearbyStores extends CustomerEvent {
  final double latitude;
  final double longitude;

  FetchNearbyStores({required this.latitude, required this.longitude});
}
