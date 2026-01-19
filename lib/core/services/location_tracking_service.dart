import 'package:geolocator/geolocator.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';
import '../../features/maps/domain/ancient_map.dart';
import '../../features/maps/data/ancient_maps.dart';
import 'notification_service.dart';

class LocationTrackingService {
  final NotificationService _notificationService;
  final Set<String> _notifiedPlaces = {};
  
  LocationTrackingService(this._notificationService);

  Future<void> startTracking() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      await Geolocator.requestPermission();
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 100, // Update every 100 meters
      ),
    ).listen(_onLocationUpdate);
  }

  void _onLocationUpdate(Position position) {
    final userLocation = LatLng(position.latitude, position.longitude);
    
    for (final map in kAncientMaps) {
      if (_isNearby(userLocation, map.center) && !_notifiedPlaces.contains(map.id)) {
        _notificationService.showNearbyPlaceNotification(
          map.name,
          map.description,
        );
        _notifiedPlaces.add(map.id);
        
        // Reset notification after 1 hour
        Future.delayed(const Duration(hours: 1), () {
          _notifiedPlaces.remove(map.id);
        });
      }
    }
  }

  bool _isNearby(LatLng userLocation, LatLng placeLocation) {
    const distance = Distance();
    final meters = distance.as(LengthUnit.Meter, userLocation, placeLocation);
    return meters < 1000; // Within 1km
  }
}

final locationTrackingServiceProvider = Provider<LocationTrackingService>((ref) {
  return LocationTrackingService(NotificationService());
});
