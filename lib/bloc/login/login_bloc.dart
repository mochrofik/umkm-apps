import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:umkm_store/bloc/login/login_event.dart';
import 'package:umkm_store/bloc/login/login_state.dart';
import 'package:umkm_store/model/UserModel.dart';
import 'package:umkm_store/services/AuthRepository.dart';
import 'package:umkm_store/services/StorageService.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRepository authRepository;

  LoginBloc({required this.authRepository}) : super(LoginInitial()) {
    on<LoginSubmitted>((event, emit) async {
      StorageService storageService = StorageService();

      if (event.identifier.isEmpty && event.password.isEmpty) {
        return emit(LoginFailure("Email dan Password tidak boleh kosong!!!"));
      } else if (event.identifier.isEmpty) {
        return emit(LoginFailure("Email harus diisi!"));
      } else if (event.password.isEmpty) {
        return emit(LoginFailure("Password harus diisi!"));
      }
      emit(LoginLoading());

      try {
        final res =
            await authRepository.login(event.identifier, event.password);

        // log(res.data.toString());
        if (res.statusCode == 200) {
          storageService.saveToken(res.data['data']['access_token']);
          final user = res.data['data']['user'];

          if (user != null) {
            storageService.saveUser(
              UserData(
                id: user['id'],
                name: user['name'],
                email: user['email'],
                role: user['role'],
                status: user['status'],
                roles: [],
                createdAt: DateTime.parse(user['created_at']),
                updatedAt: DateTime.parse(user['updated_at']),
              ),
            );
          }

          emit(LoginSuccess(res));
        } else {
          emit(LoginFailure(res.statusMessage ?? "Error login"));
        }
      } catch (e) {
        storageService.clearToken();
        emit(LoginFailure(e.toString()));
      }
    });

    on<GoogleLoginRequested>((event, emit) async {
      emit(LoginLoading());
      // Simulasi delay atau implementasi masa depan
      await Future.delayed(const Duration(seconds: 1));
      emit(LoginFailure("Fitur Login Google sedang dalam pengembangan."));
    });

    on<LogoutRequested>((event, emit) async {
      emit(LoginLoading());
      try {
        StorageService storageService = StorageService();

        await storageService.clearToken();

        emit(LoginInitial());
      } catch (e) {
        emit(LoginFailure("Gagal Logout: $e"));
      }
    });
  }
}
