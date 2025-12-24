import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../favorites/favorites_notifier.dart';
import '../../location/location_providers.dart';
import '../domain/ancient_map.dart';
import 'ancient_maps.dart';

final ancientMapsProvider = Provider<List<AncientMap>>((ref) => kAncientMaps);

final searchQueryProvider = StateProvider<String>((ref) => '');

final filteredMapsProvider = Provider<List<AncientMap>>((ref) {
  final query = ref.watch(searchQueryProvider).trim().toLowerCase();
  final maps = ref.watch(ancientMapsProvider);
  if (query.isEmpty) return maps;

  return maps.where((map) {
    final searchable = [
      map.name,
      map.era,
      map.description,
      ...map.provinces,
      ...map.tags,
    ].join(' ').toLowerCase();
    return searchable.contains(query);
  }).toList();
});

final nearbyMapsProvider = Provider<List<AncientMap>>((ref) {
  final position = ref.watch(currentPositionProvider).maybeWhen(
        data: (pos) => pos,
        orElse: () => null,
      );
  final maps = ref.watch(ancientMapsProvider);
  if (position == null) return [];

  const distanceTool = Distance();
  return maps.where((map) {
    final meters = distanceTool(map.center, LatLng(position.latitude, position.longitude));
    return meters <= 180000; // ~180 km menzil
  }).toList();
});

final favoriteMapsProvider = Provider<List<AncientMap>>((ref) {
  final favIds = ref.watch(favoritesProvider);
  final maps = ref.watch(ancientMapsProvider);
  return maps.where((map) => favIds.contains(map.id)).toList();
});
