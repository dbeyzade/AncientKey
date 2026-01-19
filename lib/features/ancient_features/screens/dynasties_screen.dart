import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DynastiesScreen extends ConsumerWidget {
  const DynastiesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dynasties = _getSampleDynasties();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Hanedanlar'),
        backgroundColor: Colors.brown[800],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dynasties.length,
        itemBuilder: (context, index) {
          final dynasty = dynasties[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 4,
            child: ExpansionTile(
              leading: Icon(Icons.account_balance, color: Colors.amber[700], size: 32),
              title: Text(
                dynasty['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              subtitle: Text(dynasty['period']!),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildInfoRow('Kurucu', dynasty['founder']!),
                      _buildInfoRow('Başkent', dynasty['capital']!),
                      const SizedBox(height: 8),
                      Text(
                        dynasty['description']!,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value),
        ],
      ),
    );
  }

  List<Map<String, String>> _getSampleDynasties() {
    return [
      {
        'name': 'Osmanlı Hanedanı',
        'period': '1299 - 1922',
        'founder': 'Osman Bey',
        'capital': 'İstanbul',
        'description': '600 yıldan fazla süren, 36 padişahın hüküm sürdüğü güçlü bir imparatorluk.',
      },
      {
        'name': 'Ptolemaios Hanedanı',
        'period': 'MÖ 305 - MÖ 30',
        'founder': 'I. Ptolemaios',
        'capital': 'İskenderiye',
        'description': 'Büyük İskender\'in generallerinden Ptolemaios tarafından kurulan Mısır hanedanı.',
      },
      {
        'name': 'Ming Hanedanı',
        'period': '1368 - 1644',
        'founder': 'Hongwu İmparatoru',
        'capital': 'Pekin',
        'description': 'Çin\'in altın çağı, sanat ve bilim alanında büyük gelişmeler.',
      },
      {
        'name': 'Habsburg Hanedanı',
        'period': '1273 - 1918',
        'founder': 'Rudolf I',
        'capital': 'Viyana',
        'description': 'Avrupa\'nın en güçlü hanedan ailelerinden biri, 600 yıldan fazla hüküm sürdü.',
      },
    ];
  }
}
