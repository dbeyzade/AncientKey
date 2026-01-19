import 'package:flutter/material.dart';

class HeatMapScreen extends StatefulWidget {
  const HeatMapScreen({super.key});

  @override
  State<HeatMapScreen> createState() => _HeatMapScreenState();
}

class _HeatMapScreenState extends State<HeatMapScreen> {
  String selectedPeriod = 'today';
  String selectedMetric = 'visits';

  final Map<String, String> periods = {
    'today': 'Bugün',
    'week': 'Bu Hafta',
    'month': 'Bu Ay',
    'year': 'Bu Yıl',
  };

  final Map<String, String> metrics = {
    'visits': 'Ziyaret Sayısı',
    'duration': 'Kalış Süresi',
    'favorites': 'Favori Ekleme',
    'shares': 'Paylaşımlar',
  };

  final List<Map<String, dynamic>> locations = [
    {
      'name': 'Efes Antik Kenti',
      'visits': 2500,
      'duration': 45,
      'favorites': 850,
      'shares': 320,
      'region': 'Ege',
    },
    {
      'name': 'Kapadokya',
      'visits': 3200,
      'duration': 60,
      'favorites': 1200,
      'shares': 580,
      'region': 'İç Anadolu',
    },
    {
      'name': 'Pamukkale',
      'visits': 2800,
      'duration': 35,
      'favorites': 950,
      'shares': 420,
      'region': 'Ege',
    },
    {
      'name': 'Göbeklitepe',
      'visits': 1800,
      'duration': 40,
      'favorites': 720,
      'shares': 280,
      'region': 'Güneydoğu Anadolu',
    },
    {
      'name': 'Troia Antik Kenti',
      'visits': 1500,
      'duration': 30,
      'favorites': 550,
      'shares': 180,
      'region': 'Marmara',
    },
    {
      'name': 'Aspendos Antik Tiyatrosu',
      'visits': 1200,
      'duration': 25,
      'favorites': 480,
      'shares': 150,
      'region': 'Akdeniz',
    },
    {
      'name': 'Nemrut Dağı',
      'visits': 1400,
      'duration': 50,
      'favorites': 680,
      'shares': 240,
      'region': 'Güneydoğu Anadolu',
    },
    {
      'name': 'Hierapolis',
      'visits': 1600,
      'duration': 38,
      'favorites': 620,
      'shares': 210,
      'region': 'Ege',
    },
    {
      'name': 'Pergamon',
      'visits': 1100,
      'duration': 32,
      'favorites': 450,
      'shares': 140,
      'region': 'Ege',
    },
    {
      'name': 'Hattuşa',
      'visits': 900,
      'duration': 42,
      'favorites': 380,
      'shares': 110,
      'region': 'İç Anadolu',
    },
  ];

  @override
  Widget build(BuildContext context) {
    // Sort locations by selected metric
    final sortedLocations = List<Map<String, dynamic>>.from(locations)
      ..sort(
        (a, b) =>
            (b[selectedMetric] as num).compareTo(a[selectedMetric] as num),
      );

    final maxValue = sortedLocations.first[selectedMetric] as num;
    final minValue = sortedLocations.last[selectedMetric] as num;

    return Scaffold(
      appBar: AppBar(
        title: const Text('🌡️ Ziyaret Isı Haritaları'),
        backgroundColor: Colors.red[800],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Info Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.red[700]!, Colors.orange[600]!],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.white, size: 32),
                  SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Popüler destinasyonları ısı haritasıyla keşfedin. Daha sıcak renkler daha yüksek aktiviteyi gösterir.',
                      style: TextStyle(color: Colors.white, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Period Selector
            const Text(
              'Zaman Aralığı',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: periods.entries.map((entry) {
                  final isSelected = selectedPeriod == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => selectedPeriod = entry.key),
                      label: Text(entry.value),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.red[700],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Metric Selector
            const Text(
              'Metrik',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: metrics.entries.map((entry) {
                  final isSelected = selectedMetric == entry.key;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: isSelected,
                      onSelected: (_) =>
                          setState(() => selectedMetric = entry.key),
                      label: Text(entry.value),
                      backgroundColor: Colors.grey[200],
                      selectedColor: Colors.orange[700],
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Summary Stats
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _StatColumn(
                    'Toplam',
                    '${sortedLocations.fold<num>(0, (sum, loc) => sum + loc[selectedMetric])}',
                    Colors.blue,
                  ),
                  _StatColumn(
                    'Ortalama',
                    (sortedLocations.fold<num>(
                              0,
                              (sum, loc) => sum + loc[selectedMetric],
                            ) /
                            sortedLocations.length)
                        .toStringAsFixed(0),
                    Colors.green,
                  ),
                  _StatColumn('En Yüksek', '$maxValue', Colors.red),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Heat Map Legend
            Row(
              children: [
                const Text('Düşük', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    height: 20,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue[200]!,
                          Colors.green[300]!,
                          Colors.yellow[400]!,
                          Colors.orange[500]!,
                          Colors.red[700]!,
                        ],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                const Text('Yüksek', style: TextStyle(fontSize: 12)),
              ],
            ),
            const SizedBox(height: 24),

            // Heat Map List
            const Text(
              'Destinasyonlar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ...sortedLocations.asMap().entries.map((entry) {
              final index = entry.key;
              final location = entry.value;
              final value = location[selectedMetric] as num;
              final intensity = (value - minValue) / (maxValue - minValue);

              final color = _getHeatColor(intensity);

              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: color.withOpacity(0.15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: color, width: 2),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  location['name'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  location['region'],
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: color,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              _getMetricLabel(value),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Progress Bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: intensity,
                          backgroundColor: Colors.grey[300],
                          color: color,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Color _getHeatColor(double intensity) {
    if (intensity > 0.8) return Colors.red[700]!;
    if (intensity > 0.6) return Colors.orange[600]!;
    if (intensity > 0.4) return Colors.yellow[700]!;
    if (intensity > 0.2) return Colors.green[500]!;
    return Colors.blue[400]!;
  }

  String _getMetricLabel(num value) {
    switch (selectedMetric) {
      case 'visits':
        return '$value';
      case 'duration':
        return '${value}dk';
      case 'favorites':
        return '$value';
      case 'shares':
        return '$value';
      default:
        return '$value';
    }
  }

  Widget _StatColumn(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }
}
