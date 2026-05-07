import 'package:umkm_store/model/StoreNearby.dart';

abstract class StoreBySlugState {}

class StoreBySlugInitial extends StoreBySlugState {}

class StoreBySlugLoading extends StoreBySlugState {}

class StoreBySlugSuccess extends StoreBySlugState {
  final StoreNearby store;
  StoreBySlugSuccess(this.store);
}

class StoreBySlugFailure extends StoreBySlugState {
  final String error;
  StoreBySlugFailure(this.error);
}
