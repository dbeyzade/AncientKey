import 'package:flutter/material.dart';
import 'package:ancientkey/core/theme/app_theme.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class HologramProjectionScreen extends StatefulWidget {
  const HologramProjectionScreen({super.key});

  @override
  State<HologramProjectionScreen> createState() =>
      _HologramProjectionScreenState();
}

class _HologramProjectionScreenState extends State<HologramProjectionScreen>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _rotateController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();

    _rotateController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat();

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _rotateAnimation = Tween<double>(
      begin: 0,
      end: 6.28,
    ).animate(CurvedAnimation(parent: _rotateController, curve: Curves.linear));
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _rotateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hologram Projeksiyon'),
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
                  // Hologram Preview
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppTheme.neonCyan.withOpacity(0.3),
                      ),
                      gradient: LinearGradient(
                        colors: [
                          Colors.cyan.withOpacity(0.1),
                          Colors.blue.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Hologram Glow
                        AnimatedBuilder(
                          animation: _pulseAnimation,
                          builder: (context, child) => Container(
                            width: 120 * _pulseAnimation.value,
                            height: 120 * _pulseAnimation.value,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  AppTheme.neonCyan.withOpacity(0.6),
                                  AppTheme.neonCyan.withOpacity(0),
                                ],
                              ),
                            ),
                          ),
                        ),
                        // Rotating Hologram
                        AnimatedBuilder(
                          animation: _rotateAnimation,
                          builder: (context, child) => Transform.rotate(
                            angle: _rotateAnimation.value,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppTheme.neonCyan,
                                      width: 2,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.location_city,
                                    size: 40,
                                    color: AppTheme.neonCyan,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  'Antik Yapı',
                                  style: TextStyle(
                                    color: AppTheme.neonCyan,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Hologram Settings
                  const Text(
                    'Hologram Ayarları',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),

                  // Settings Cards
                  _SettingCard(
                    icon: Icons.brightness_5,
                    title: 'Parlama Seviyesi',
                    value: '75%',
                    onChanged: () {},
                  ),
                  const SizedBox(height: 10),
                  _SettingCard(
                    icon: Icons.rotate_right,
                    title: 'Dönüş Hızı',
                    value: 'Orta',
                    onChanged: () {},
                  ),
                  const SizedBox(height: 10),
                  _SettingCard(
                    icon: Icons.aspect_ratio,
                    title: 'Boyut',
                    value: 'XL',
                    onChanged: () {},
                  ),

                  const SizedBox(height: 24),

                  // Available Holograms
                  const Text(
                    'Mevcut Hologramlar',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildHologramGrid(),

                  const SizedBox(height: 24),

                  // Project Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Hologram cihaza gönderiliyor...'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Hologramı Projeektle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonCyan.withOpacity(0.2),
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

  List<Widget> _buildHologramGrid() {
    final holograms = [
      ('Piramitler', Icons.location_city),
      ('Kaleler', Icons.castle),
      ('Tapınaklar', Icons.temple_buddhist),
      ('Camiler', Icons.mosque),
    ];

    return [
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: holograms
            .map(
              (h) => GestureDetector(
                onTap: () {},
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: AppTheme.neonCyan.withOpacity(0.2),
                    ),
                    color: Colors.white.withOpacity(0.03),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(h.$2, size: 40, color: AppTheme.neonCyan),
                      const SizedBox(height: 8),
                      Text(
                        h.$1,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    ];
  }
}

class _SettingCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onChanged;

  const _SettingCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.neonCyan.withOpacity(0.2)),
        color: Colors.white.withOpacity(0.03),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.neonCyan.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppTheme.neonCyan, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
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
      ),
    );
  }
}
