import 'package:umkm_store/model/GoogleLoginResponses.dart';
import 'package:umkm_store/model/UserModel.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginGoogleLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final UserData userData;
  LoginSuccess(this.userData);
}

class LoginGoogleSuccess extends LoginState {
  final GoogleLoginResponse googleLoginResponse;
  LoginGoogleSuccess(this.googleLoginResponse);
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
