import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<LeaderboardEntry> globalLeaders = [
    LeaderboardEntry(
      rank: 1,
      name: 'Mehmet Kemal',
      xp: 15420,
      avatar: '🏆',
      level: 42,
      country: '🇹🇷',
    ),
    LeaderboardEntry(
      rank: 2,
      name: 'Alexandra Stone',
      xp: 14890,
      avatar: '⚔️',
      level: 41,
      country: '🇬🇧',
    ),
    LeaderboardEntry(
      rank: 3,
      name: 'Marcus Chen',
      xp: 14120,
      avatar: '🗿',
      level: 40,
      country: '🇨🇳',
    ),
    LeaderboardEntry(
      rank: 4,
      name: 'Ayşe Yılmaz',
      xp: 13650,
      avatar: '📜',
      level: 39,
      country: '🇹🇷',
    ),
    LeaderboardEntry(
      rank: 5,
      name: 'Giovanni Rossi',
      xp: 13200,
      avatar: '🏛️',
      level: 38,
      country: '🇮🇹',
    ),
    LeaderboardEntry(
      rank: 6,
      name: 'Emma Wilson',
      xp: 12780,
      avatar: '💎',
      level: 37,
      country: '🇺🇸',
    ),
    LeaderboardEntry(
      rank: 7,
      name: 'Ahmed Hassan',
      xp: 12450,
      avatar: '🦅',
      level: 37,
      country: '🇪🇬',
    ),
    LeaderboardEntry(
      rank: 8,
      name: 'Yuki Tanaka',
      xp: 12100,
      avatar: '⛩️',
      level: 36,
      country: '🇯🇵',
    ),
    LeaderboardEntry(
      rank: 15,
      name: 'Sen (Doğukan)',
      xp: 9340,
      avatar: '🔑',
      level: 31,
      country: '🇹🇷',
      isCurrentUser: true,
    ),
  ];

  final List<LeaderboardEntry> weeklyLeaders = [
    LeaderboardEntry(
      rank: 1,
      name: 'Ayşe Yılmaz',
      xp: 2840,
      avatar: '📜',
      level: 39,
      country: '🇹🇷',
    ),
    LeaderboardEntry(
      rank: 2,
      name: 'Mehmet Kemal',
      xp: 2650,
      avatar: '🏆',
      level: 42,
      country: '🇹🇷',
    ),
    LeaderboardEntry(
      rank: 3,
      name: 'Emma Wilson',
      xp: 2420,
      avatar: '💎',
      level: 37,
      country: '🇺🇸',
    ),
    LeaderboardEntry(
      rank: 7,
      name: 'Sen (Doğukan)',
      xp: 1890,
      avatar: '🔑',
      level: 31,
      country: '🇹🇷',
      isCurrentUser: true,
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
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF283593), Color(0xFF3949AB)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildTopThree(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildLeaderboardList(globalLeaders),
                    _buildLeaderboardList(weeklyLeaders),
                    _buildFriendsTab(),
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
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lider Tablosu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'En iyi tarih kaşiflerini gör!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.emoji_events, color: AppTheme.primaryGold, size: 28),
        ],
      ),
    );
  }

  Widget _buildTopThree() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // 2nd place (left)
          Positioned(
            left: 0,
            bottom: 0,
            child: _buildPodiumItem(
              globalLeaders[1],
              2,
              100,
              Color(0xFFC0C0C0),
            ),
          ),
          // 1st place (center)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Center(
              child: _buildPodiumItem(
                globalLeaders[0],
                1,
                140,
                Color(0xFFFFD700),
              ),
            ),
          ),
          // 3rd place (right)
          Positioned(
            right: 0,
            bottom: 0,
            child: _buildPodiumItem(globalLeaders[2], 3, 80, Color(0xFFCD7F32)),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumItem(
    LeaderboardEntry entry,
    int position,
    double height,
    Color color,
  ) {
    IconData icon = position == 1
        ? Icons.emoji_events
        : (position == 2 ? Icons.military_tech : Icons.workspace_premium);

    return SizedBox(
      width: 100,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.5),
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: position == 1 ? 20 : 16,
            ),
          ),
          SizedBox(height: 8),
          Text(
            entry.avatar,
            style: TextStyle(fontSize: position == 1 ? 32 : 24),
          ),
          SizedBox(height: 4),
          Text(
            entry.name.split(' ')[0],
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          Text(
            'Lvl ${entry.level}',
            style: TextStyle(color: Colors.white70, fontSize: 10),
          ),
          SizedBox(height: 4),
          Container(
            width: 100,
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [color.withOpacity(0.8), color.withOpacity(0.5)],
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
              border: Border.all(color: color, width: 2),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '#$position',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: position == 1 ? 28 : 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${entry.xp} XP',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
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
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: AppTheme.primaryGold,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppTheme.darkBlue,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: 'Küresel'),
          Tab(text: 'Haftalık'),
          Tab(text: 'Arkadaşlar'),
        ],
      ),
    );
  }

  Widget _buildLeaderboardList(List<LeaderboardEntry> entries) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: entries.length,
      itemBuilder: (context, index) {
        return _buildLeaderboardCard(entries[index]);
      },
    );
  }

  Widget _buildLeaderboardCard(LeaderboardEntry entry) {
    Color rankColor;
    if (entry.rank == 1) {
      rankColor = Color(0xFFFFD700);
    } else if (entry.rank == 2) {
      rankColor = Color(0xFFC0C0C0);
    } else if (entry.rank == 3) {
      rankColor = Color(0xFFCD7F32);
    } else {
      rankColor = Colors.white60;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppTheme.primaryGold.withOpacity(0.2)
            : Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: entry.isCurrentUser
              ? AppTheme.primaryGold
              : Colors.white.withOpacity(0.1),
          width: entry.isCurrentUser ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showUserProfile(entry),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: rankColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: rankColor, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      '#${entry.rank}',
                      style: TextStyle(
                        color: rankColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        AppTheme.primaryGold.withOpacity(0.3),
                        AppTheme.primaryGold.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(entry.avatar, style: TextStyle(fontSize: 28)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              entry.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Text(entry.country, style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.star,
                            color: AppTheme.primaryGold,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Seviye ${entry.level}',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                          SizedBox(width: 16),
                          Icon(
                            Icons.emoji_events,
                            color: Colors.amber,
                            size: 14,
                          ),
                          SizedBox(width: 4),
                          Text(
                            '${entry.xp} XP',
                            style: TextStyle(
                              color: Colors.amber,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (entry.isCurrentUser)
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.primaryGold,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'Sen',
                      style: TextStyle(
                        color: AppTheme.darkBlue,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFriendsTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 64, color: Colors.white30),
          SizedBox(height: 16),
          Text(
            'Henüz arkadaşın yok',
            style: TextStyle(color: Colors.white60, fontSize: 16),
          ),
          SizedBox(height: 8),
          Text(
            'Arkadaş ekle ve yarış!',
            style: TextStyle(color: Colors.white30, fontSize: 12),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              _showInviteFriendDialog();
            },
            icon: Icon(Icons.person_add),
            label: Text('Arkadaş Ekle'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.darkBlue,
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  void _showInviteFriendDialog() {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          'Arkadaş Davet Et',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'E-posta veya kullanıcı adı',
            hintStyle: TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.white12,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Davet gönderildi ✅')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
            ),
            child: const Text(
              'Gönder',
              style: TextStyle(color: AppTheme.darkBlue),
            ),
          ),
        ],
      ),
    );
  }

  void _showUserProfile(LeaderboardEntry entry) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(entry.avatar, style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.name,
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    'Seviye ${entry.level}',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            ),
            Text(entry.country, style: TextStyle(fontSize: 24)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProfileStat('Sıralama', '#${entry.rank}', Icons.leaderboard),
            _buildProfileStat('Toplam XP', '${entry.xp}', Icons.stars),
            _buildProfileStat('Seviye', '${entry.level}', Icons.trending_up),
          ],
        ),
        actions: [
          if (!entry.isCurrentUser) ...[
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.person_add, color: AppTheme.primaryGold),
              label: Text(
                'Arkadaş Ekle',
                style: TextStyle(color: AppTheme.primaryGold),
              ),
            ),
          ],
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: Colors.white70)),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileStat(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: AppTheme.primaryGold, size: 20),
          SizedBox(width: 12),
          Text(label, style: TextStyle(color: Colors.white70, fontSize: 14)),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class LeaderboardEntry {
  final int rank;
  final String name;
  final int xp;
  final String avatar;
  final int level;
  final String country;
  final bool isCurrentUser;

  LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.xp,
    required this.avatar,
    required this.level,
    required this.country,
    this.isCurrentUser = false,
  });
}
