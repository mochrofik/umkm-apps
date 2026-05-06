import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/home/home_event.dart';
import 'package:umkm_store/bloc/home/home_state.dart';
import 'package:umkm_store/services/StorageService.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final StorageService storageService = StorageService();

  HomeBloc() : super(HomeInitial()) {
    on<LoadHomeData>((event, emit) async {
      try {
        final userData = await storageService.getUser();

        if (userData != null) {
          emit(HomeLoaded(userData));
        } else {
          emit(HomeError("Data user tidak ditemukan"));
        }
      } catch (e) {
        emit(HomeError(e.toString()));
      }
    });
  }
}
