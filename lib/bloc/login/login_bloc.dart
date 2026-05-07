import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/login/login_event.dart';
import 'package:umkm_store/bloc/login/login_state.dart';
import 'package:umkm_store/services/AuthService.dart';
import 'package:umkm_store/services/StorageService.dart';
import 'package:logger/logger.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final StorageService storageService;
  final AuthService authService;
  final logger = Logger();

  LoginBloc({
    required this.storageService,
    required this.authService,
  }) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      if (event.identifier.isEmpty && event.password.isEmpty) {
        return emit(LoginFailure("Email dan Password tidak boleh kosong!!!"));
      } else if (event.identifier.isEmpty) {
        return emit(LoginFailure("Email harus diisi!"));
      } else if (event.password.isEmpty) {
        return emit(LoginFailure("Password harus diisi!"));
      }
      emit(LoginLoading());

      try {
        final userData =
            await authService.login(event.identifier, event.password);

        if (userData != null) {
          emit(LoginSuccess(userData));
        } else {
          emit(LoginFailure("Error login user data tidak ditemukan"));
        }
      } catch (e) {
        storageService.clearToken();
        emit(LoginFailure(e.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(LoginGoogleLoading());
      try {
        final res = await authService.signInWithGoogle();

        if (res?.user?.email == null) {
          emit(LoginFailure("Email tidak ditemukan!"));
          return;
        }

        final checkLogin = await authService.checkLoginGoogleApp(res!.user!.uid,
            res.user!.email!, res.user!.displayName ?? "Unknown");

        emit(LoginGoogleSuccess(checkLogin!));
      } catch (e) {
        logger.e(" login bloc $e");
        emit(LoginFailure(e.toString()));
      }
    });

    on<LogoutRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        await storageService.clearToken();

        emit(LoginInitial());
      } catch (e) {
        emit(LoginFailure("Gagal Logout: $e"));
      }
    });
  }
}
