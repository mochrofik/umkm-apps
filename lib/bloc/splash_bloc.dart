import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/splash_event.dart';
import 'package:umkm_store/bloc/splash_state.dart';
import 'package:umkm_store/services/StorageService.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final StorageService _storageService;
  SplashBloc(this._storageService) : super(SplashInitial()) {
    on<StartAppCheck>((event, emit) async {
      emit(SplashLoading());

      final token = await _storageService.getToken();
      final user = await _storageService.getUser();

      // Simulasi delay biar splash screen tidak terlalu cepat hilang
      await Future.delayed(const Duration(seconds: 3));

      // Cek apakah token ada atau tidak
      if (token != null && token.isNotEmpty) {
        emit(SplashAuthenticated(user!));
      } else {
        emit(SplashUnauthenticated());
      }
    });
  }
}
