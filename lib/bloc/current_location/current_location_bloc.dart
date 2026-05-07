import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';
import 'package:umkm_store/bloc/current_location/current_location_event.dart';
import 'package:umkm_store/bloc/current_location/current_location_state.dart';
import 'package:umkm_store/services/CurrentLocationService.dart';

class CurrentLocationBloc
    extends Bloc<CurrentLocationEvent, CurrentLocationState> {
  final CurrentLocationService _currentLocationService;
  final Logger _logger;

  CurrentLocationBloc(this._currentLocationService, this._logger)
      : super(CurrentLocationInitial()) {
    on<FetchCurrentLocation>(_onFetchCurrentLocation);
    on<ResetCurrentLocation>(_onResetCurrentLocation);
  }

  Future<void> _onFetchCurrentLocation(
    FetchCurrentLocation event,
    Emitter<CurrentLocationState> emit,
  ) async {
    emit(CurrentLocationLoading());
    try {
      final position = await _currentLocationService.getCurrentLocation();
      _logger.d("current location bloc $position");
      emit(CurrentLocationSuccess(position!));
    } catch (e) {
      _logger.e("current location bloc $e");
      emit(CurrentLocationFailure(e.toString()));
    }
  }

  Future<void> _onResetCurrentLocation(
    ResetCurrentLocation event,
    Emitter<CurrentLocationState> emit,
  ) async {
    emit(CurrentLocationInitial());
  }
}
