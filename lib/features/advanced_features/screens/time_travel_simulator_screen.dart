import 'package:flutter/material.dart';
import 'package:ancientkey/core/theme/app_theme.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class TimeTravelSimulatorScreen extends StatefulWidget {
  const TimeTravelSimulatorScreen({super.key});

  @override
  State<TimeTravelSimulatorScreen> createState() =>
      _TimeTravelSimulatorScreenState();
}

class _TimeTravelSimulatorScreenState extends State<TimeTravelSimulatorScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _timelineController;
  late Animation<double> _timelineAnimation;
  int _selectedYear = 0;
  late List<_TimePeriod> _periods;

  @override
  void initState() {
    super.initState();
    _timelineController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _timelineAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _timelineController, curve: Curves.easeInOut),
    );

    _periods = [
      _TimePeriod(
        year: 'MÖ 2560',
        name: 'Antik Mısır',
        description: 'Piramit Çağı',
        icon: Icons.account_balance,
        color: Colors.amber,
      ),
      _TimePeriod(
        year: 'MÖ 476',
        name: 'Antik Roma',
        description: 'İmparator Dönemi',
        icon: Icons.location_city,
        color: Colors.orange,
      ),
      _TimePeriod(
        year: '330',
        name: 'Bizans',
        description: 'Konstantinopol Kuruluşu',
        icon: Icons.temple_buddhist,
        color: AppTheme.neonCyan,
      ),
      _TimePeriod(
        year: '1453',
        name: 'Osmanlı',
        description: 'İstanbul Fethine',
        icon: Icons.castle,
        color: AppTheme.neonPink,
      ),
    ];

    _timelineController.forward();
  }

  @override
  void dispose() {
    _timelineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zaman Yolculuğu Simülatörü'),
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
                  // Current Period Display
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          _periods[_selectedYear].color.withOpacity(0.2),
                          _periods[_selectedYear].color.withOpacity(0.05),
                        ],
                      ),
                      border: Border.all(
                        color: _periods[_selectedYear].color.withOpacity(0.3),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: _periods[_selectedYear].color
                                    .withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _periods[_selectedYear].icon,
                                color: _periods[_selectedYear].color,
                                size: 32,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _periods[_selectedYear].year,
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: _periods[_selectedYear].color,
                                    ),
                                  ),
                                  Text(
                                    _periods[_selectedYear].name,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white.withOpacity(0.05),
                          ),
                          child: Text(
                            _periods[_selectedYear].description,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.7),
                              height: 1.6,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Timeline
                  const Text(
                    'Zaman Çizgisi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  _buildTimeline(),

                  const SizedBox(height: 24),

                  // Time Period Details
                  const Text(
                    'Detaylı Bilgi',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _periods[_selectedYear].color.withOpacity(0.2),
                      ),
                      color: Colors.white.withOpacity(0.03),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dönem Özellikleri',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _DetailRow(
                          icon: Icons.people,
                          label: 'Nüfus',
                          value: '~5 Milyon',
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          icon: Icons.location_on,
                          label: 'Başkent',
                          value: _getCapitalForPeriod(),
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          icon: Icons.language,
                          label: 'Dil',
                          value: _getLanguageForPeriod(),
                        ),
                        const SizedBox(height: 10),
                        _DetailRow(
                          icon: Icons.architecture,
                          label: 'Stil',
                          value: _getStyleForPeriod(),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Travel Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showTravelDialog();
                      },
                      icon: const Icon(Icons.travel_explore),
                      label: const Text('Bu Döneme Seyahat Et'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _periods[_selectedYear].color
                            .withOpacity(0.2),
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

  Widget _buildTimeline() {
    return Column(
      children: _periods.asMap().entries.map((entry) {
        int index = entry.key;
        _TimePeriod period = entry.value;
        bool isSelected = _selectedYear == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedYear = index;
            });
            _timelineController.forward(from: 0);
          },
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected
                      ? period.color.withOpacity(0.5)
                      : period.color.withOpacity(0.2),
                ),
                color: isSelected
                    ? period.color.withOpacity(0.1)
                    : Colors.white.withOpacity(0.03),
              ),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          period.color.withOpacity(0.3),
                          period.color.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(color: period.color.withOpacity(0.5)),
                    ),
                    child: Icon(period.icon, color: period.color, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          period.year,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: isSelected ? period.color : Colors.white,
                          ),
                        ),
                        Text(
                          period.name,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: period.color.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.check, size: 18, color: period.color),
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  String _getCapitalForPeriod() {
    switch (_selectedYear) {
      case 0:
        return 'Memphis';
      case 1:
        return 'Roma';
      case 2:
        return 'Konstantinopol';
      case 3:
        return 'İstanbul';
      default:
        return 'Bilinmiyor';
    }
  }

  String _getLanguageForPeriod() {
    switch (_selectedYear) {
      case 0:
        return 'Mısır Hieroglifleri';
      case 1:
        return 'Latince';
      case 2:
        return 'Yunanca';
      case 3:
        return 'Osmanlı Türkçesi';
      default:
        return 'Bilinmiyor';
    }
  }

  String _getStyleForPeriod() {
    switch (_selectedYear) {
      case 0:
        return 'Piramit Mimarisi';
      case 1:
        return 'Roma Mimarisi';
      case 2:
        return 'Bizans Sanatı';
      case 3:
        return 'Osmanlı Sanatı';
      default:
        return 'Bilinmiyor';
    }
  }

  void _showTravelDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Row(
          children: [
            Icon(Icons.travel_explore, color: AppTheme.neonCyan),
            SizedBox(width: 8),
            Text('Zaman Yolculuğu'),
          ],
        ),
        content: Text(
          '${_periods[_selectedYear].year} yılına seyahat etmek istediğinize emin misiniz?',
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
                  content: Text(
                    '${_periods[_selectedYear].year} yılına gidiliyor...',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonCyan),
            child: const Text('Yolculuğa Başla'),
          ),
        ],
      ),
    );
  }
}

class _TimePeriod {
  final String year;
  final String name;
  final String description;
  final IconData icon;
  final Color color;

  _TimePeriod({
    required this.year,
    required this.name,
    required this.description,
    required this.icon,
    required this.color,
  });
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppTheme.neonCyan),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: AppTheme.neonCyan.withOpacity(0.15),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: AppTheme.neonCyan,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
