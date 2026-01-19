import 'package:latlong2/latlong.dart';

class GoldLocation {
  final String name;
  final String city;
  final String type; // Dere, Irmak, Nehir
  final LatLng coordinates;
  final int potentialLevel; // 1-10 arası
  final String description;
  final String recommendedMethod;
  final String bestSeason;
  final List<String> tips;

  GoldLocation({
    required this.name,
    required this.city,
    required this.type,
    required this.coordinates,
    required this.potentialLevel,
    required this.description,
    required this.recommendedMethod,
    required this.bestSeason,
    this.tips = const [],
  });
}
