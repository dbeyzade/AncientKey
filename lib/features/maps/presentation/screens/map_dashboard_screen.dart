import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo_projection.dart';
import '../../../../core/widgets/cyber_background.dart';
import '../../../favorites/favorites_notifier.dart';
import '../../../favorites/search_favorites_notifier.dart';
import '../../../location/geocoding_service.dart';
import '../../../location/location_providers.dart';
import '../../data/map_providers.dart';
import '../../domain/ancient_map.dart';
import '../widgets/map_card.dart';
import 'map_detail_screen.dart';
import '../../../progress/visited_places_screen.dart';
import '../../../achievements/achievements_screen.dart';
import '../../../advanced_features/advanced_features_menu_screen.dart';
import '../../../advanced_features/screens/quest_system_screen.dart';
import '../../../advanced_features/screens/treasure_hunt_screen.dart';
import '../../../advanced_features/screens/leaderboard_screen.dart';
import '../../../advanced_features/screens/social_tours_screen.dart';
import '../../../advanced_features/screens/friends_screen.dart';
import '../../../advanced_features/screens/multiplayer_challenges_screen.dart';
import '../../../advanced_features/screens/ar_multiplayer_screen.dart';
import '../../../advanced_features/screens/mini_games_screen.dart';
import '../../../advanced_features/screens/achievement_badges_screen.dart';
import '../../../advanced_features/screens/creative/3d_model_creator_screen.dart';
import '../../../advanced_features/screens/creative/custom_map_editor_screen.dart';
import '../../../advanced_features/screens/creative/photo_filters_screen.dart';
import '../../../gold_mining/gold_mining_screen.dart';
import '../../../ancient_history/ancient_history_hub_screen.dart';
import '../../../advanced_features/screens/professional/dating_calculator_screen.dart';
import '../../../advanced_features/screens/professional/restoration_planner_screen.dart';
import '../../../advanced_features/screens/professional/field_notes_screen.dart';
import '../../../advanced_features/screens/professional/site_simulator_screen.dart';
import '../../../advanced_features/screens/analytics/heat_map_screen.dart';
import '../../../advanced_features/screens/personalized_recommendations_screen.dart';
import '../../../advanced_features/screens/vr_historical_experiences_screen.dart';
import '../../../advanced_features/screens/hologram_projection_screen.dart';
import '../../../advanced_features/screens/audio_guides_3d_screen.dart';
import '../../../advanced_features/screens/time_travel_simulator_screen.dart';
import '../../../advanced_features/screens/climate_simulator_screen.dart';
import '../../../advanced_features/screens/virtual_laboratory_screen.dart';
import '../../../advanced_features/screens/research_projects_screen.dart';
import './maps_and_info_video_screen.dart';

class MapDashboardScreen extends ConsumerStatefulWidget {
  const MapDashboardScreen({super.key});

  @override
  ConsumerState<MapDashboardScreen> createState() => _MapDashboardScreenState();
}

class _MapDashboardScreenState extends ConsumerState<MapDashboardScreen> {
  late final GlobalKey<_MapPanelState> _mapPanelKey;

  @override
  void initState() {
    super.initState();
    _mapPanelKey = GlobalKey<_MapPanelState>();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoritesProvider);

