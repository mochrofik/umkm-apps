import 'package:geolocator/geolocator.dart';

abstract class CurrentLocationState {}

class CurrentLocationInitial extends CurrentLocationState {}

class CurrentLocationLoading extends CurrentLocationState {}

class CurrentLocationSuccess extends CurrentLocationState {
  final Position position;
  CurrentLocationSuccess(this.position);
}

class CurrentLocationFailure extends CurrentLocationState {
  final String error;
  CurrentLocationFailure(this.error);
}
