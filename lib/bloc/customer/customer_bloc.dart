import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/customer/customer_event.dart';
import 'package:umkm_store/bloc/customer/customer_state.dart';
import 'package:umkm_store/services/CustomerService.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerService customerService;

  CustomerBloc(this.customerService) : super(CustomerInitial()) {
    on<FetchNearbyStores>((event, emit) async {
      emit(CustomerLoading());
      try {
        final stores = await customerService.getStoreNearby(
          lat: event.latitude.toString(),
          lng: event.longitude.toString(),
        );
        emit(CustomerNearbyStoresSuccess(stores));
      } catch (e) {
        emit(CustomerFailure(e.toString()));
      }
    });

    on<SelectStore>((event, emit) {
      final currentState = state;
      emit(NavigateToStoreDetail(event.store));

      // Restore previous success state to keep the list visible
      if (currentState is CustomerNearbyStoresSuccess) {
        emit(CustomerNearbyStoresSuccess(currentState.stores));
      }
    });
  }
}
