import 'package:dio/dio.dart';

abstract class RegisterState {}

class RegisterInitial extends RegisterState {}

class RegisterLoading extends RegisterState {}

class RegisterSuccess extends RegisterState {
  final Response response;
  RegisterSuccess(this.response);
}

class RegisterFailure extends RegisterState {
  final String error;
  RegisterFailure(this.error);
}
