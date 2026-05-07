import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:umkm_store/bloc/register/register_event.dart';
import 'package:umkm_store/bloc/register/register_state.dart';
import 'package:umkm_store/services/RegisterService.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterService registerService;
  final Logger logger = Logger();

  RegisterBloc(this.registerService) : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      // Placeholder for registration logic
      print(
          "Registering customer: ${event.request.name}, ${event.request.email}, ${event.request.phone}");

      try {
        // Simulate delay
        await Future.delayed(Duration(seconds: 2));

        final userData = await registerService.register(event.request);
        if (userData != null) {
          emit(RegisterSuccess("Pendaftaran Berhasil!"));
        } else {
          emit(RegisterFailure("Registrasi Gagal"));
        }
      } catch (e) {
        logger.d(" register bloc $e");
        emit(RegisterFailure(e.toString()));
      }

      // For now, we'll just emit success for demo purposes,
      // or you can implement actual API call here.
      // emit(RegisterSuccess());
    });
  }
}
