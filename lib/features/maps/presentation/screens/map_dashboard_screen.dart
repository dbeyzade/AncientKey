import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo_projection.dart';
import '../../../../core/widgets/cyber_background.dart';
import '../../../favorites/favorites_notifier.dart';
import '../../../location/geocoding_service.dart';
import '../../../location/location_providers.dart';
import '../../data/map_providers.dart';
import '../../domain/ancient_map.dart';
import '../widgets/map_card.dart';
import 'map_detail_screen.dart';

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
    final maps = ref.watch(filteredMapsProvider);
    final nearby = ref.watch(nearbyMapsProvider);
    final favorites = ref.watch(favoritesProvider);
    final locationAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      body: Stack(
        children: [
          const CyberBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
                final mapHeight = isLandscape ? 160.0 : 260.0;
                
                return SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                                gradient: LinearGradient(
                                  colors: [
                                    AppTheme.neonCyan.withValues(alpha: 0.25),
                                    AppTheme.neonPink.withValues(alpha: 0.18),
                                  ],
                                ),
                              ),
                              child: Text(
                                'AncientKey • Siber Atlas',
                                style: theme.textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () => ref.refresh(currentPositionProvider),
                              icon: const Icon(Icons.my_location_rounded),
                              tooltip: 'Konumumu al',
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                decoration: const InputDecoration(
                                  hintText: 'Adres, il veya antik kent ara...',
                                  prefixIcon: Icon(Icons.search),
                                ),
                                onChanged: (value) => ref.read(searchQueryProvider.notifier).state = value,
                              ),
                            ),
                            const SizedBox(width: 8),
                            if (ref.watch(searchQueryProvider).trim().isNotEmpty)
                              ElevatedButton.icon(
                                onPressed: () async {
                                  final query = ref.read(searchQueryProvider).trim();
                                  final filteredMaps = ref.read(filteredMapsProvider);
                                  
                                  // Önce filtrelenmiş haritalara bak
                                  if (filteredMaps.isNotEmpty && _mapPanelKey.currentState != null) {
                                    _mapPanelKey.currentState!.mapController.move(
                                      filteredMaps.first.center,
                                      8,
                                    );
                                  } else {
                                    // Eğer harita bulunamadıysa, geocoding ile adresi çöz
                                    final coordinates = await GeocodingService.getCoordinatesFromAddress(query);
                                    if (coordinates != null && _mapPanelKey.currentState != null) {
                                      _mapPanelKey.currentState!.mapController.move(
                                        coordinates,
                                        10,
                                      );
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$query konumuna gidiliyor')),
                                        );
                                      }
                                    } else {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Adres bulunamadı')),
                                        );
                                      }
                                    }
                                  }
                                },
                                icon: const Icon(Icons.navigation),
                                label: const Text('Git'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppTheme.neonCyan,
                                  foregroundColor: Colors.black,
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 10),
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
                            _StatusChip(
                              icon: Icons.favorite,
                              label: '${favorites.length} favori',
                              color: AppTheme.neonPink,
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        _MapPanel(
                          key: _mapPanelKey,
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
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                );
              },
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
                          border: Border.all(color: AppTheme.neonCyan.withValues(alpha: 0.7)),
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
                            style: Theme.of(context).textTheme.labelMedium?.copyWith(
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.icon, required this.label, required this.color});

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
            style: Theme.of(context).textTheme.labelSmall?.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }
}
