import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/store_by_category/store_by_category_event.dart';
import 'package:umkm_store/bloc/store_by_category/store_by_category_state.dart';
import 'package:umkm_store/services/CustomerService.dart';

class StoreByCategoryBloc extends Bloc<StoreByCategoryEvent, StoreByCategoryState> {
  final CustomerService customerService;

  StoreByCategoryBloc(this.customerService) : super(StoreByCategoryInitial()) {
    on<FetchStoresByCategory>((event, emit) async {
      emit(StoreByCategoryLoading());
      try {
        final stores = await customerService.getStoreByCategory(
          category: event.categorySlug,
          lat: event.latitude?.toString(),
          lng: event.longitude?.toString(),
        );
        emit(StoreByCategorySuccess(stores));
      } catch (e) {
        emit(StoreByCategoryFailure(e.toString()));
      }
    });
  }
}
