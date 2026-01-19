import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/costumes_service.dart';

final costumesProvider = FutureProvider<List<Costume>>((ref) async {
  return await CostumesService().getAllCostumes();
});

final costumeCivilizationFilterProvider = StateProvider<String?>((ref) => null);

class CostumesScreen extends ConsumerWidget {
  const CostumesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costumesAsync = ref.watch(costumesProvider);
    final selectedCiv = ref.watch(costumeCivilizationFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dönem Kıyafetleri'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(costumeCivilizationFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tümü')),
              const PopupMenuItem(value: 'Antik Yunan', child: Text('Antik Yunan')),
              const PopupMenuItem(value: 'Antik Mısır', child: Text('Antik Mısır')),
              const PopupMenuItem(value: 'Antik Roma', child: Text('Antik Roma')),
              const PopupMenuItem(value: 'Sümer', child: Text('Sümer/Mezopotamya')),
              const PopupMenuItem(value: 'Viking', child: Text('Viking')),
              const PopupMenuItem(value: 'Japonya', child: Text('Antik Japonya')),
              const PopupMenuItem(value: 'Çin', child: Text('Antik Çin')),
              const PopupMenuItem(value: 'Hindistan', child: Text('Antik Hindistan')),
              const PopupMenuItem(value: 'Maya', child: Text('Maya/Aztek')),
              const PopupMenuItem(value: 'Osmanlı', child: Text('Osmanlı')),
              const PopupMenuItem(value: 'Pers', child: Text('Pers')),
            ],
          ),
        ],
      ),
      body: costumesAsync.when(
        data: (costumes) {
          final filtered = selectedCiv == null
              ? costumes
              : costumes.where((c) => c.civilization.contains(selectedCiv)).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Kıyafet bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final costume = filtered[index];
              return _CostumeCard(costume: costume);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}

class _CostumeCard extends StatelessWidget {
  final Costume costume;

  const _CostumeCard({required this.costume});

  Color _getCivilizationColor() {
    if (costume.civilization.contains('Yunan')) return Colors.blue;
    if (costume.civilization.contains('Mısır')) return Colors.amber;
    if (costume.civilization.contains('Roma')) return Colors.red;
    if (costume.civilization.contains('Sümer') || costume.civilization.contains('Asur')) return Colors.brown;
    if (costume.civilization.contains('Viking')) return Colors.blueGrey;
    if (costume.civilization.contains('Japon') || costume.civilization.contains('Heian') || costume.civilization.contains('Feudal')) {
      return Colors.pink;
    }
    if (costume.civilization.contains('Çin') || costume.civilization.contains('Han') || costume.civilization.contains('Ming')) {
      return Colors.red[800]!;
    }
    if (costume.civilization.contains('Hint')) return Colors.orange;
    if (costume.civilization.contains('Maya') || costume.civilization.contains('Aztek')) return Colors.green;
    if (costume.civilization.contains('Osmanlı')) return Colors.purple;
    if (costume.civilization.contains('Pers')) return Colors.indigo;
    return Colors.grey;
  }

  IconData _getCostumeIcon() {
    if (costume.name.contains('Zırh') || costume.name.contains('Yoroi') || costume.name.contains('Centurion')) {
      return Icons.shield;
    }
    if (costume.name.contains('Başlık') || costume.name.contains('Nemes') || costume.name.contains('Tiara')) {
      return Icons.whatshot;
    }
    return Icons.checkroom;
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
              builder: (context) => CostumeDetailScreen(costume: costume),
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
                    child: Icon(_getCostumeIcon(), color: _getCivilizationColor(), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          costume.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          costume.civilization,
                          style: TextStyle(
                            fontSize: 14,
                            color: _getCivilizationColor(),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                costume.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  if (costume.socialClass != null) ...[
                    Icon(Icons.people, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        costume.socialClass!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ],
              ),
              if (costume.materials != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.texture, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        costume.materials!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
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

class CostumeDetailScreen extends StatelessWidget {
  final Costume costume;

  const CostumeDetailScreen({super.key, required this.costume});

  Color _getCivilizationColor() {
    if (costume.civilization.contains('Yunan')) return Colors.blue;
    if (costume.civilization.contains('Mısır')) return Colors.amber;
    if (costume.civilization.contains('Roma')) return Colors.red;
    if (costume.civilization.contains('Sümer') || costume.civilization.contains('Asur')) return Colors.brown;
    if (costume.civilization.contains('Viking')) return Colors.blueGrey;
    if (costume.civilization.contains('Japon') || costume.civilization.contains('Heian') || costume.civilization.contains('Feudal')) {
      return Colors.pink;
    }
    if (costume.civilization.contains('Çin') || costume.civilization.contains('Han') || costume.civilization.contains('Ming')) {
      return Colors.red[800]!;
    }
    if (costume.civilization.contains('Hint')) return Colors.orange;
    if (costume.civilization.contains('Maya') || costume.civilization.contains('Aztek')) return Colors.green;
    if (costume.civilization.contains('Osmanlı')) return Colors.purple;
    if (costume.civilization.contains('Pers')) return Colors.indigo;
    return Colors.grey;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(costume.name),
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
                    Icon(Icons.checkroom, size: 80, color: _getCivilizationColor()),
                    const SizedBox(height: 16),
                    Text(
                      costume.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: _getCivilizationColor().withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        costume.civilization,
                        style: TextStyle(
                          color: _getCivilizationColor(),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Açıklama', costume.description, Icons.description, Colors.blue),
            _buildInfoCard('Dönem', costume.period, Icons.calendar_today, Colors.purple),
            if (costume.socialClass != null)
              _buildInfoCard('Kim Giyerdi', costume.socialClass!, Icons.people, Colors.green),
            if (costume.materials != null)
              _buildInfoCard('Materyal ve Renkler', costume.materials!, Icons.texture, Colors.orange),
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
