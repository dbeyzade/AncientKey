import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';

class HistoricalCharactersScreen extends ConsumerWidget {
  const HistoricalCharactersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final characters = _getSampleCharacters();

    return Scaffold(
      appBar: AppBar(
        title: const Text('👤 Tarihi Karakterler'),
        backgroundColor: Colors.purple[900],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: characters.length,
        itemBuilder: (context, index) {
          final character = characters[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.purple[700],
                child: Text(
                  character['name']![0],
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              title: Text(
                character['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(character['title']!),
                  const SizedBox(height: 4),
                  Text(
                    character['period']!,
                    style: TextStyle(color: AppTheme.neonCyan, fontSize: 12),
                  ),
                ],
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _showCharacterDetail(context, character),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, String>> _getSampleCharacters() {
    return [
      {
        'name': 'Julius Caesar',
        'title': 'Roma İmparatoru',
        'period': 'MÖ 100 - MÖ 44',
        'bio': 'Roma Cumhuriyeti\'nin en güçlü lideri. Galya\'yı fethetti ve Roma tarihini değiştirdi.',
      },
      {
        'name': 'Kleopatra',
        'title': 'Mısır Kraliçesi',
        'period': 'MÖ 69 - MÖ 30',
        'bio': 'Ptolemaios hanedanının son firavunu. Zekası ve diplomasisiyle tanınır.',
      },
      {
        'name': 'Alexander the Great',
        'title': 'Makedonya Kralı',
        'period': 'MÖ 356 - MÖ 323',
        'bio': 'Tarihın en büyük komutanlarından biri. 32 yaşında devasa bir imparatorluk kurdu.',
      },
      {
        'name': 'Hammurabi',
        'title': 'Babil Kralı',
        'period': 'MÖ 1810 - MÖ 1750',
        'bio': 'Ünlü Hammurabi Kanunları\'nın yazarı. İlk yazılı hukuk sistemi.',
      },
      {
        'name': 'Fatih Sultan Mehmet',
        'title': 'Osmanlı Padişahı',
        'period': '1432 - 1481',
        'bio': 'İstanbul\'u fetheden sultan. Doğu ile Batı\'yı birleştiren lider.',
      },
    ];
  }

  void _showCharacterDetail(BuildContext context, Map<String, String> character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(character['name']!),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                character['title']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                character['period']!,
                style: TextStyle(color: AppTheme.neonCyan),
              ),
              const SizedBox(height: 16),
              Text(character['bio']!),
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
