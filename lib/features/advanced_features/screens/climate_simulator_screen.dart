import 'package:flutter/material.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class ClimateSimulatorScreen extends StatefulWidget {
  const ClimateSimulatorScreen({super.key});

  @override
  State<ClimateSimulatorScreen> createState() => _ClimateSimulatorScreenState();
}

class _ClimateSimulatorScreenState extends State<ClimateSimulatorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _weatherController;
  late Animation<double> _weatherAnimation;
  String _selectedRegion = 'Mısır';
  double _temperature = 45.0;

  @override
  void initState() {
    super.initState();
    _weatherController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _weatherAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _weatherController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _weatherController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('İklim Simülatörü'),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const CyberBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Weather Display
                  Container(
                    height: 280,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.red.withOpacity(0.2),
                          Colors.orange.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  _selectedRegion,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Antik Dönem İklimi',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.white.withOpacity(0.6),
                                  ),
                                ),
                              ],
                            ),
                            AnimatedBuilder(
                              animation: _weatherAnimation,
                              builder: (context, child) => Transform.scale(
                                scale: _weatherAnimation.value,
                                child: Icon(
                                  _getWeatherIcon(),
                                  size: 60,
                                  color: Colors.orange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Sıcaklık',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.white.withOpacity(0.7),
                                    ),
                                  ),
                                  Text(
                                    '${_temperature.toStringAsFixed(1)}°C',
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.orange,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: LinearProgressIndicator(
                                  value: _temperature / 50,
                                  minHeight: 8,
                                  backgroundColor: Colors.orange.withOpacity(
                                    0.2,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.orange.withOpacity(0.8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Region Selection
                  const Text(
                    'Bölge Seçin',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildRegionSelector(),

                  const SizedBox(height: 24),

                  // Climate Details
                  const Text(
                    'İklim Özellikleri',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildClimateDetails(),

                  const SizedBox(height: 24),

                  // Simulate Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showSimulationDialog();
                      },
                      icon: const Icon(Icons.cloud),
                      label: const Text('İklim Simülasyonunu Başlat'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegionSelector() {
    final regions = ['Mısır', 'Mezopotamya', 'Yunanistan', 'Roma'];
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: regions
            .map(
              (region) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedRegion = region;
                      _temperature = _getTemperatureForRegion(region);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedRegion == region
                            ? Colors.orange.withOpacity(0.6)
                            : Colors.orange.withOpacity(0.2),
                      ),
                      color: _selectedRegion == region
                          ? Colors.orange.withOpacity(0.15)
                          : Colors.white.withOpacity(0.03),
                    ),
                    child: Text(
                      region,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _selectedRegion == region
                            ? Colors.orange
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _buildClimateDetails() {
    final details = _getClimateDetailsForRegion(_selectedRegion);
    return details
        .map(
          (detail) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.withOpacity(0.2)),
                color: Colors.white.withOpacity(0.03),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      detail['icon'] as IconData,
                      color: Colors.orange,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          detail['label'] as String,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          detail['value'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  List<Map<String, dynamic>> _getClimateDetailsForRegion(String region) {
    switch (region) {
      case 'Mısır':
        return [
          {
            'icon': Icons.water_drop,
            'label': 'Yağış',
            'value': 'Çok Az (Kuraklık)',
          },
          {'icon': Icons.air, 'label': 'Rüzgar', 'value': 'Kuzeye doğru'},
          {'icon': Icons.cloud, 'label': 'Nem', 'value': 'Düşük (%20-%30)'},
          {
            'icon': Icons.waves,
            'label': 'Nil Taşkını',
            'value': 'Yaz-Sonbahar',
          },
        ];
      case 'Mezopotamya':
        return [
          {
            'icon': Icons.water_drop,
            'label': 'Yağış',
            'value': 'Az-Orta (400-600mm)',
          },
          {'icon': Icons.air, 'label': 'Rüzgar', 'value': 'Kuzeybatı'},
          {'icon': Icons.cloud, 'label': 'Nem', 'value': 'Orta (%40-%60)'},
          {
            'icon': Icons.waves,
            'label': 'Su Kaynağı',
            'value': 'Fırat & Dicle',
          },
        ];
      case 'Yunanistan':
        return [
          {
            'icon': Icons.water_drop,
            'label': 'Yağış',
            'value': 'Kış Aylarında',
          },
          {'icon': Icons.air, 'label': 'Rüzgar', 'value': 'Etesian Rüzgarları'},
          {'icon': Icons.cloud, 'label': 'Nem', 'value': 'Ilıman (%50-%70)'},
          {'icon': Icons.waves, 'label': 'Deniz Etkisi', 'value': 'Güçlü'},
        ];
      case 'Roma':
        return [
          {'icon': Icons.water_drop, 'label': 'Yağış', 'value': 'Dağınık'},
          {'icon': Icons.air, 'label': 'Rüzgar', 'value': 'Değişken'},
          {'icon': Icons.cloud, 'label': 'Nem', 'value': 'Değişken (%30-%80)'},
          {
            'icon': Icons.waves,
            'label': 'Akdeniz',
            'value': 'Moderatör Etkisi',
          },
        ];
      default:
        return [];
    }
  }

  double _getTemperatureForRegion(String region) {
    switch (region) {
      case 'Mısır':
        return 45.0;
      case 'Mezopotamya':
        return 38.0;
      case 'Yunanistan':
        return 32.0;
      case 'Roma':
        return 28.0;
      default:
        return 30.0;
    }
  }

  IconData _getWeatherIcon() {
    if (_selectedRegion == 'Mısır') {
      return Icons.wb_sunny;
    } else if (_selectedRegion == 'Mezopotamya') {
      return Icons.wb_sunny;
    } else if (_selectedRegion == 'Yunanistan') {
      return Icons.cloud;
    } else {
      return Icons.cloud_queue;
    }
  }

  void _showSimulationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Row(
          children: [
            Icon(Icons.cloud, color: Colors.orange),
            SizedBox(width: 8),
            Text('İklim Simülasyonu'),
          ],
        ),
        content: Text(
          '$_selectedRegion bölgesinin antik dönem iklim koşullarını simüle etmek istediğinize emin misiniz?',
          style: const TextStyle(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$_selectedRegion iklimi simüle ediliyor...'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Başlat'),
          ),
        ],
      ),
    );
  }
}
