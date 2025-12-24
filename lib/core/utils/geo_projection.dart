import 'package:flutter/widgets.dart';
import 'package:latlong2/latlong.dart';

/// Projects a geographic point into a relative offset within a rectangular map.
/// Returns null when the point falls outside the bounding box.
Offset? projectLatLng(
  LatLng point, {
  required LatLng northWest,
  required LatLng southEast,
  required Size size,
}) {
  final minLng = northWest.longitude;
  final maxLng = southEast.longitude;
  final maxLat = northWest.latitude;
  final minLat = southEast.latitude;

  final lngRange = maxLng - minLng;
  final latRange = maxLat - minLat;
  if (lngRange == 0 || latRange == 0) return null;

  if (point.longitude < minLng || point.longitude > maxLng) return null;
  if (point.latitude < minLat || point.latitude > maxLat) return null;

  final xRatio = (point.longitude - minLng) / lngRange;
  final yRatio = (maxLat - point.latitude) / latRange;

  final clampedX = xRatio.clamp(0.0, 1.0);
  final clampedY = yRatio.clamp(0.0, 1.0);

  return Offset(clampedX * size.width, clampedY * size.height);
}

/// Calculates geodesic distance between two coordinates in kilometers.
double distanceKm(LatLng a, LatLng b) {
  final distance = const Distance().distance(a, b);
  return (distance / 1000).toDouble();
}
