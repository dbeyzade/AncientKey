import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ArtifactsCollectionScreen extends ConsumerWidget {
  const ArtifactsCollectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artifacts = _getSampleArtifacts();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏺 Eserler Koleksiyonu'),
        backgroundColor: Colors.red[900],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: artifacts.length,
        itemBuilder: (context, index) {
          final artifact = artifacts[index];
          return GestureDetector(
            onTap: () => _showArtifactDetail(context, artifact),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            artifact['color'] as Color,
                            (artifact['color'] as Color).withOpacity(0.6),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          artifact['icon'] as IconData,
                          size: 64,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          artifact['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          artifact['period']!,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  List<Map<String, dynamic>> _getSampleArtifacts() {
    return [
      {
        'name': 'Rosetta Stone',
        'period': 'MÖ 196',
        'material': 'Granit',
        'location': 'British Museum',
        'description':
            'Hiyeroglif yazısının çözülmesini sağlayan taş. Üç dilde yazılmış.',
        'icon': Icons.abc,
        'color': Colors.grey[800],
      },
      {
        'name': 'Truva Hazinesi',
        'period': 'MÖ 2500',
        'material': 'Altın',
        'location': 'Puşkin Müzesi',
        'description': 'Heinrich Schliemann tarafından bulunan altın hazine.',
        'icon': Icons.diamond,
        'color': Colors.amber[700],
      },
      {
        'name': 'Toprakkale Asa Başı',
        'period': 'MÖ 8. yy',
        'material': 'Bronz',
        'location': 'Anadolu Medeniyetleri Müzesi',
        'description': 'Urartu medeniyetine ait bronz asa başı.',
        'icon': Icons.temple_hindu,
        'color': Colors.brown[700],
      },
      {
        'name': 'Çatalhöyük Heykeli',
        'period': 'MÖ 6000',
        'material': 'Kil',
        'location': 'Anadolu Medeniyetleri Müzesi',
        'description': 'Ana tanrıça heykeli, Neolitik dönem.',
        'icon': Icons.face_6,
        'color': Colors.orange[800],
      },
      {
        'name': 'Tutankhamun Maskesi',
        'period': 'MÖ 1323',
        'material': 'Altın',
        'location': 'Kahire Müzesi',
        'description': 'Genç firavunun ünlü altın ölüm maskesi.',
        'icon': Icons.sentiment_very_satisfied,
        'color': Colors.yellow[700],
      },
      {
        'name': 'Persepolis Kabartmaları',
        'period': 'MÖ 515',
        'material': 'Taş',
        'location': 'İran',
        'description': 'Pers İmparatorluğu\'nun görkemli taş kabartmaları.',
        'icon': Icons.landscape,
        'color': Colors.purple[700],
      },
    ];
  }

  void _showArtifactDetail(
    BuildContext context,
    Map<String, dynamic> artifact,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(artifact['name']!),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                artifact['icon'] as IconData,
                size: 64,
                color: artifact['color'] as Color,
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Dönem', artifact['period']!),
              _buildDetailRow('Malzeme', artifact['material']!),
              _buildDetailRow('Konum', artifact['location']!),
              const SizedBox(height: 12),
              Text(artifact['description']!),
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
