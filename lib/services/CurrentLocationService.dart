import 'package:geolocator/geolocator.dart';

class CurrentLocationService {
  Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // 1. Cek apakah layanan lokasi aktif
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Tampilkan dialog untuk mengaktifkan lokasi
      return Future.error('Location services are disabled.');
    }

    // 2. Cek izin akses
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // 3. Ambil lokasi
    return await Geolocator.getCurrentPosition();
  }
}