    return Scaffold(
      body: Stack(
        children: [
          const CyberBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.08),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonCyan.withValues(alpha: 0.25),
                          AppTheme.neonPink.withValues(alpha: 0.18),
                        ],
                      ),
                    ),
                    child: Text(
                      'AncientKey • Siber Atlas',
                      style: theme.textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Haritalar ve Bilgiler Button
                  SizedBox(
                    width: double.infinity,
                    height: 140,
                    child: ElevatedButton(
                      onPressed: () {
                        // Haritalar ve Bilgiler video ekranını göster
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapsAndInfoVideoScreen(),
                          ),
                        ).then((videoWatched) {
                          // Video bittiğinde haritalar sayfasına git
                          if (videoWatched == true && mounted) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => _MapsAndInfoScreen(
                                  mapPanelKey: GlobalKey<_MapPanelState>(),
                                ),
                              ),
                            );
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonCyan.withValues(
                          alpha: 0.15,
                        ),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        shadowColor: AppTheme.neonCyan.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                          side: BorderSide(
                            color: AppTheme.neonCyan.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.map_rounded,
                            size: 48,
                            color: AppTheme.neonCyan,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Haritalar ve Bilgiler',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    'Hızlı Erişim',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _QuickActionButton(
                          icon: Icons.emoji_events,
                          label: 'Başarılar',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const AchievementsScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 12),
                        _QuickActionButton(
                          icon: Icons.location_on,
                          label: 'Gezdiğim',
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const VisitedPlacesScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Favorites Count
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.neonPink.withValues(alpha: 0.3),
                      ),
                      color: AppTheme.neonPink.withValues(alpha: 0.1),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.favorite,
                          color: AppTheme.neonPink,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          '${favorites.length} Favori kaydedildi',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // İleri Seviye Özellikler
                  const Text(
                    '🚀 İleri Seviye Özellikler',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildAllAdvancedFeatures(context),
                  const SizedBox(height: 32),

                  // Footer
                  Center(
                    child: Text(
                      'Designed By_Hayri KARACA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPanel extends ConsumerStatefulWidget {
  const _MapPanel({
    super.key,
    required this.maps,
    required this.nearby,
    required this.onTapMap,
    required this.locationAsync,
    this.height = 260,
  });

  final List<AncientMap> maps;
  final List<AncientMap> nearby;
  final void Function(AncientMap map) onTapMap;
  final AsyncValue locationAsync;
  final double height;

  @override
  ConsumerState<_MapPanel> createState() => _MapPanelState();
}

class _MapPanelState extends ConsumerState<_MapPanel> {
  late final MapController _mapController;

  MapController get mapController => _mapController;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
  }

  @override
  void dispose() {
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Arama sonucu varsa, ilk sonucu merkez olarak al
    LatLng initialCenter;
    if (widget.maps.isNotEmpty) {
      initialCenter = widget.maps.first.center;
    } else if (widget.nearby.isNotEmpty) {
      initialCenter = widget.nearby.first.center;
    } else {
      initialCenter = const LatLng(39.0, 35.0);
    }

    final location = widget.locationAsync.maybeWhen<LatLng?>(
      data: (pos) => pos == null ? null : LatLng(pos.latitude, pos.longitude),
      orElse: () => null,
    );

    return Container(
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        gradient: LinearGradient(
          colors: [
            Colors.white.withValues(alpha: 0.04),
            Colors.white.withValues(alpha: 0.02),
          ],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: initialCenter,
            initialZoom: 8,
            backgroundColor: Colors.black,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'ancientkey.app',
            ),
            MarkerLayer(
              markers: [
                ...widget.maps.map(
                  (map) => Marker(
                    point: map.center,
                    width: 72,
                    height: 72,
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () => widget.onTapMap(map),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppTheme.neonCyan.withValues(alpha: 0.7),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.neonCyan.withValues(alpha: 0.25),
                              blurRadius: 16,
                              spreadRadius: 2,
                            ),
                          ],
                          gradient: LinearGradient(
                            colors: [
                              AppTheme.neonCyan.withValues(alpha: 0.9),
                              AppTheme.neonPink.withValues(alpha: 0.6),
                            ],
                          ),
                        ),
                        child: Center(
                          child: Text(
                            map.name.split(' ').first,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (location != null)
                  Marker(
                    point: location,
                    width: 24,
                    height: 24,
                    child: const Icon(
                      Icons.navigation_rounded,
                      color: AppTheme.neonAmber,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.neonCyan),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.4)),
        color: color.withValues(alpha: 0.16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

// Haritalar ve Bilgiler sayfası
class _MapsAndInfoScreen extends ConsumerStatefulWidget {
  final GlobalKey<_MapPanelState> mapPanelKey;

  const _MapsAndInfoScreen({required this.mapPanelKey});

  @override
  ConsumerState<_MapsAndInfoScreen> createState() => _MapsAndInfoScreenState();
}

class _MapsAndInfoScreenState extends ConsumerState<_MapsAndInfoScreen> {
  late final GlobalKey<_MapPanelState> _localMapPanelKey;

  @override
  void initState() {
    super.initState();
    _localMapPanelKey = GlobalKey<_MapPanelState>();
  }

  @override
  Widget build(BuildContext context) {
    final maps = ref.watch(filteredMapsProvider);
    final nearby = ref.watch(nearbyMapsProvider);
    final favorites = ref.watch(favoritesProvider);
    final locationAsync = ref.watch(currentPositionProvider);
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;
    final mapHeight = isLandscape ? 160.0 : 260.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Haritalar ve Bilgiler'),
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        children: [
          const CyberBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Banner Image - Haritalar ve Bilgiler
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppTheme.neonCyan.withOpacity(0.3),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.asset(
                        'assets/images/maps_and_info_banner.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Search Bar
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          decoration: const InputDecoration(
                            hintText: 'Ara...',
                            prefixIcon: Icon(Icons.search),
                            isDense: true,
                          ),
                          onChanged: (value) =>
                              ref.read(searchQueryProvider.notifier).state =
                                  value,
                        ),
                      ),
                      const SizedBox(width: 6),
                      if (ref.watch(searchQueryProvider).trim().isNotEmpty)
                        SizedBox(
                          height: 40,
                          width: 40,
                          child: IconButton(
                            onPressed: () async {
                              final query = ref
                                  .read(searchQueryProvider)
                                  .trim();
                              final coordinates =
                                  await GeocodingService.getCoordinatesFromAddress(
                                    query,
                                  );
                              if (coordinates != null) {
                                final favoriteId =
                                    'fav_${DateTime.now().millisecondsSinceEpoch}';
                                await ref
                                    .read(searchFavoritesProvider.notifier)
                                    .addFavorite(favoriteId, query);
                                await ref
                                    .read(favoritesProvider.notifier)
                                    .toggle(favoriteId);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        '"$query" favorilere eklendi',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                            icon: const Icon(Icons.favorite_border, size: 18),
                            tooltip: 'Favorilere Ekle',
                            padding: EdgeInsets.zero,
                            color: AppTheme.neonPink,
                          ),
                        ),
                      const SizedBox(width: 6),
                      if (ref.watch(searchQueryProvider).trim().isNotEmpty)
                        SizedBox(
                          height: 40,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final query = ref
                                  .read(searchQueryProvider)
                                  .trim();
                              final filteredMaps = ref.read(
                                filteredMapsProvider,
                              );

                              if (filteredMaps.isNotEmpty &&
                                  _localMapPanelKey.currentState != null) {
                                _localMapPanelKey.currentState!.mapController
                                    .move(filteredMaps.first.center, 8);
                              } else {
                                final coordinates =
                                    await GeocodingService.getCoordinatesFromAddress(
                                      query,
                                    );
                                if (coordinates != null &&
                                    _localMapPanelKey.currentState != null) {
                                  _localMapPanelKey.currentState!.mapController
                                      .move(coordinates, 10);
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          '$query konumuna gidiliyor',
                                        ),
                                      ),
                                    );
                                  }
                                } else {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Adres bulunamadı'),
                                      ),
                                    );
                                  }
                                }
                              }
                            },
                            icon: const Icon(Icons.navigation, size: 16),
                            label: const Text(
                              'Git',
                              style: TextStyle(fontSize: 12),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppTheme.neonCyan,
                              foregroundColor: Colors.black,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Location Status
                  Row(
                    children: [
                      locationAsync.when(
                        data: (pos) {
                          if (pos == null) {
                            return _StatusChip(
                              icon: Icons.location_disabled,
                              label: 'Konum alınamadı • izin veriniz',
                              color: Colors.orangeAccent,
                            );
                          }
                          return _StatusChip(
                            icon: Icons.podcasts_rounded,
                            label:
                                'Konum: ${pos.latitude.toStringAsFixed(3)}, ${pos.longitude.toStringAsFixed(3)}',
                            color: AppTheme.neonCyan,
                          );
                        },
                        loading: () => _StatusChip(
                          icon: Icons.sensors,
                          label: 'Konum çekiliyor...',
                          color: Colors.white70,
                        ),
                        error: (error, _) => _StatusChip(
                          icon: Icons.error_outline,
                          label: 'Konum hatası',
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: () => _showFavoritesDialog(context, maps),
                        child: _StatusChip(
                          icon: Icons.favorite,
                          label: '${favorites.length} favori',
                          color: AppTheme.neonPink,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Map
                  _MapPanel(
                    key: _localMapPanelKey,
                    maps: maps,
                    nearby: nearby,
                    onTapMap: (map) => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => MapDetailScreen(map: map),
                      ),
                    ),
                    locationAsync: locationAsync,
                    height: mapHeight,
                  ),
                  const SizedBox(height: 12),

                  // Nearby Maps
                  if (nearby.isNotEmpty) ...[
                    _SectionHeader(
                      title: 'Yakınındaki antik katmanlar',
                      icon: Icons.radar,
                    ),
                    ...nearby.map(
                      (map) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AncientMapCard(
                          map: map,
                          distanceLabel: locationAsync.maybeWhen(
                            data: (pos) {
                              if (pos == null) return null;
                              final km = distanceKm(
                                LatLng(pos.latitude, pos.longitude),
                                map.center,
                              );
                              return '${km.toStringAsFixed(1)} km';
                            },
                            orElse: () => null,
                          ),
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => MapDetailScreen(map: map),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],

                  // Advanced Features
                  _SectionHeader(
                    title: 'Gelişmiş Özellikler',
                    icon: Icons.apps,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdvancedFeaturesMenuScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_circle_outlined),
                      label: const Text('Gelişmiş Özellikleri Keşfet'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonPink.withValues(
                          alpha: 0.2,
                        ),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // All Maps
                  _SectionHeader(
                    title: 'Tüm haritalar',
                    icon: Icons.layers_outlined,
                  ),
                  ...maps.map(
                    (map) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AncientMapCard(
                        map: map,
                        distanceLabel: locationAsync.maybeWhen(
                          data: (pos) {
                            if (pos == null) return null;
                            final km = distanceKm(
                              LatLng(pos.latitude, pos.longitude),
                              map.center,
                            );
                            return '${km.toStringAsFixed(1)} km';
                          },
                          orElse: () => null,
                        ),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => MapDetailScreen(map: map),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      'Designed By_Hayri KARACA',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white.withValues(alpha: 0.4),
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFavoritesDialog(BuildContext context, List<AncientMap> maps) {
    final favorites = ref.read(favoritesProvider);
    final searchFavorites = ref.read(searchFavoritesProvider);
    final favoriteMapsList = maps
        .where((map) => favorites.contains(map.id))
        .toList();
    final searchFavoriteIds = favorites
        .where((id) => searchFavorites.containsKey(id))
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Row(
          children: [
            Icon(Icons.favorite, color: AppTheme.neonPink),
            SizedBox(width: 8),
            Text('Favoriler'),
          ],
        ),
        content: favoriteMapsList.isEmpty && searchFavoriteIds.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(20),
                child: Text(
                  'Henüz favori eklemediniz.',
                  textAlign: TextAlign.center,
                ),
              )
            : SizedBox(
                width: double.maxFinite,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...favoriteMapsList.map((map) {
                      return ListTile(
                        title: Text(map.name),
                        subtitle: Text(
                          map.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggle(map.id);
                            Navigator.pop(context);
                            _showFavoritesDialog(context, maps);
                          },
                        ),
                      );
                    }),
                    ...searchFavoriteIds.map((favoriteId) {
                      final address =
                          searchFavorites[favoriteId] ?? 'Bilinmeyen';
                      return ListTile(
                        title: Text(address),
                        subtitle: const Text('Arama Favorisi'),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            ref
                                .read(favoritesProvider.notifier)
                                .toggle(favoriteId);
                            ref
                                .read(searchFavoritesProvider.notifier)
                                .removeFavorite(favoriteId);
                            Navigator.pop(context);
                            _showFavoritesDialog(context, maps);
                          },
                        ),
                      );
                    }),
                  ],
                ),
              ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }
}

// Hızlı Erişim Butonları
class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
          color: AppTheme.neonCyan.withValues(alpha: 0.08),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.neonCyan, size: 28),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// İleri Seviye Özellikleri Grid
class _AdvancedFeaturesGrid extends StatelessWidget {
  final BuildContext context;

  const _AdvancedFeaturesGrid({required this.context});

  @override
  Widget build(BuildContext context) {
    final features = [
      _AdvancedFeature(
        icon: Icons.games,
        label: 'Mini Oyunlar',
        route: '/mini-games',
      ),
      _AdvancedFeature(
        icon: Icons.leaderboard,
        label: 'Leaderboard',
        route: '/leaderboard',
      ),
      _AdvancedFeature(icon: Icons.stars, label: 'Rozetler', route: '/badges'),
      _AdvancedFeature(
        icon: Icons.language,
        label: '3D Creator',
        route: '/3d-creator',
      ),
      _AdvancedFeature(
        icon: Icons.edit_location,
        label: 'Harita Editörü',
        route: '/map-editor',
      ),
      _AdvancedFeature(
        icon: Icons.image,
        label: 'Fotoğraf Filtreleri',
        route: '/photo-filters',
      ),
      _AdvancedFeature(
        icon: Icons.live_tv,
        label: 'Canlı Etkinlikler',
        route: '/live-events',
      ),
      _AdvancedFeature(
        icon: Icons.videogame_asset,
        label: 'AR Multiplayer',
        route: '/ar-multiplayer',
      ),
    ];

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: features.map((feature) {
        return _AdvancedFeatureCard(feature: feature);
      }).toList(),
    );
  }
}

class _AdvancedFeature {
  final IconData icon;
  final String label;
  final String route;

  _AdvancedFeature({
    required this.icon,
    required this.label,
    required this.route,
  });
}

class _AdvancedFeatureCard extends StatelessWidget {
  final _AdvancedFeature feature;

  const _AdvancedFeatureCard({required this.feature});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, feature.route);
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.neonCyan.withValues(alpha: 0.3)),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.neonCyan.withValues(alpha: 0.12),
              AppTheme.neonPink.withValues(alpha: 0.08),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(feature.icon, color: AppTheme.neonCyan, size: 40),
            const SizedBox(height: 12),
            Text(
              feature.label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tüm İleri Seviye Özellikleri Gösterir
Widget _buildAllAdvancedFeatures(BuildContext context) {
  final allFeatures = [
    // Sosyal & Çok Oyunculu
    _AdvancedFeatureItem(
      'Çok Oyunculu Mücadeleler',
      Icons.emoji_events,
      Colors.amber[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MultiplayerChallengesScreen(),
          ),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Sosyal Keşif Turları',
      Icons.groups,
      Colors.green[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SocialToursScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Arkadaş Sistemi',
      Icons.people,
      Colors.pink[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FriendsScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'AR Multiplayer',
      Icons.view_in_ar,
      Colors.deepPurple[500]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ARMultiplayerScreen()),
        );
      },
    ),

    // Oyunlaştırma & Macera
    _AdvancedFeatureItem(
      'Görev Sistemi',
      Icons.assignment,
      Colors.orange[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const QuestSystemScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Hazine Avı',
      Icons.map_outlined,
      Colors.brown[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TreasureHuntScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Mini Oyunlar',
      Icons.games,
      Colors.lightBlue[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const MiniGamesScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Lider Tablosu',
      Icons.leaderboard,
      Colors.yellow[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const LeaderboardScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Başarım Rozetleri',
      Icons.military_tech,
      Colors.amber[900]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AchievementBadgesScreen()),
        );
      },
    ),

    // Yaratıcı Araçlar
    _AdvancedFeatureItem(
      '3D Model Oluşturucu',
      Icons.view_in_ar,
      Colors.cyan[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ThreeDModelCreatorScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Özel Harita Editörü',
      Icons.edit_location,
      Colors.teal[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CustomMapEditorScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Fotoğraf Filtreleri',
      Icons.filter_vintage,
      Colors.purple[500]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const PhotoFiltersScreen()),
        );
      },
    ),

    // Altın Arama & Madencilik
    _AdvancedFeatureItem(
      '⛏️ Altın Arama Rehberi',
      Icons.diamond,
      Colors.amber[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GoldMiningScreen()),
        );
      },
    ),

    // Tarih ve Medeniyetler
    _AdvancedFeatureItem(
      '🏛️ Tarih ve Medeniyetler',
      Icons.account_balance,
      Colors.brown[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AncientHistoryHubScreen()),
        );
      },
    ),

    // Profesyonel Araçlar (Çok Yakında)
    _AdvancedFeatureItem(
      'Arkeolojik Saha Simülatörü',
      Icons.construction,
      Colors.orange[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SiteSimulatorScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Tarihleme Hesaplayıcı',
      Icons.science,
      Colors.blue[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const DatingCalculatorScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Restorasyon Planlayıcı',
      Icons.architecture,
      Colors.brown[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const RestorationPlannerScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Saha Notları & Eskizler',
      Icons.draw,
      Colors.green[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const FieldNotesScreen()),
        );
      },
    ),

    // Analitik & İçgörüler (Çok Yakında)
    _AdvancedFeatureItem(
      'Ziyaret Isı Haritaları',
      Icons.thermostat,
      Colors.red[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HeatMapScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Kişiselleştirilmiş Öneriler',
      Icons.recommend,
      Colors.purple[700]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const PersonalizedRecommendationsScreen(),
          ),
        );
      },
    ),

    // İleri Seviye Deneyimler (Çok Yakında)
    _AdvancedFeatureItem(
      'VR Tarihi Deneyimler',
      Icons.vrpano,
      Colors.deepPurple[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const VRHistoricalExperiencesScreen(),
          ),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Hologram Projeksiyon',
      Icons.layers,
      Colors.cyan[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const HologramProjectionScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Sesli Rehberler',
      Icons.spatial_audio,
      Colors.teal[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AudioGuides3DScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Zaman Yolculuğu Simülatörü',
      Icons.av_timer,
      Colors.amber[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TimeTravelSimulatorScreen()),
        );
      },
    ),

    // Simülasyon & Laboratuvar (Çok Yakında)
    _AdvancedFeatureItem(
      'İklim Simülatörü',
      Icons.cloud,
      Colors.blue[600]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ClimateSimulatorScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Sanal Laboratuvar',
      Icons.biotech,
      Colors.green[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const VirtualLaboratoryScreen()),
        );
      },
    ),
    _AdvancedFeatureItem(
      'Araştırma Projeleri',
      Icons.search,
      Colors.purple[800]!,
      () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ResearchProjectsScreen()),
        );
      },
    ),
  ];

  return GridView.count(
    crossAxisCount: 2,
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    mainAxisSpacing: 12,
    crossAxisSpacing: 12,
    childAspectRatio: 1.3,
    children: allFeatures.map((feature) {
      return Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: feature.onTap,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  feature.color.withOpacity(0.9),
                  feature.color.withOpacity(0.7),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: feature.color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(feature.icon, size: 28, color: Colors.white),
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: Text(
                    feature.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.1,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 3,
                        ),
                      ],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }).toList(),
  );
}

class _AdvancedFeatureItem {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _AdvancedFeatureItem(this.title, this.icon, this.color, this.onTap);
}
