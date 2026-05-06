import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/register/register_event.dart';
import 'package:umkm_store/bloc/register/register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>((event, emit) async {
      emit(RegisterLoading());
      // Placeholder for registration logic
      print(
          "Registering customer: ${event.name}, ${event.email}, ${event.phone}");

      // Simulate delay
      await Future.delayed(Duration(seconds: 2));

      // For now, we'll just emit success for demo purposes,
      // or you can implement actual API call here.
      // emit(RegisterSuccess());
    });
  }
}
