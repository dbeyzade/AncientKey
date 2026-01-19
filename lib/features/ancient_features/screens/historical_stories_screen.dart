import 'package:flutter/material.dart';

class HistoricalStoriesScreen extends StatelessWidget {
  HistoricalStoriesScreen({super.key});

  final List<Story> stories = [
    const Story(
      title: 'Kleopatra ve Julius Caesar',
      category: 'Aşk ve İhanet',
      duration: '8 dakika',
      description: 'Roma\'nın en güçlü adamı ve Mısır\'ın son kraliçesi arasındaki tutkulu ilişki.',
      content: 'MÖ 48 yılında Kleopatra, halıya sarılarak Julius Caesar\'ın huzuruna çıktı. Bu cesur hareket, tarihin en ünlü aşk hikayelerinden birinin başlangıcıydı...',
      color: Color(0xFF5D4037),
    ),
    const Story(
      title: 'Truva Atı\'nın Gerçek Hikayesi',
      category: 'Efsaneler',
      duration: '10 dakika',
      description: '10 yıllık kuşatmanın ardından Yunanların kullandığı hile.',
      content: 'Truva surları 10 yıldır aşılamazdı. Odysseus\'un zekası devreye girdi ve dev bir tahta at yapıldı...',
      color: Color(0xFF6D4C41),
    ),
    const Story(
      title: 'Büyük İskender\'in Son Günleri',
      category: 'Trajedi',
      duration: '12 dakika',
      description: 'Dünyanın yarısını fetheden genç kralın gizemli ölümü.',
      content: 'MÖ 323, Babil. 32 yaşındaki İskender, ateşler içinde yatıyordu. İmparatorluğun kaderi belirsizdi...',
      color: Color(0xFF795548),
    ),
    const Story(
      title: 'Spartacus İsyanı',
      category: 'Özgürlük Mücadelesi',
      duration: '15 dakika',
      description: 'Bir gladyatörün Roma\'ya karşı başlattığı büyük köle isyanı.',
      content: 'MÖ 73, Capua. Gladyatör okulundan kaçan 70 köle, tarihte iz bırakacak bir ayaklanma başlattı...',
      color: Color(0xFF4E342E),
    ),
    const Story(
      title: 'Arşimet\'in Son İcadı',
      category: 'Bilim ve Deha',
      duration: '7 dakika',
      description: 'Büyük matematikçinin Syrakusa kuşatması sırasındaki icatları.',
      content: 'MÖ 212, Syrakusa kuşatma altındaydı. Arşimet, Roma gemilerini yakmak için güneş ışınlarını kullandı...',
      color: Color(0xFF8D6E63),
    ),
    const Story(
      title: 'Pompeii\'nin Son Günü',
      category: 'Felaket',
      duration: '20 dakika',
      description: 'Vezüv Yanardağı\'nın patlaması ve bir şehrin sonu.',
      content: 'MS 79, 24 Ağustos. Pompeii halkı normal bir güne uyanırken, Vezüv\'dan dumanlar yükseliyordu...',
      color: Color(0xFF3E2723),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarihi Anlatılar'),
        elevation: 2,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: stories.length,
        itemBuilder: (context, index) {
          return _buildStoryCard(context, stories[index]);
        },
      ),
    );
  }

  Widget _buildStoryCard(BuildContext context, Story story) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showStoryReader(context, story),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [story.color.withOpacity(0.8), story.color.withOpacity(0.6)],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      story.category,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Icon(Icons.auto_stories, color: Colors.white, size: 28),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                story.title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                story.description,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Colors.white70),
                  const SizedBox(width: 4),
                  Text(
                    story.duration,
                    style: const TextStyle(fontSize: 13, color: Colors.white70),
                  ),
                  const Spacer(),
                  const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showStoryReader(BuildContext context, Story story) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: story.color,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white24,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            story.category,
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time, size: 16, color: Colors.white70),
                        const SizedBox(width: 4),
                        Text(
                          story.duration,
                          style: const TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      story.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(24),
                  children: [
                    Text(
                      story.content,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.8,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 40),
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.headphones),
                      label: const Text('Sesli Dinle'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: story.color,
                        minimumSize: const Size(double.infinity, 50),
                      ),
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
}

class Story {
  final String title;
  final String category;
  final String duration;
  final String description;
  final String content;
  final Color color;

  const Story({
    required this.title,
    required this.category,
    required this.duration,
    required this.description,
    required this.content,
    required this.color,
  });
}
