import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class SocialToursScreen extends StatefulWidget {
  const SocialToursScreen({super.key});

  @override
  State<SocialToursScreen> createState() => _SocialToursScreenState();
}

class _SocialToursScreenState extends State<SocialToursScreen> {
  final List<SocialTour> activeTours = [
    SocialTour(
      id: '1',
      title: 'Efes Antik Kenti Turu',
      host: 'Ahmet Yıldız',
      participants: 8,
      maxParticipants: 12,
      startTime: DateTime.now().add(Duration(hours: 2)),
      duration: 45,
      difficulty: 'Kolay',
      language: 'Türkçe',
      description: 'Efes antik kentinin tarihi ve kütürel önemini keşfedelim!',
      imageIcon: Icons.account_balance,
      category: 'Antik Kent',
    ),
    SocialTour(
      id: '2',
      title: 'Mısır Piramitleri Sanal Gezisi',
      host: 'Zeynep Kaya',
      participants: 15,
      maxParticipants: 20,
      startTime: DateTime.now().add(Duration(minutes: 30)),
      duration: 60,
      difficulty: 'Orta',
      language: 'Türkçe/İngilizce',
      description: 'Giza piramitlerini 3D olarak birlikte keşfedelim. Firavunların sırlarına inmek için katıl!',
      imageIcon: Icons.terrain,
      category: 'Antik Mısır',
    ),
    SocialTour(
      id: '3',
      title: 'Roma Kolizeumu Sanal Tur',
      host: 'Giovanni Rossi',
      participants: 5,
      maxParticipants: 15,
      startTime: DateTime.now().add(Duration(hours: 4)),
      duration: 50,
      difficulty: 'Orta',
      language: 'İngilizce',
      description: 'Gladyatörlerin arenasını canlı tur ile keşfedin!',
      imageIcon: Icons.stadium,
      category: 'Roma',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A148C),
              Color(0xFF6A1B9A),
              Color(0xFF8E24AA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildQuickStats(),
              Expanded(
                child: ListView.builder(
                  padding: EdgeInsets.all(16),
                  itemCount: activeTours.length,
                  itemBuilder: (context, index) {
                    return _buildTourCard(activeTours[index]);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _createNewTour,
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: AppTheme.darkBlue,
        icon: Icon(Icons.add),
        label: Text('Tur Oluştur', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sosyal Turlar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Arkadaşlarınla birlikte keşfet!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.people, color: AppTheme.primaryGold, size: 28),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(Icons.tour, '${activeTours.length}', 'Aktif Tur'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem(Icons.people_alt, '28', 'Katılımcı'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem(Icons.schedule, _upcomingToursCount().toString(), 'Yaklaşan'),
        ],
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppTheme.primaryGold, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.white60, fontSize: 11),
        ),
      ],
    );
  }

  Widget _buildTourCard(SocialTour tour) {
    final timeUntilStart = tour.startTime.difference(DateTime.now());
    final hoursUntil = timeUntilStart.inHours;
    final minutesUntil = timeUntilStart.inMinutes % 60;
    
    String timeString;
    Color timeColor;
    if (hoursUntil == 0 && minutesUntil < 30) {
      timeString = '$minutesUntil dk sonra başlıyor!';
      timeColor = Colors.red;
    } else if (hoursUntil == 0) {
      timeString = '$minutesUntil dakika sonra';
      timeColor = Colors.orange;
    } else if (hoursUntil < 2) {
      timeString = '$hoursUntil saat $minutesUntil dakika sonra';
      timeColor = Colors.orange;
    } else {
      timeString = '$hoursUntil saat sonra';
      timeColor = Colors.green;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () => _showTourDetails(tour),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGold.withOpacity(0.3),
                            AppTheme.primaryGold.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(tour.imageIcon, color: AppTheme.primaryGold, size: 32),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tour.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.white70, size: 14),
                              SizedBox(width: 4),
                              Text(
                                tour.host,
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    _buildCategoryBadge(tour.category),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  tour.description,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildInfoChip(Icons.schedule, '${tour.duration} dk', Colors.blue),
                    _buildInfoChip(Icons.signal_cellular_alt, tour.difficulty, _getDifficultyColor(tour.difficulty)),
                    _buildInfoChip(Icons.language, tour.language, Colors.green),
                  ],
                ),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.timer, color: timeColor, size: 16),
                              SizedBox(width: 4),
                              Text(
                                timeString,
                                style: TextStyle(
                                  color: timeColor,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            children: [
                              ...List.generate(
                                tour.participants.clamp(0, 5),
                                (index) => Container(
                                  margin: EdgeInsets.only(right: 4),
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGold.withOpacity(0.3),
                                    shape: BoxShape.circle,
                                    border: Border.all(color: AppTheme.primaryGold, width: 1),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '👤',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                              ),
                              if (tour.participants > 5)
                                Container(
                                  margin: EdgeInsets.only(left: 4),
                                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryGold.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '+${tour.participants - 5}',
                                    style: TextStyle(
                                      color: AppTheme.primaryGold,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              SizedBox(width: 8),
                              Text(
                                '${tour.participants}/${tour.maxParticipants}',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () => _joinTour(tour),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryGold,
                        foregroundColor: AppTheme.darkBlue,
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Katıl',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryBadge(String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.purple.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.purple, width: 1),
      ),
      child: Text(
        category,
        style: TextStyle(
          color: Colors.purple[200],
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String label, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5), width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 14),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Kolay':
        return Colors.green;
      case 'Orta':
        return Colors.orange;
      case 'Zor':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _joinTour(SocialTour tour) {
    if (tour.participants >= tour.maxParticipants) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('⚠️ Tur dolu! Başka bir tura katılmayı dene.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Tura Katıl', style: TextStyle(color: AppTheme.primaryGold)),
        content: Text(
          '${tour.title} turuna katılmak istediğinden emin misin?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                tour.participants++;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('✅ Tura başarıyla katıldın! Tur ${tour.startTime.hour}:${tour.startTime.minute.toString().padLeft(2, '0')} de başlayacak.'),
                  backgroundColor: Colors.green,
                  duration: Duration(seconds: 3),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.darkBlue,
            ),
            child: Text('Katıl'),
          ),
        ],
      ),
    );
  }

  void _showTourDetails(SocialTour tour) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(tour.imageIcon, color: AppTheme.primaryGold),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                tour.title,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(tour.description, style: TextStyle(color: Colors.white70)),
              SizedBox(height: 16),
              _buildDetailRow('Rehber', tour.host),
              _buildDetailRow('Kategori', tour.category),
              _buildDetailRow('Süre', '${tour.duration} dakika'),
              _buildDetailRow('Zorluk', tour.difficulty),
              _buildDetailRow('Dil', tour.language),
              _buildDetailRow('Katılımcı', '${tour.participants}/${tour.maxParticipants}'),
              _buildDetailRow('Başlangıç', '${tour.startTime.hour}:${tour.startTime.minute.toString().padLeft(2, '0')}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _joinTour(tour);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.darkBlue,
            ),
            child: Text('Katıl'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white60, fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  void _createNewTour() {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Yeni Tur Oluştur'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Tur Başlığı'),
            ),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(labelText: 'Kısa Açıklama'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              final title = titleController.text.trim();
              if (title.isEmpty) return;
              setState(() {
                activeTours.add(
                  SocialTour(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    title: title,
                    host: 'Sen',
                    participants: 1,
                    maxParticipants: 10,
                    startTime: DateTime.now().add(const Duration(hours: 1)),
                    duration: 30,
                    difficulty: 'Kolay',
                    language: 'Türkçe',
                    description: descriptionController.text.trim().isEmpty
                        ? 'Topluluk turu'
                        : descriptionController.text.trim(),
                    imageIcon: Icons.explore,
                    category: 'Topluluk',
                  ),
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Tur oluşturuldu ✅')),
              );
            },
            child: const Text('Oluştur'),
          ),
        ],
      ),
    );
  }

  int _upcomingToursCount() {
    final now = DateTime.now();
    return activeTours.where((tour) => tour.startTime.isAfter(now)).length;
  }
}

class SocialTour {
  final String id;
  final String title;
  final String host;
  int participants;
  final int maxParticipants;
  final DateTime startTime;
  final int duration;
  final String difficulty;
  final String language;
  final String description;
  final IconData imageIcon;
  final String category;

  SocialTour({
    required this.id,
    required this.title,
    required this.host,
    required this.participants,
    required this.maxParticipants,
    required this.startTime,
    required this.duration,
    required this.difficulty,
    required this.language,
    required this.description,
    required this.imageIcon,
    required this.category,
  });
}
