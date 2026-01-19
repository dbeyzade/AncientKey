import 'package:flutter/material.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class VirtualLaboratoryScreen extends StatefulWidget {
  const VirtualLaboratoryScreen({super.key});

  @override
  State<VirtualLaboratoryScreen> createState() =>
      _VirtualLaboratoryScreenState();
}

class _VirtualLaboratoryScreenState extends State<VirtualLaboratoryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _experimentController;
  late Animation<double> _bubbleAnimation;
  String _selectedExperiment = 'pottery';
  bool _isRunning = false;

  @override
  void initState() {
    super.initState();
    _experimentController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _bubbleAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _experimentController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _experimentController.dispose();
    super.dispose();
  }

  void _startExperiment() {
    setState(() {
      _isRunning = true;
    });
    _experimentController.repeat(reverse: true);
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isRunning = false;
        });
        _experimentController.stop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Deney tamamlandı!'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanal Laboratuvar'),
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
                  // Lab Info
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.2),
                          Colors.teal.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.science,
                            color: Colors.green,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sanal Arkeoloji Laboratuvarı',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Eski yöntemleri keşfet ve deneyle',
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

                  const SizedBox(height: 24),

                  // Experiment Display
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.green.withOpacity(0.3)),
                      gradient: LinearGradient(
                        colors: [
                          Colors.green.withOpacity(0.1),
                          Colors.teal.withOpacity(0.05),
                        ],
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (_isRunning)
                          AnimatedBuilder(
                            animation: _bubbleAnimation,
                            builder: (context, child) {
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  for (int i = 0; i < 3; i++)
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: 20 * _bubbleAnimation.value,
                                      ),
                                      child: Transform.scale(
                                        scale:
                                            0.5 +
                                            (0.5 * _bubbleAnimation.value),
                                        child: Container(
                                          width: 20,
                                          height: 20,
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.green.withOpacity(
                                              0.5 *
                                                  (1 - _bubbleAnimation.value),
                                            ),
                                            border: Border.all(
                                              color: Colors.green,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
                        if (!_isRunning)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                _getExperimentIcon(),
                                size: 80,
                                color: Colors.green.withOpacity(0.6),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                _getExperimentName(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _getExperimentDescription(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Experiment Selection
                  const Text(
                    'Deney Seçin',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildExperimentCards(),

                  const SizedBox(height: 24),

                  // Requirements
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: Colors.blue.withOpacity(0.1),
                      border: Border.all(color: Colors.blue.withOpacity(0.3)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.info, color: Colors.blue, size: 20),
                            const SizedBox(width: 8),
                            const Text(
                              'Deney Gereksinimi',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          _getRequirements(),
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

                  // Start Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _isRunning ? null : _startExperiment,
                      icon: Icon(
                        _isRunning ? Icons.hourglass_bottom : Icons.play_arrow,
                      ),
                      label: Text(
                        _isRunning ? 'Deney Çalışıyor...' : 'Deneyi Başlat',
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.withOpacity(0.2),
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

  List<Widget> _buildExperimentCards() {
    final experiments = [
      ('pottery', 'Çömlekçilik', Icons.handyman),
      ('metalwork', 'Demircilik', Icons.hardware),
      ('glassmaking', 'Cam Üretimi', Icons.diamond),
      ('textile', 'Tekstil Dokuması', Icons.texture),
    ];

    return [
      GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        children: experiments
            .map(
              (exp) => GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedExperiment = exp.$1;
                  });
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: _selectedExperiment == exp.$1
                          ? Colors.green.withOpacity(0.5)
                          : Colors.green.withOpacity(0.2),
                    ),
                    color: _selectedExperiment == exp.$1
                        ? Colors.green.withOpacity(0.1)
                        : Colors.white.withOpacity(0.03),
                    gradient: _selectedExperiment == exp.$1
                        ? LinearGradient(
                            colors: [
                              Colors.green.withOpacity(0.15),
                              Colors.teal.withOpacity(0.1),
                            ],
                          )
                        : null,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        exp.$3,
                        size: 40,
                        color: _selectedExperiment == exp.$1
                            ? Colors.green
                            : Colors.green.withOpacity(0.6),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        exp.$2,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: _selectedExperiment == exp.$1
                              ? Colors.green
                              : Colors.white,
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

  IconData _getExperimentIcon() {
    switch (_selectedExperiment) {
      case 'pottery':
        return Icons.handyman;
      case 'metalwork':
        return Icons.hardware;
      case 'glassmaking':
        return Icons.diamond;
      case 'textile':
        return Icons.texture;
      default:
        return Icons.science;
    }
  }

  String _getExperimentName() {
    switch (_selectedExperiment) {
      case 'pottery':
        return 'Çömlekçilik';
      case 'metalwork':
        return 'Demircilik';
      case 'glassmaking':
        return 'Cam Üretimi';
      case 'textile':
        return 'Tekstil Dokuması';
      default:
        return 'Deney';
    }
  }

  String _getExperimentDescription() {
    switch (_selectedExperiment) {
      case 'pottery':
        return 'Antik çömleklerin nasıl yapıldığını öğrenin';
      case 'metalwork':
        return 'Metal işleme tekniklerini keşfedin';
      case 'glassmaking':
        return 'Cam üretim yöntemlerini deneyin';
      case 'textile':
        return 'Dokuma sanatını practice edin';
      default:
        return '';
    }
  }

  String _getRequirements() {
    switch (_selectedExperiment) {
      case 'pottery':
        return '• Çömlek çarkı simülasyonu\n• Kil materi yönetimi\n• Ateşleme süreci';
      case 'metalwork':
        return '• Dövme tekniği\n• Alaşım seçimi\n• Soğutma süreci';
      case 'glassmaking':
        return '• Isıl işlem\n• Renk ekleme\n• Şekil verme';
      case 'textile':
        return '• Dokuma deseni\n• İplik seçimi\n• Renk kombinasyonu';
      default:
        return '';
    }
  }
}
