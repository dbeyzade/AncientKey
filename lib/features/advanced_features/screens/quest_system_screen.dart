import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class QuestSystemScreen extends StatefulWidget {
  const QuestSystemScreen({super.key});

  @override
  State<QuestSystemScreen> createState() => _QuestSystemScreenState();
}

class _QuestSystemScreenState extends State<QuestSystemScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Quest> activeQuests = [
    Quest(
      id: '1',
      title: 'Antik Yunan Kaşifi',
      description: 'Yunan medeniyetine ait 5 eser bul ve tara',
      progress: 3,
      total: 5,
      reward: 500,
      category: 'Keşif',
      difficulty: 'Kolay',
      iconData: Icons.temple_buddhist,
    ),
    Quest(
      id: '2',
      title: 'Roma İmparatorluğu Uzmanı',
      description: 'Roma dönemine ait 10 artefakt incele',
      progress: 7,
      total: 10,
      reward: 1000,
      category: 'Araştırma',
      difficulty: 'Orta',
      iconData: Icons.account_balance,
    ),
    Quest(
      id: '3',
      title: 'Mısır Sırları',
      description: 'Piramitler hakkında AI asistan ile 20 soru sor',
      progress: 12,
      total: 20,
      reward: 750,
      category: 'Öğrenme',
      difficulty: 'Kolay',
      iconData: Icons.terrain,
    ),
  ];

  final List<Quest> dailyQuests = [
    Quest(
      id: 'd1',
      title: 'Günlük Keşif',
      description: '3 farklı eseri bugün tara',
      progress: 1,
      total: 3,
      reward: 200,
      category: 'Günlük',
      difficulty: 'Kolay',
      iconData: Icons.today,
      timeLeft: '18s 42d kaldı',
    ),
    Quest(
      id: 'd2',
      title: 'Sosyal Gezgin',
      description: '1 arkadaşınla birlikte sanal tur yap',
      progress: 0,
      total: 1,
      reward: 300,
      category: 'Sosyal',
      difficulty: 'Kolay',
      iconData: Icons.people,
      timeLeft: '18s 42d kaldı',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.darkBlue,
              AppTheme.darkBlue.withOpacity(0.8),
              AppTheme.primaryGold.withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildQuestList(activeQuests, 'Aktif'),
                    _buildQuestList(dailyQuests, 'Günlük'),
                    _buildCompletedTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: AppTheme.gold),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Görevler',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Görevleri tamamla, ödül kazan!',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AppTheme.gold.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.gold, width: 1),
            ),
            child: Row(
              children: [
                Icon(Icons.stars, color: AppTheme.gold, size: 16),
                SizedBox(width: 4),
                Text(
                  '2450 XP',
                  style: TextStyle(
                    color: AppTheme.gold,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.gold,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppTheme.darkBlue,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: 'Aktif (${activeQuests.length})'),
          Tab(text: 'Günlük (${dailyQuests.length})'),
          Tab(text: 'Tamamlanan'),
        ],
      ),
    );
  }

  Widget _buildQuestList(List<Quest> quests, String type) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: quests.length,
      itemBuilder: (context, index) {
        return _buildQuestCard(quests[index]);
      },
    );
  }

  Widget _buildQuestCard(Quest quest) {
    double progress = quest.progress / quest.total;
    
    return Container(
      margin: EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.gold.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showQuestDetails(quest),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppTheme.gold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(quest.iconData, color: AppTheme.gold, size: 24),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            quest.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Row(
                            children: [
                              _buildBadge(quest.category, Colors.blue),
                              SizedBox(width: 8),
                              _buildBadge(quest.difficulty, _getDifficultyColor(quest.difficulty)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryGold.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.stars, color: AppTheme.primaryGold, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '+${quest.reward}',
                            style: TextStyle(
                              color: AppTheme.primaryGold,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12),
                Text(
                  quest.description,
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                SizedBox(height: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${quest.progress}/${quest.total}',
                          style: TextStyle(
                            color: AppTheme.gold,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '${(progress * 100).toInt()}%',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.white.withOpacity(0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(AppTheme.gold),
                        minHeight: 8,
                      ),
                    ),
                  ],
                ),
                if (quest.timeLeft != null) ...[
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.timer, color: Colors.orange, size: 14),
                      SizedBox(width: 4),
                      Text(
                        quest.timeLeft!,
                        style: TextStyle(color: Colors.orange, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.5), width: 0.5),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
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

  Widget _buildCompletedTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle_outline, size: 64, color: Colors.white30),
          SizedBox(height: 16),
          Text(
            'Henüz tamamlanmış görev yok',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Görevleri tamamlayarak buraya ekle!',
            style: TextStyle(color: Colors.white30, fontSize: 12),
          ),
        ],
      ),
    );
  }

  void _showQuestDetails(Quest quest) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(quest.iconData, color: AppTheme.gold),
            SizedBox(width: 12),
            Expanded(
              child: Text(
                quest.title,
                style: TextStyle(color: AppTheme.gold, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                quest.description,
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 16),
              _buildDetailRow('İlerleme', '${quest.progress}/${quest.total}'),
              _buildDetailRow('Kategori', quest.category),
              _buildDetailRow('Zorluk', quest.difficulty),
              _buildDetailRow('Ödül', '+${quest.reward} XP'),
              if (quest.timeLeft != null)
                _buildDetailRow('Kalan Süre', quest.timeLeft!),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Kapat', style: TextStyle(color: Colors.red[400])),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Göreve başlandı! 🎯'),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.gold,
              foregroundColor: AppTheme.darkBlue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text('Başla', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
        actionsPadding: EdgeInsets.all(16),
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
          Text(value, style: TextStyle(color: AppTheme.gold, fontSize: 14, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}

class Quest {
  final String id;
  final String title;
  final String description;
  final int progress;
  final int total;
  final int reward;
  final String category;
  final String difficulty;
  final IconData iconData;
  final String? timeLeft;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.progress,
    required this.total,
    required this.reward,
    required this.category,
    required this.difficulty,
    required this.iconData,
    this.timeLeft,
  });
}
