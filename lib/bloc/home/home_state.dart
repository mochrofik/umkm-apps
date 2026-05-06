import 'package:umkm_store/model/UserModel.dart';

abstract class HomeState {}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final UserData user;
  HomeLoaded(this.user);
}

class HomeError extends HomeState {
  final String error;
  HomeError(this.error);
}
