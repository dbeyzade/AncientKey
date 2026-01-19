import 'package:flutter/material.dart';

class TimeTravelScreen extends StatefulWidget {
  const TimeTravelScreen({super.key});

  @override
  State<TimeTravelScreen> createState() => _TimeTravelScreenState();
}

class _TimeTravelScreenState extends State<TimeTravelScreen> {
  final List<TimeEra> eras = [
    TimeEra(
      title: 'Antik Mısır - Keops Piramidi İnşaatı',
      year: 'MÖ 2580',
      description: 'Büyük Piramit\'in inşasına tanık olun. 20 yıl boyunca 100.000 işçi bu muhteşem yapıyı inşa etti.',
      color: Colors.orange,
      icon: Icons.landscape,
    ),
    TimeEra(
      title: 'Antik Yunan - İlk Olimpiyat Oyunları',
      year: 'MÖ 776',
      description: 'Olympia\'da düzenlenen ilk olimpiyat oyunlarını izleyin. Atletler Zeus onuruna yarışıyor.',
      color: Colors.blue,
      icon: Icons.sports,
    ),
    TimeEra(
      title: 'Truva Savaşı',
      year: 'MÖ 1200',
      description: 'Efsanevi Truva Savaşı\'nın son günlerine gidin. Truva Atı\'nın içine girmeye cesaret eder misiniz?',
      color: Colors.red,
      icon: Icons.shield,
    ),
    TimeEra(
      title: 'Roma - Colosseum Açılışı',
      year: 'MS 80',
      description: 'Flavius Amfitiyatrosu\'nun (Colosseum) görkemli açılışında yerinizi alın. 100 gün süren şölenler başlıyor.',
      color: Colors.deepOrange,
      icon: Icons.stadium,
    ),
    TimeEra(
      title: 'Büyük İskender - Gaugamela Savaşı',
      year: 'MÖ 331',
      description: 'İskender\'in Pers İmparatorluğu\'nu yıktığı tarihi savaşta ordusunun yanında olun.',
      color: Colors.purple,
      icon: Icons.castle,
    ),
    TimeEra(
      title: 'Kleopatra\'nın Sarayı',
      year: 'MÖ 48',
      description: 'İskenderiye\'deki Kleopatra\'nın sarayında bir gün geçirin. Julius Caesar ile tarihi buluşmaya şahit olun.',
      color: Colors.amber,
      icon: Icons.account_balance,
    ),
    TimeEra(
      title: 'Çin Seddi İnşaatı',
      year: 'MÖ 220',
      description: 'Dünyanın en uzun yapısının inşasında çalışan işçilerin hayatını deneyimleyin.',
      color: Colors.red[900]!,
      icon: Icons.terrain,
    ),
    TimeEra(
      title: 'Atina - Felsefe Akademisi',
      year: 'MÖ 387',
      description: 'Platon\'un Akademisi\'nde Sokrates, Aristoteles ile tartışmalara katılın.',
      color: Colors.indigo,
      icon: Icons.school,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text('Zamanda Yolculuk'),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.cyan[700]!, Colors.cyan[400]!],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.history, size: 80, color: Colors.white54),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return _buildEraCard(eras[index]);
                },
                childCount: eras.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEraCard(TimeEra era) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showEraDetails(era),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [era.color.withOpacity(0.8), era.color.withOpacity(0.5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(era.icon, size: 32, color: era.color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        era.year,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      era.title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      era.description,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white70,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showEraDetails(TimeEra era) {
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
                    colors: [era.color, era.color.withOpacity(0.7)],
                  ),
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  children: [
                    Icon(era.icon, size: 60, color: Colors.white),
                    const SizedBox(height: 12),
                    Text(
                      era.year,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      era.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        era.description,
                        style: const TextStyle(fontSize: 16, height: 1.6),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Zaman makinesi hazırlanıyor... 🚀'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.rocket_launch),
                        label: const Text('Yolculuğa Başla'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: era.color,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
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

class TimeEra {
  final String title;
  final String year;
  final String description;
  final Color color;
  final IconData icon;

  TimeEra({
    required this.title,
    required this.year,
    required this.description,
    required this.color,
    required this.icon,
  });
}
