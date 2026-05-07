import 'package:umkm_store/model/StoreNearby.dart';

abstract class StoreBySlugEvent {}

class FetchStoreDetail extends StoreBySlugEvent {
  final String slug;

  FetchStoreDetail(this.slug);
}
