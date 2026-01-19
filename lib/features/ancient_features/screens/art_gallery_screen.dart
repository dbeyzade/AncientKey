import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/art_gallery_service.dart';

final artGalleryProvider = FutureProvider<List<ArtPiece>>((ref) async {
  return await ArtGalleryService().getAllArtPieces();
});

final artCivilizationFilterProvider = StateProvider<String?>((ref) => null);

class ArtGalleryScreen extends ConsumerWidget {
  const ArtGalleryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artAsync = ref.watch(artGalleryProvider);
    final selectedCiv = ref.watch(artCivilizationFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antik Sanat Galerisi'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(artCivilizationFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tümü')),
              const PopupMenuItem(value: 'Antik Yunan', child: Text('Antik Yunan')),
              const PopupMenuItem(value: 'Helenistik Yunan', child: Text('Helenistik Yunan')),
              const PopupMenuItem(value: 'Antik Mısır', child: Text('Antik Mısır')),
              const PopupMenuItem(value: 'Antik Roma', child: Text('Antik Roma')),
              const PopupMenuItem(value: 'Sümer', child: Text('Sümer')),
              const PopupMenuItem(value: 'Babil', child: Text('Babil')),
              const PopupMenuItem(value: 'Asur', child: Text('Asur')),
              const PopupMenuItem(value: 'Gupta Hindistan', child: Text('Hint Sanatı')),
              const PopupMenuItem(value: 'Qin Çin', child: Text('Çin Sanatı')),
              const PopupMenuItem(value: 'Maya', child: Text('Maya')),
              const PopupMenuItem(value: 'Aztek', child: Text('Aztek')),
              const PopupMenuItem(value: 'Osmanlı', child: Text('Osmanlı')),
              const PopupMenuItem(value: 'Edo Japonya', child: Text('Japon Sanatı')),
            ],
          ),
        ],
      ),
      body: artAsync.when(
        data: (artPieces) {
          final filtered = selectedCiv == null
              ? artPieces
              : artPieces.where((a) => a.civilization.contains(selectedCiv)).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Sanat eseri bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final art = filtered[index];
              return _ArtCard(art: art);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}

class _ArtCard extends StatelessWidget {
  final ArtPiece art;

  const _ArtCard({required this.art});

  Color _getCivilizationColor() {
    if (art.civilization.contains('Yunan')) return Colors.blue;
    if (art.civilization.contains('Mısır')) return Colors.amber;
    if (art.civilization.contains('Roma')) return Colors.red;
    if (art.civilization.contains('Sümer') || art.civilization.contains('Babil') || art.civilization.contains('Asur')) {
      return Colors.brown;
    }
    if (art.civilization.contains('Hint')) return Colors.orange;
    if (art.civilization.contains('Çin')) return Colors.pink;
    if (art.civilization.contains('Maya') || art.civilization.contains('Aztek')) return Colors.green;
    if (art.civilization.contains('Osmanlı') || art.civilization.contains('Safevi')) return Colors.purple;
    if (art.civilization.contains('Japon') || art.civilization.contains('Edo') || art.civilization.contains('Heian')) {
      return Colors.indigo;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ArtDetailScreen(art: art),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getCivilizationColor().withOpacity(0.1),
                _getCivilizationColor().withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCivilizationColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.palette, color: _getCivilizationColor(), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          art.title,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          art.artist,
                          style: TextStyle(fontSize: 14, color: Colors.grey[700], fontStyle: FontStyle.italic),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCivilizationColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      art.civilization,
                      style: TextStyle(fontSize: 12, color: _getCivilizationColor(), fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    art.period,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                art.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (art.location != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        art.location!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class ArtDetailScreen extends StatelessWidget {
  final ArtPiece art;

  const ArtDetailScreen({super.key, required this.art});

  Color _getCivilizationColor() {
    if (art.civilization.contains('Yunan')) return Colors.blue;
    if (art.civilization.contains('Mısır')) return Colors.amber;
    if (art.civilization.contains('Roma')) return Colors.red;
    if (art.civilization.contains('Sümer') || art.civilization.contains('Babil') || art.civilization.contains('Asur')) {
      return Colors.brown;
    }
    if (art.civilization.contains('Hint')) return Colors.orange;
    if (art.civilization.contains('Çin')) return Colors.pink;
    if (art.civilization.contains('Maya') || art.civilization.contains('Aztek')) return Colors.green;
    if (art.civilization.contains('Osmanlı') || art.civilization.contains('Safevi')) return Colors.purple;
    if (art.civilization.contains('Japon') || art.civilization.contains('Edo') || art.civilization.contains('Heian')) {
      return Colors.indigo;
    }
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(art.title),
        backgroundColor: _getCivilizationColor(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      _getCivilizationColor().withOpacity(0.2),
                      _getCivilizationColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.museum, size: 80, color: _getCivilizationColor()),
                    const SizedBox(height: 16),
                    Text(
                      art.title,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      art.artist,
                      style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Medeniyet', art.civilization, Icons.public, _getCivilizationColor()),
            _buildInfoCard('Dönem', art.period, Icons.calendar_today, Colors.purple),
            _buildInfoCard('Açıklama', art.description, Icons.description, Colors.blue),
            if (art.location != null)
              _buildInfoCard('Konum/Teknik', art.location!, Icons.location_on, Colors.red),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              content,
              style: const TextStyle(fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
