import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/geo_projection.dart';
import '../../../favorites/favorites_notifier.dart';
import '../../../location/location_providers.dart';
import '../../domain/ancient_map.dart';
// Temporarily disabled due to Firebase conflict
// import '../../../ar/ar_view_screen.dart';
import '../../../notes/add_note_photo_bottom_sheet.dart';
import '../../../notes/user_content_view_screen.dart';
import '../../../navigation/route_navigation_screen.dart';
import '../../../comments/comments_screen.dart';
import '../../../audio/audio_guide_player_screen.dart';
import '../../../share/share_experience_service.dart';
import '../../../../core/services/visit_tracking_service.dart';
import '../../../../core/services/achievement_service.dart';

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
              const SizedBox(height: 24),
              // New Features Section
              _buildFeaturesSection(context, ref),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeaturesSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Özellikler',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _FeatureButton(
              icon: Icons.navigation,
              label: 'Navigasyon',
              color: Colors.green,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RouteNavigationScreen(destination: map),
                  ),
                );
              },
            ),
            // AR feature temporarily disabled due to Firebase conflict
            /* _FeatureButton(
              icon: Icons.camera_alt,
              label: 'AR Görünüm',
              color: Colors.purple,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ARViewScreen(mapId: map.id, mapName: map.name),
                  ),
                );
              },
            ), */
            _FeatureButton(
              icon: Icons.note_add,
              label: 'Not/Fotoğraf',
              color: Colors.orange,
              onTap: () async {
                final currentPos = await ref.read(currentPositionProvider.future);
                if (context.mounted && currentPos != null) {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: AddNotePhotoBottomSheet(
                        mapId: map.id,
                        location: LatLng(currentPos.latitude, currentPos.longitude),
                      ),
                    ),
                  );
                }
              },
            ),
            _FeatureButton(
              icon: Icons.photo_library,
              label: 'İçeriklerim',
              color: Colors.blue,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserContentViewScreen(
                      mapId: map.id,
                      mapName: map.name,
                    ),
                  ),
                );
              },
            ),
            _FeatureButton(
              icon: Icons.comment,
              label: 'Yorumlar',
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CommentsScreen(mapId: map.id, mapName: map.name),
                  ),
                );
              },
            ),
            _FeatureButton(
              icon: Icons.headphones,
              label: 'Sesli Rehber',
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AudioGuidePlayerScreen(
                      mapId: map.id,
                      mapName: map.name,
                    ),
                  ),
                );
              },
            ),
            _FeatureButton(
              icon: Icons.share,
              label: 'Paylaş',
              color: Colors.pink,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => ShareMenuBottomSheet(
                    mapId: map.id,
                    mapName: map.name,
                  ),
                );
              },
            ),
            _FeatureButton(
              icon: Icons.check_circle,
              label: 'Ziyaret Et',
              color: Colors.amber,
              onTap: () async {
                final currentPos = await ref.read(currentPositionProvider.future);
                if (currentPos != null) {
                  await ref.read(visitTrackingServiceProvider).markPlaceAsVisited(
                        map.id,
                        LatLng(currentPos.latitude, currentPos.longitude),
                      );
                  await ref.read(achievementServiceProvider).checkAndUnlockAchievements();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('✅ Yer ziyaret edildi olarak işaretlendi!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ],
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

class _FeatureButton extends StatelessWidget {
  const _FeatureButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
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
