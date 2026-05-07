import 'package:geolocator/geolocator.dart';

class CurrentLocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error(
          'Layanan lokasi (GPS) dimatikan. Silakan aktifkan GPS Anda Untuk Melihat Toko Terdekat.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return Future.error(
          'Lokasi ditolak secara permanen, kami tidak dapat meminta izin. Silahkan aktifkan lokasi Anda di pengaturan perangkat.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
