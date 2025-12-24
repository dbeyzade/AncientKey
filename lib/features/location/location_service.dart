import 'package:geolocator/geolocator.dart';

class LocationService {
  Future<bool> _ensurePermission() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return false;
    }
    return true;
  }

  Future<Position?> currentPosition() async {
    final permitted = await _ensurePermission();
    if (!permitted) return null;
    return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
  }
}
