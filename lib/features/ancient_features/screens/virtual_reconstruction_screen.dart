import 'package:flutter/material.dart';

class VirtualReconstructionScreen extends StatelessWidget {
  const VirtualReconstructionScreen({super.key});

  final List<Reconstruction> reconstructions = const [
    Reconstruction(
      title: 'Parthenon - Atina',
      era: 'MÖ 447',
      description: 'Atina Akropolisi\'ndeki Parthenon tapınağının orijinal görkemli hali.',
      beforeImage: '🏛️',
      afterImage: '✨',
      color: Colors.blue,
    ),
    Reconstruction(
      title: 'Colosseum - Roma',
      era: 'MS 80',
      description: 'Roma\'nın en büyük amfitiyatrosunun tüm detaylarıyla yeniden inşası.',
      beforeImage: '🏟️',
      afterImage: '✨',
      color: Colors.red,
    ),
    Reconstruction(
      title: 'Büyük Piramit - Giza',
      era: 'MÖ 2560',
      description: 'Keops Piramidi\'nin beyaz kireçtaşı kaplamasıyla orijinal görünümü.',
      beforeImage: '🔺',
      afterImage: '✨',
      color: Colors.orange,
    ),
    Reconstruction(
      title: 'Asma Bahçeler - Babil',
      era: 'MÖ 600',
      description: 'Dünyanın Yedi Harikası\'ndan biri olan Asma Bahçeler\'in 3D rekonstrüksiyonu.',
      beforeImage: '🌿',
      afterImage: '✨',
      color: Colors.green,
    ),
    Reconstruction(
      title: 'İskenderiye Feneri',
      era: 'MÖ 280',
      description: 'Antik dünyanın en yüksek yapılarından biri olan fener kulesi.',
      beforeImage: '🗼',
      afterImage: '✨',
      color: Colors.amber,
    ),
    Reconstruction(
      title: 'Efes Antik Kenti',
      era: 'MÖ 129',
      description: 'Anadolu\'nun en önemli antik kenti Efes\'in Roma dönemi rekonstrüksiyonu.',
      beforeImage: '🏛️',
      afterImage: '✨',
      color: Colors.purple,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sanal Rekonstrüksiyon'),
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: reconstructions.length,
        itemBuilder: (context, index) {
          return _buildReconstructionCard(context, reconstructions[index]);
        },
      ),
    );
  }

  Widget _buildReconstructionCard(BuildContext context, Reconstruction reconstruction) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showReconstructionDetails(context, reconstruction),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [
                reconstruction.color.withOpacity(0.7),
                reconstruction.color.withOpacity(0.4),
              ],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          reconstruction.beforeImage,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.arrow_forward, color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(
                          reconstruction.afterImage,
                          style: const TextStyle(fontSize: 40),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            reconstruction.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: reconstruction.color.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            reconstruction.era,
                            style: TextStyle(
                              color: reconstruction.color,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      reconstruction.description,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showReconstructionDetails(BuildContext context, Reconstruction reconstruction) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          constraints: const BoxConstraints(maxHeight: 500),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [reconstruction.color, reconstruction.color.withOpacity(0.7)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.architecture, size: 60, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      reconstruction.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reconstruction.era,
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        reconstruction.description,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('3D model yükleniyor... 🏛️'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.view_in_ar),
                        label: const Text('3D Görünüm'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: reconstruction.color,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Reconstruction {
  final String title;
  final String era;
  final String description;
  final String beforeImage;
  final String afterImage;
  final Color color;

  const Reconstruction({
    required this.title,
    required this.era,
    required this.description,
    required this.beforeImage,
    required this.afterImage,
    required this.color,
  });
}
