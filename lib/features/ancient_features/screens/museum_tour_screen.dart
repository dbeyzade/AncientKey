import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/museum_tour_service.dart';

final museumTourProvider = FutureProvider<List<Museum>>((ref) async {
  return await MuseumTourService().getAllMuseums();
});

final museumCountryFilterProvider = StateProvider<String?>((ref) => null);

class MuseumTourScreen extends ConsumerWidget {
  const MuseumTourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final museumsAsync = ref.watch(museumTourProvider);
    final selectedCountry = ref.watch(museumCountryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanal Müze Turu'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(museumCountryFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tümü')),
              const PopupMenuItem(value: 'Türkiye', child: Text('Türkiye')),
              const PopupMenuItem(value: 'İngiltere', child: Text('İngiltere')),
              const PopupMenuItem(value: 'Fransa', child: Text('Fransa')),
              const PopupMenuItem(value: 'Yunanistan', child: Text('Yunanistan')),
              const PopupMenuItem(value: 'İtalya', child: Text('İtalya')),
              const PopupMenuItem(value: 'Mısır', child: Text('Mısır')),
              const PopupMenuItem(value: 'ABD', child: Text('ABD')),
              const PopupMenuItem(value: 'Almanya', child: Text('Almanya')),
              const PopupMenuItem(value: 'İspanya', child: Text('İspanya')),
              const PopupMenuItem(value: 'Hollanda', child: Text('Hollanda')),
            ],
          ),
        ],
      ),
      body: museumsAsync.when(
        data: (museums) {
          final filtered = selectedCountry == null
              ? museums
              : museums.where((m) => m.country == selectedCountry).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Müze bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final museum = filtered[index];
              return _MuseumCard(museum: museum);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}

class _MuseumCard extends StatelessWidget {
  final Museum museum;

  const _MuseumCard({required this.museum});

  Color _getCountryColor() {
    switch (museum.country) {
      case 'Türkiye':
        return Colors.red;
      case 'İngiltere':
        return Colors.blue[800]!;
      case 'Fransa':
        return Colors.blue;
      case 'Yunanistan':
        return Colors.lightBlue;
      case 'İtalya':
        return Colors.green;
      case 'Mısır':
        return Colors.amber;
      case 'ABD':
        return Colors.indigo;
      case 'Almanya':
        return Colors.grey[800]!;
      case 'Rusya':
        return Colors.red[900]!;
      case 'İspanya':
        return Colors.orange;
      case 'Meksika':
        return Colors.green[700]!;
      case 'Japonya':
        return Colors.pink;
      case 'Tayvan':
        return Colors.red[700]!;
      case 'Hollanda':
        return Colors.orange[800]!;
      case 'Vatikan':
        return Colors.yellow[700]!;
      case 'Irak':
        return Colors.brown;
      default:
        return Colors.grey;
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
              builder: (context) => MuseumDetailScreen(museum: museum),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getCountryColor().withOpacity(0.1),
                _getCountryColor().withOpacity(0.05),
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
                      color: _getCountryColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.museum, color: _getCountryColor(), size: 28),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          museum.name,
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_city, size: 14, color: _getCountryColor()),
                            const SizedBox(width: 4),
                            Text(
                              '${museum.location}, ${museum.country}',
                              style: TextStyle(
                                fontSize: 13,
                                color: _getCountryColor(),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                museum.description,
                style: const TextStyle(fontSize: 14),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              if (museum.specialCollection != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: _getCountryColor().withOpacity(0.3)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.star, size: 16, color: _getCountryColor()),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          museum.specialCollection!,
                          style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              if (museum.yearFounded != null) ...[
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      'Kuruluş: ${museum.yearFounded}',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
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

class MuseumDetailScreen extends StatelessWidget {
  final Museum museum;

  const MuseumDetailScreen({super.key, required this.museum});

  Color _getCountryColor() {
    switch (museum.country) {
      case 'Türkiye':
        return Colors.red;
      case 'İngiltere':
        return Colors.blue[800]!;
      case 'Fransa':
        return Colors.blue;
      case 'Yunanistan':
        return Colors.lightBlue;
      case 'İtalya':
        return Colors.green;
      case 'Mısır':
        return Colors.amber;
      case 'ABD':
        return Colors.indigo;
      case 'Almanya':
        return Colors.grey[800]!;
      case 'Rusya':
        return Colors.red[900]!;
      case 'İspanya':
        return Colors.orange;
      case 'Meksika':
        return Colors.green[700]!;
      case 'Japonya':
        return Colors.pink;
      case 'Tayvan':
        return Colors.red[700]!;
      case 'Hollanda':
        return Colors.orange[800]!;
      case 'Vatikan':
        return Colors.yellow[700]!;
      case 'Irak':
        return Colors.brown;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(museum.name),
        backgroundColor: _getCountryColor(),
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
                      _getCountryColor().withOpacity(0.2),
                      _getCountryColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Icon(Icons.account_balance, size: 80, color: _getCountryColor()),
                    const SizedBox(height: 16),
                    Text(
                      museum.name,
                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${museum.location}, ${museum.country}',
                      style: TextStyle(fontSize: 18, color: _getCountryColor(), fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoCard('Hakkında', museum.description, Icons.info, Colors.blue),
            if (museum.yearFounded != null)
              _buildInfoCard('Kuruluş Yılı', museum.yearFounded!, Icons.calendar_today, Colors.purple),
            if (museum.specialCollection != null)
              _buildInfoCard('Özel Koleksiyonlar', museum.specialCollection!, Icons.collections, Colors.green),
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
