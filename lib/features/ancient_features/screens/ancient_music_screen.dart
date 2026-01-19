import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/ancient_music_service.dart';

final ancientMusicProvider = FutureProvider<List<AncientMusic>>((ref) async {
  return await AncientMusicService().getAllMusic();
});

class AncientMusicScreen extends ConsumerWidget {
  const AncientMusicScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final musicAsync = ref.watch(ancientMusicProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Antik Müzik'), elevation: 2),
      body: musicAsync.when(
        data: (musicList) {
          if (musicList.isEmpty) {
            return const Center(child: Text('Müzik bulunamadı'));
          }

          final groupedMusic = <String, List<AncientMusic>>{};
          for (var music in musicList) {
            groupedMusic.putIfAbsent(music.civilization, () => []).add(music);
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: groupedMusic.keys.length,
            itemBuilder: (context, index) {
              final civilization = groupedMusic.keys.elementAt(index);
              final items = groupedMusic[civilization]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Icon(Icons.music_note, color: Colors.purple[700]),
                        const SizedBox(width: 8),
                        Text(
                          civilization,
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.purple[700],
                              ),
                        ),
                      ],
                    ),
                  ),
                  ...items.map((music) => _MusicCard(music: music)),
                  const SizedBox(height: 16),
                ],
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Hata: $error'),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicCard extends StatelessWidget {
  final AncientMusic music;

  const _MusicCard({required this.music});

  Color _getTypeColor(String type) {
    switch (type.toLowerCase()) {
      case 'telli enstrüman':
        return Colors.orange;
      case 'üflemeli enstrüman':
        return Colors.blue;
      case 'vurmalı enstrüman':
        return Colors.red;
      case 'ses':
        return Colors.green;
      case 'müzik türü':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  IconData _getTypeIcon(String type) {
    switch (type.toLowerCase()) {
      case 'telli enstrüman':
        return Icons.piano;
      case 'üflemeli enstrüman':
        return Icons.shower;
      case 'vurmalı enstrüman':
        return Icons.radio_button_checked;
      case 'ses':
        return Icons.record_voice_over;
      case 'müzik türü':
        return Icons.queue_music;
      default:
        return Icons.music_note;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getTypeColor(music.type);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          showDialog(
            context: context,
            builder: (context) =>
                _MusicDetailDialog(music: music, color: color),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: color.withOpacity(0.5), width: 2),
                ),
                child: Icon(_getTypeIcon(music.type), color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      music.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        music.type,
                        style: TextStyle(
                          fontSize: 12,
                          color: color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (music.usage != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        music.usage!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}

class _MusicDetailDialog extends StatelessWidget {
  final AncientMusic music;
  final Color color;

  const _MusicDetailDialog({required this.music, required this.color});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color, color.withOpacity(0.7)],
                ),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.music_note,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          music.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          music.civilization,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _InfoSection(
                      icon: Icons.category,
                      label: 'Tür',
                      value: music.type,
                      color: color,
                    ),
                    if (music.description.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      _InfoSection(
                        icon: Icons.info_outline,
                        label: 'Açıklama',
                        value: music.description,
                        color: color,
                      ),
                    ],
                    if (music.usage != null) ...[
                      const SizedBox(height: 16),
                      _InfoSection(
                        icon: Icons.layers,
                        label: 'Kullanım',
                        value: music.usage!,
                        color: color,
                      ),
                    ],
                    if (music.materials != null) ...[
                      const SizedBox(height: 16),
                      _InfoSection(
                        icon: Icons.build,
                        label: 'Malzeme',
                        value: music.materials!,
                        color: color,
                      ),
                    ],
                    if (music.soundCharacteristics != null) ...[
                      const SizedBox(height: 16),
                      _InfoSection(
                        icon: Icons.graphic_eq,
                        label: 'Ses Özellikleri',
                        value: music.soundCharacteristics!,
                        color: color,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: const Text('KAPAT'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _InfoSection({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 14, height: 1.5)),
      ],
    );
  }
}
