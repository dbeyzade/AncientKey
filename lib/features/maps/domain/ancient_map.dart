import 'package:latlong2/latlong.dart';

class AncientMap {
  AncientMap({
    required this.id,
    required this.name,
    required this.era,
    required this.description,
    required this.assetPath,
    required this.center,
    required this.northWest,
    required this.southEast,
    required this.provinces,
    required this.tags,
    this.highlight,
  });

  final String id;
  final String name;
  final String era;
  final String description;
  final String assetPath;
  final LatLng center;
  final LatLng northWest;
  final LatLng southEast;
  final List<String> provinces;
  final List<String> tags;
  final String? highlight;

  bool contains(LatLng point) {
    final withinLat = point.latitude >= southEast.latitude && point.latitude <= northWest.latitude;
    final withinLng = point.longitude >= northWest.longitude && point.longitude <= southEast.longitude;
    return withinLat && withinLng;
  }
}
