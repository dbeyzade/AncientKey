import 'package:flutter/material.dart';
import 'package:ancientkey/core/theme/app_theme.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class VRHistoricalExperiencesScreen extends StatefulWidget {
  const VRHistoricalExperiencesScreen({super.key});

  @override
  State<VRHistoricalExperiencesScreen> createState() =>
      _VRHistoricalExperiencesScreenState();
}

class _VRHistoricalExperiencesScreenState
    extends State<VRHistoricalExperiencesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('VR Tarihi Deneyimler'),
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
                  // VR Headset Info
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          colors: [
                            AppTheme.neonPink.withOpacity(0.2),
                            Colors.purple.withOpacity(0.1),
                          ],
                        ),
                        border: Border.all(
                          color: AppTheme.neonPink.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: AppTheme.neonPink.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.videogame_asset,
                              color: AppTheme.neonPink,
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Sanal Gerçeklik Deneyimi',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Tarihe adım atın, zamanı hissedin',
                                  style: TextStyle(
                                    fontSize: 13,
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
                  const SizedBox(height: 24),

                  // Available VR Experiences
                  const Text(
                    'Mevcut Deneyimler',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildVRExperiences(),

                  const SizedBox(height: 24),
                  // Hardware Requirements
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.orange.withOpacity(0.1),
                      border: Border.all(color: Colors.orange.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.orange, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Sistem Gereksinimleri',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '• Android 8.0 ve üzeri\n• 4GB RAM (en az)\n• VR Headset (Cardboard, Gear VR vb.)\n• Wifi/4G bağlantısı',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.7),
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  // Start VR Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showVRStartDialog();
                      },
                      icon: const Icon(Icons.start),
                      label: const Text('VR Deneyimine Başla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonPink.withOpacity(0.2),
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

  List<Widget> _buildVRExperiences() {
    final experiences = [
      (
        'Antik Roma',
        'Forum, Koloseum, Aqueducts',
        Icons.location_city,
        '45 dakika',
      ),
      (
        'Eski Mısır',
        'Piramitler, Tapınaklar',
        Icons.location_city,
        '50 dakika',
      ),
      ('Ortaçağ Şehri', 'Kaleler, Pazarlar', Icons.castle, '40 dakika'),
      (
        'Antik Yunanistan',
        'Akropolis, Delphi',
        Icons.temple_buddhist,
        '48 dakika',
      ),
    ];

    return experiences
        .map(
          (exp) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${exp.$1} VR deneyimi başlatılıyor...'),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.neonPink.withOpacity(0.2)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppTheme.neonPink.withOpacity(0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(exp.$3, color: AppTheme.neonPink, size: 20),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            exp.$1,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            exp.$2,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            exp.$4,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.neonPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  void _showVRStartDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Row(
          children: [
            Icon(Icons.videogame_asset, color: AppTheme.neonPink),
            SizedBox(width: 8),
            Text('VR Başlat'),
          ],
        ),
        content: const Text(
          'VR başlatmak için cihazınızda uygun bir VR headset\nbağlı olduğundan emin olun.',
          style: TextStyle(fontSize: 14),
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
                const SnackBar(
                  content: Text('VR deneyimi hazırlanıyor...'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonPink),
            child: const Text('Devam Et'),
          ),
        ],
      ),
    );
  }
}
