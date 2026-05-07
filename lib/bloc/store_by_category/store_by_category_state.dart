import 'package:umkm_store/model/StoreNearby.dart';

abstract class StoreByCategoryState {}

class StoreByCategoryInitial extends StoreByCategoryState {}

class StoreByCategoryLoading extends StoreByCategoryState {}

class StoreByCategorySuccess extends StoreByCategoryState {
  final List<StoreNearby> stores;
  StoreByCategorySuccess(this.stores);
}

class StoreByCategoryFailure extends StoreByCategoryState {
  final String error;
  StoreByCategoryFailure(this.error);
}
