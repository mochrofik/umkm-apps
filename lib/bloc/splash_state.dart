import 'package:umkm_store/model/UserModel.dart';

abstract class SplashState {}

class SplashInitial extends SplashState {}

class SplashLoading extends SplashState {}

class SplashAuthenticated extends SplashState {
  final UserData user;
  SplashAuthenticated(this.user);
}

class SplashUnauthenticated extends SplashState {}
