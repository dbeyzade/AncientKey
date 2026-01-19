import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/rituals_service.dart';

final ritualsProvider = FutureProvider<List<Ritual>>((ref) async {
  return await RitualsService().getAllRituals();
});

final civilizationFilterProvider = StateProvider<String?>((ref) => null);

class RitualsScreen extends ConsumerWidget {
  const RitualsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ritualsAsync = ref.watch(ritualsProvider);
    final selectedCiv = ref.watch(civilizationFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ritüeller ve Törenler'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(civilizationFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tümü')),
              const PopupMenuItem(value: 'Antik Yunan', child: Text('Antik Yunan')),
              const PopupMenuItem(value: 'Antik Mısır', child: Text('Antik Mısır')),
              const PopupMenuItem(value: 'Mezopotamya', child: Text('Mezopotamya')),
              const PopupMenuItem(value: 'Antik Roma', child: Text('Antik Roma')),
              const PopupMenuItem(value: 'Hindu', child: Text('Hindu')),
              const PopupMenuItem(value: 'Vedik Hindistan', child: Text('Vedik Hindistan')),
              const PopupMenuItem(value: 'Budizm', child: Text('Budizm')),
              const PopupMenuItem(value: 'Aztek', child: Text('Aztek')),
              const PopupMenuItem(value: 'İnka', child: Text('İnka')),
              const PopupMenuItem(value: 'Viking/Norse', child: Text('Viking/Norse')),
              const PopupMenuItem(value: 'Antik Japonya', child: Text('Antik Japonya')),
            ],
          ),
        ],
      ),
      body: ritualsAsync.when(
        data: (rituals) {
          final filtered = selectedCiv == null
              ? rituals
              : rituals.where((r) => r.civilization == selectedCiv).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Ritüel bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final ritual = filtered[index];
              return _RitualCard(ritual: ritual);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}

class _RitualCard extends StatelessWidget {
  final Ritual ritual;

  const _RitualCard({required this.ritual});

  Color _getCivilizationColor() {
    switch (ritual.civilization) {
      case 'Antik Yunan':
        return Colors.blue;
      case 'Antik Mısır':
        return Colors.amber;
      case 'Mezopotamya':
        return Colors.brown;
      case 'Antik Roma':
        return Colors.red;
      case 'Hindu':
      case 'Vedik Hindistan':
        return Colors.orange;
      case 'Budizm':
        return Colors.purple;
      case 'Aztek':
        return Colors.green;
      case 'İnka':
        return Colors.teal;
      case 'Viking/Norse':
        return Colors.blueGrey;
      case 'Antik Japonya':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  IconData _getCivilizationIcon() {
    switch (ritual.civilization) {
      case 'Antik Yunan':
        return Icons.account_balance;
      case 'Antik Mısır':
        return Icons.landscape;
      case 'Mezopotamya':
        return Icons.terrain;
      case 'Antik Roma':
        return Icons.museum;
      case 'Hindu':
      case 'Vedik Hindistan':
        return Icons.self_improvement;
      case 'Budizm':
        return Icons.spa;
      case 'Aztek':
      case 'İnka':
        return Icons.park;
      case 'Viking/Norse':
        return Icons.shield;
      case 'Antik Japonya':
        return Icons.temple_buddhist;
      default:
        return Icons.celebration;
    }
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
              builder: (context) => RitualDetailScreen(ritual: ritual),
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
                    child: Icon(_getCivilizationIcon(), color: _getCivilizationColor(), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ritual.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          ritual.civilization,
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
                ritual.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (ritual.timing != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ritual.timing!,
                        style: TextStyle(fontSize: 12, color: Colors.grey[700]),
                      ),
                    ),
                  ],
                ),
              ],
              if (ritual.location != null) ...[
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        ritual.location!,
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

class RitualDetailScreen extends StatelessWidget {
  final Ritual ritual;

  const RitualDetailScreen({super.key, required this.ritual});

  Color _getCivilizationColor() {
    switch (ritual.civilization) {
      case 'Antik Yunan':
        return Colors.blue;
      case 'Antik Mısır':
        return Colors.amber;
      case 'Mezopotamya':
        return Colors.brown;
      case 'Antik Roma':
        return Colors.red;
      case 'Hindu':
      case 'Vedik Hindistan':
        return Colors.orange;
      case 'Budizm':
        return Colors.purple;
      case 'Aztek':
        return Colors.green;
      case 'İnka':
        return Colors.teal;
      case 'Viking/Norse':
        return Colors.blueGrey;
      case 'Antik Japonya':
        return Colors.pink;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ritual.name),
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
                    Text(
                      ritual.name,
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
                        ritual.civilization,
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
            _buildInfoCard('Açıklama', ritual.description, Icons.description, Colors.blue),
            if (ritual.purpose != null)
              _buildInfoCard('Amaç ve Etkinlikler', ritual.purpose!, Icons.flag, Colors.green),
            if (ritual.timing != null)
              _buildInfoCard('Zaman', ritual.timing!, Icons.calendar_today, Colors.purple),
            if (ritual.location != null)
              _buildInfoCard('Konum', ritual.location!, Icons.location_on, Colors.red),
            if (ritual.participants != null)
              _buildInfoCard('Katılımcılar', ritual.participants!, Icons.people, Colors.orange),
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
