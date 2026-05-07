import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/store_by_slug/store_by_slug_event.dart';
import 'package:umkm_store/bloc/store_by_slug/store_by_slug_state.dart';
import 'package:umkm_store/services/CustomerService.dart';

class StoreBySlugBloc extends Bloc<StoreBySlugEvent, StoreBySlugState> {
  final CustomerService customerService;

  StoreBySlugBloc(this.customerService) : super(StoreBySlugInitial()) {
    on<FetchStoreDetail>((event, emit) async {
      emit(StoreBySlugLoading());
      try {
        final store = await customerService.getStoreBySlug(event.slug);
        emit(StoreBySlugSuccess(store));
      } catch (e) {
        emit(StoreBySlugFailure(e.toString()));
      }
    });
  }
}
