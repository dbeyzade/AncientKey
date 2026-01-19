import 'package:flutter/material.dart';

class GuidedToursScreen extends StatelessWidget {
  const GuidedToursScreen({super.key});

  final List<GuidedTour> tours = const [
    GuidedTour(
      title: 'Efes Antik Kenti Turu',
      guide: 'Arkeolog Dr. Zeynep Kaya',
      duration: '2 saat',
      language: 'Türkçe',
      description: 'Efes\'in tarihi sokaklarında yürüyerek Roma döneminin izlerini keşfedin.',
      highlights: ['Celsus Kütüphanesi', 'Büyük Tiyatro', 'Artemis Tapınağı', 'Terrace Houses'],
      color: Color(0xFF1976D2),
      icon: Icons.account_balance,
    ),
    GuidedTour(
      title: 'Mısır Piramitleri Keşfi',
      guide: 'Mısırbilimci Prof. Ahmed Hassan',
      duration: '3 saat',
      language: 'Türkçe/İngilizce',
      description: 'Büyük Piramitlerin sırlarını uzman rehberle çözümleyin.',
      highlights: ['Keops Piramidi', 'Sfenks', 'Mumyalama Odaları', 'Hieroglif Okuma'],
      color: Color(0xFFD84315),
      icon: Icons.terrain,
    ),
    GuidedTour(
      title: 'Roma İmparatorluğu Yürüyüşü',
      guide: 'Tarihçi Dr. Marco Rossi',
      duration: '2.5 saat',
      language: 'Türkçe/İtalyanca',
      description: 'Colosseum\'dan Forum Romanum\'a Roma\'nın görkemli dönemini yaşayın.',
      highlights: ['Colosseum', 'Forum Romanum', 'Pantheon', 'Via Appia'],
      color: Color(0xFF7B1FA2),
      icon: Icons.castle,
    ),
    GuidedTour(
      title: 'Yunan Akropolü Turu',
      guide: 'Arkeolog Dr. Maria Papadopoulos',
      duration: '2 saat',
      language: 'Türkçe/Yunanca',
      description: 'Atina Akropolü\'nde antik Yunan medeniyetinin zirvesine çıkın.',
      highlights: ['Parthenon', 'Erechtheion', 'Propylaea', 'Dionysos Tiyatrosu'],
      color: Color(0xFF0288D1),
      icon: Icons.temple_hindu,
    ),
    GuidedTour(
      title: 'Truva Efsanesi Turu',
      guide: 'Mitoloji Uzmanı Dr. Can Yılmaz',
      duration: '1.5 saat',
      language: 'Türkçe',
      description: 'Truva Savaşı\'nın gerçek hikayesini antik kalıntılar arasında keşfedin.',
      highlights: ['Truva Atı', 'Antik Surlar', 'Priam Hazinesi', 'Kazı Alanları'],
      color: Color(0xFFF57C00),
      icon: Icons.fort,
    ),
    GuidedTour(
      title: 'Göbeklitepe Kutsal Turu',
      guide: 'Arkeolog Dr. Mehmet Özdoğan',
      duration: '2 saat',
      language: 'Türkçe',
      description: 'Dünyanın en eski tapınağında tarih öncesi insanlığın izini sürün.',
      highlights: ['T Şeklinde Dikilitaşlar', 'Hayvan Kabartmaları', 'Dini Ritüeller', '12.000 Yıllık Tapınak'],
      color: Color(0xFF5D4037),
      icon: Icons.church,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rehberli Turlar'),
        backgroundColor: Colors.green[700],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: tours.length,
        itemBuilder: (context, index) {
          return _buildTourCard(context, tours[index]);
        },
      ),
    );
  }

  Widget _buildTourCard(BuildContext context, GuidedTour tour) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showTourDetails(context, tour),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                tour.color.withOpacity(0.8),
                tour.color.withOpacity(0.5),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(tour.icon, color: Colors.white, size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tour.guide,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white.withOpacity(0.9),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildInfoChip(Icons.schedule, tour.duration),
                    const SizedBox(width: 8),
                    _buildInfoChip(Icons.language, tour.language),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  tour.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.95),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: tour.highlights.take(3).map((highlight) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        highlight,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.25),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showTourDetails(BuildContext context, GuidedTour tour) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: tour.color.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(tour.icon, color: tour.color, size: 40),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tour.title,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tour.guide,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildDetailChip(
                      Icons.schedule,
                      'Süre',
                      tour.duration,
                      tour.color,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDetailChip(
                      Icons.language,
                      'Dil',
                      tour.language,
                      tour.color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              const Text(
                'Tur Hakkında',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                tour.description,
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[700],
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Tur Programı Öne Çıkanlar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...tour.highlights.map((highlight) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Icon(
                          Icons.check_circle,
                          color: tour.color,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            highlight,
                            style: const TextStyle(fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  )),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${tour.title} tura katıldınız! 🎉'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      },
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Tura Başla'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tour.color,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.favorite_border),
                    iconSize: 28,
                    color: tour.color,
                    style: IconButton.styleFrom(
                      backgroundColor: tour.color.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailChip(IconData icon, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class GuidedTour {
  final String title;
  final String guide;
  final String duration;
  final String language;
  final String description;
  final List<String> highlights;
  final Color color;
  final IconData icon;

  const GuidedTour({
    required this.title,
    required this.guide,
    required this.duration,
    required this.language,
    required this.description,
    required this.highlights,
    required this.color,
    required this.icon,
  });
}
