import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo_projection.dart';
import '../../../favorites/favorites_notifier.dart';
import '../../../location/location_providers.dart';
import '../../domain/ancient_map.dart';

class MapDetailScreen extends ConsumerWidget {
  const MapDetailScreen({super.key, required this.map});

  final AncientMap map;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final favorites = ref.watch(favoritesProvider);
    final isFavorite = favorites.contains(map.id);
    final locationAsync = ref.watch(currentPositionProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(map.name),
        actions: [
          IconButton(
            onPressed: () => ref.read(favoritesProvider.notifier).toggle(map.id),
            icon: Icon(
              isFavorite ? Icons.favorite_rounded : Icons.favorite_outline,
              color: isFavorite ? AppTheme.neonPink : Colors.white,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => _FullScreenMapViewer(map: map),
                    ),
                  );
                },
                child: Container(
                  height: 360,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0.05),
                        Colors.white.withValues(alpha: 0.03),
                      ],
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Stack(
                          children: [
                            Positioned.fill(
                              child: map.assetPath.endsWith('.svg')
                                  ? SvgPicture.asset(
                                      map.assetPath,
                                      fit: BoxFit.cover,
                                    )
                                  : Image.asset(
                                      map.assetPath,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                            locationAsync.maybeWhen(
                              data: (pos) {
                                if (pos == null) {
                                  return const _OverlayMessage(
                                    text: 'Konum alınamadı',
                                    icon: Icons.location_disabled,
                                  );
                                }
                                final offset = projectLatLng(
                                  LatLng(pos.latitude, pos.longitude),
                                  northWest: map.northWest,
                                  southEast: map.southEast,
                                  size: Size(constraints.maxWidth, constraints.maxHeight),
                                );
                                if (offset == null) {
                                  return const _OverlayMessage(
                                    text: 'Konumun bu haritanın sınırları dışında',
                                    icon: Icons.pivot_table_chart,
                                  );
                                }
                                return Positioned(
                                  left: offset.dx - 10,
                                  top: offset.dy - 10,
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withValues(alpha: 0.6),
                                          borderRadius: BorderRadius.circular(12),
                                          border: Border.all(color: AppTheme.neonCyan),
                                        ),
                                        child: Text(
                                          'Şu anki noktanız',
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [AppTheme.neonCyan, AppTheme.neonPink],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: AppTheme.neonCyan.withValues(alpha: 0.6),
                                              blurRadius: 18,
                                              spreadRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              orElse: () => const SizedBox.shrink(),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                map.era,
                style: theme.textTheme.titleMedium?.copyWith(color: AppTheme.neonCyan),
              ),
              const SizedBox(height: 8),
              Text(
                map.description,
                style: theme.textTheme.bodyLarge,
              ),
              if (map.highlight != null) ...[
                const SizedBox(height: 10),
                Text(
                  map.highlight!,
                  style: theme.textTheme.bodyMedium?.copyWith(color: AppTheme.neonAmber),
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  ...map.provinces.map(
                    (p) => _Chip(label: p, color: AppTheme.neonCyan.withValues(alpha: 0.16)),
                  ),
                  ...map.tags.map(
                    (t) => _Chip(label: '#$t', color: AppTheme.neonPink.withValues(alpha: 0.18)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              locationAsync.maybeWhen(
                data: (pos) {
                  if (pos == null) {
                    return _InfoRow(
                      icon: Icons.location_off_outlined,
                      text: 'Konum bilgisi yok, harita içi nokta hesaplanamadı.',
                    );
                  }
                  final inside = map.contains(LatLng(pos.latitude, pos.longitude));
                  final distance = distanceKm(map.center, LatLng(pos.latitude, pos.longitude));
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _InfoRow(
                        icon: inside ? Icons.podcasts_rounded : Icons.place_outlined,
                        text: inside
                            ? 'Antik haritanın içindesin, neon işaretçi noktanı gösteriyor.'
                            : 'Yakınlık: ${distance.toStringAsFixed(1)} km • sınırların dışında.',
                      ),
                    ],
                  );
                },
                orElse: () => const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.color});
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Text(label),
    );
  }
}

class _OverlayMessage extends StatelessWidget {
  const _OverlayMessage({required this.text, required this.icon});
  final String text;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      right: 12,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [Icon(icon, size: 16, color: AppTheme.neonCyan), const SizedBox(width: 6), Text(text)],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.neonCyan, size: 18),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}

class _FullScreenMapViewer extends StatelessWidget {
  const _FullScreenMapViewer({required this.map});
  final AncientMap map;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(map.name),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: InteractiveViewer(
        minScale: 0.5,
        maxScale: 4.0,
        child: Center(
          child: map.assetPath.endsWith('.svg')
              ? SvgPicture.asset(
                  map.assetPath,
                  fit: BoxFit.contain,
                )
              : Image.asset(
                  map.assetPath,
                  fit: BoxFit.contain,
                ),
        ),
      ),
    );
  }
}
