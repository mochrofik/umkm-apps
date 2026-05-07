import 'package:umkm_store/model/StoreNearby.dart';

abstract class CustomerState {}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerNearbyStoresSuccess extends CustomerState {
  final List<StoreNearby> stores;
  CustomerNearbyStoresSuccess(this.stores);
}

class CustomerFailure extends CustomerState {
  final String error;
  CustomerFailure(this.error);
}

class NavigateToStoreDetail extends CustomerState {
  final StoreNearby store;
  NavigateToStoreDetail(this.store);
}
