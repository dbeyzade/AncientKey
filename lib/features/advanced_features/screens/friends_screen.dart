import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class FriendsScreen extends StatefulWidget {
  const FriendsScreen({super.key});

  @override
  State<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends State<FriendsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Friend> friends = [
    Friend(
      id: '1',
      name: 'Ayşe Yılmaz',
      avatar: '📜',
      level: 39,
      status: 'online',
      lastActivity: 'Mısır Piramitleri turunda',
      mutualFriends: 5,
      joinDate: DateTime(2024, 1, 15),
    ),
    Friend(
      id: '2',
      name: 'Mehmet Kemal',
      avatar: '🏆',
      level: 42,
      status: 'online',
      lastActivity: 'Hazine avında',
      mutualFriends: 8,
      joinDate: DateTime(2023, 11, 20),
    ),
    Friend(
      id: '3',
      name: 'Zeynep Kaya',
      avatar: '⚔️',
      level: 35,
      status: 'away',
      lastActivity: '2 saat önce aktifti',
      mutualFriends: 3,
      joinDate: DateTime(2024, 2, 10),
    ),
    Friend(
      id: '4',
      name: 'Can Demir',
      avatar: '🗿',
      level: 28,
      status: 'offline',
      lastActivity: 'Dün aktifti',
      mutualFriends: 2,
      joinDate: DateTime(2024, 3, 5),
    ),
  ];

  final List<FriendRequest> pendingRequests = [
    FriendRequest(
      id: 'r1',
      name: 'Emma Wilson',
      avatar: '💎',
      level: 37,
      mutualFriends: 4,
      message: 'Senin profilini çok beğendim! Arkadaş olalım mı?',
    ),
    FriendRequest(
      id: 'r2',
      name: 'Ahmed Hassan',
      avatar: '🦅',
      level: 33,
      mutualFriends: 2,
      message: null,
    ),
  ];

  final List<Suggestion> suggestions = [
    Suggestion(
      id: 's1',
      name: 'Giovanni Rossi',
      avatar: '🏛️',
      level: 38,
      mutualFriends: 6,
      reason: 'Roma tarihine ilgi duyuyor',
    ),
    Suggestion(
      id: 's2',
      name: 'Yuki Tanaka',
      avatar: '⛩️',
      level: 36,
      mutualFriends: 3,
      reason: 'Yakın bölgede',
    ),
    Suggestion(
      id: 's3',
      name: 'Marcus Chen',
      avatar: '🗿',
      level: 40,
      mutualFriends: 5,
      reason: 'Benzer görevlerde başarılı',
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
              Color(0xFF1565C0),
              Color(0xFF1976D2),
              Color(0xFF1E88E5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildQuickStats(),
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildFriendsList(),
                    _buildRequestsList(),
                    _buildSuggestionsList(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addFriend,
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: AppTheme.darkBlue,
        icon: Icon(Icons.person_add),
        label: Text('Arkadaş Ekle', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  'Arkadaşlar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Birlikte keşfetmek daha eğlenceli!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          if (pendingRequests.isNotEmpty)
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                '${pendingRequests.length}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
          _buildStatItem(Icons.people, '${friends.length}', 'Arkadaş'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem(Icons.notifications, '${pendingRequests.length}', 'İstek'),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem(Icons.online_prediction, '${friends.where((f) => f.status == 'online').length}', 'Çevrimiçi'),
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
          Tab(text: 'Arkadaşlar'),
          Tab(text: 'İstekler (${pendingRequests.length})'),
          Tab(text: 'Öneriler'),
        ],
      ),
    );
  }

  Widget _buildFriendsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return _buildFriendCard(friends[index]);
      },
    );
  }

  Widget _buildFriendCard(Friend friend) {
    Color statusColor = _getStatusColor(friend.status);
    
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showFriendProfile(friend),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          colors: [
                            AppTheme.primaryGold.withOpacity(0.3),
                            AppTheme.primaryGold.withOpacity(0.1),
                          ],
                        ),
                        shape: BoxShape.circle,
                        border: Border.all(color: statusColor, width: 3),
                      ),
                      child: Center(
                        child: Text(friend.avatar, style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: statusColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        friend.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppTheme.primaryGold, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Seviye ${friend.level}',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.people, color: Colors.blue, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '${friend.mutualFriends} ortak',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        friend.lastActivity,
                        style: TextStyle(
                          color: statusColor,
                          fontSize: 11,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Colors.white70),
                  color: AppTheme.darkBlue,
                  onSelected: (value) {
                    switch (value) {
                      case 'profile':
                        _showFriendProfile(friend);
                        break;
                      case 'message':
                        _sendMessage(friend);
                        break;
                      case 'remove':
                        _removeFriend(friend);
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      value: 'profile',
                      child: Row(
                        children: [
                          Icon(Icons.person, color: Colors.white70),
                          SizedBox(width: 12),
                          Text('Profili Gör', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'message',
                      child: Row(
                        children: [
                          Icon(Icons.message, color: Colors.white70),
                          SizedBox(width: 12),
                          Text('Mesaj Gönder', style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'remove',
                      child: Row(
                        children: [
                          Icon(Icons.person_remove, color: Colors.red),
                          SizedBox(width: 12),
                          Text('Arkadaşlıktan Çıkar', style: TextStyle(color: Colors.red)),
                        ],
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

  Widget _buildRequestsList() {
    if (pendingRequests.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 64, color: Colors.white30),
            SizedBox(height: 16),
            Text(
              'Yeni istek yok',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pendingRequests.length,
      itemBuilder: (context, index) {
        return _buildRequestCard(pendingRequests[index]);
      },
    );
  }

  Widget _buildRequestCard(FriendRequest request) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.withOpacity(0.2),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.withOpacity(0.5), width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
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
                    child: Text(request.avatar, style: TextStyle(fontSize: 24)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(Icons.star, color: AppTheme.primaryGold, size: 14),
                          SizedBox(width: 4),
                          Text(
                            'Seviye ${request.level}',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                          SizedBox(width: 12),
                          Icon(Icons.people, color: Colors.blue, size: 14),
                          SizedBox(width: 4),
                          Text(
                            '${request.mutualFriends} ortak arkadaş',
                            style: TextStyle(color: Colors.white70, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (request.message != null) ...[
              SizedBox(height: 12),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  request.message!,
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ),
            ],
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _acceptRequest(request),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Kabul Et', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _declineRequest(request),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text('Reddet', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionsList() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        return _buildSuggestionCard(suggestions[index]);
      },
    );
  }

  Widget _buildSuggestionCard(Suggestion suggestion) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.purple.withOpacity(0.15),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.purple.withOpacity(0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  colors: [
                    Colors.purple.withOpacity(0.3),
                    Colors.purple.withOpacity(0.1),
                  ],
                ),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(suggestion.avatar, style: TextStyle(fontSize: 24)),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    suggestion.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppTheme.primaryGold, size: 14),
                      SizedBox(width: 4),
                      Text(
                        'Seviye ${suggestion.level}',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.people, color: Colors.blue, size: 14),
                      SizedBox(width: 4),
                      Text(
                        '${suggestion.mutualFriends} ortak',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text(
                    suggestion.reason,
                    style: TextStyle(
                      color: Colors.purple[200],
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              onPressed: () => _sendFriendRequest(suggestion),
              icon: Icon(Icons.person_add, color: AppTheme.primaryGold),
              style: IconButton.styleFrom(
                backgroundColor: AppTheme.primaryGold.withOpacity(0.2),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'online':
        return Colors.green;
      case 'away':
        return Colors.orange;
      case 'offline':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  void _showFriendProfile(Friend friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Text(friend.avatar, style: TextStyle(fontSize: 32)),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(friend.name, style: TextStyle(color: Colors.white)),
                  Text('Seviye ${friend.level}', style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildProfileRow('Son Aktivite', friend.lastActivity),
            _buildProfileRow('Ortak Arkadaş', '${friend.mutualFriends}'),
            _buildProfileRow('Katılma', '${friend.joinDate.day}/${friend.joinDate.month}/${friend.joinDate.year}'),
            _buildProfileRow('Durum', friend.status),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _sendMessage(friend);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.darkBlue,
            ),
            child: Text('Mesaj Gönder'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.white60)),
          Text(value, style: TextStyle(color: AppTheme.primaryGold, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _sendMessage(Friend friend) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Mesaj Gönder', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: controller,
          style: TextStyle(color: Colors.white),
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Mesajını yaz...',
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
            child: Text('İptal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${friend.name} kişisine mesaj gönderildi ✅')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.primaryGold),
            child: Text('Gönder', style: TextStyle(color: AppTheme.darkBlue)),
          ),
        ],
      ),
    );
  }

  void _removeFriend(Friend friend) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Arkadaşlıktan Çıkar', style: TextStyle(color: Colors.red)),
        content: Text(
          '${friend.name} ile arkadaşlığını sonlandırmak istediğinden emin misin?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                friends.remove(friend);
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${friend.name} arkadaş listenden çıkarıldı'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text('Çıkar'),
          ),
        ],
      ),
    );
  }

  void _acceptRequest(FriendRequest request) {
    setState(() {
      pendingRequests.remove(request);
      friends.add(Friend(
        id: request.id,
        name: request.name,
        avatar: request.avatar,
        level: request.level,
        status: 'online',
        lastActivity: 'Yeni eklendi',
        mutualFriends: request.mutualFriends,
        joinDate: DateTime.now(),
      ));
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('✅ ${request.name} arkadaş listene eklendi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _declineRequest(FriendRequest request) {
    setState(() {
      pendingRequests.remove(request);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('❌ Arkadaşlık isteği reddedildi'),
        backgroundColor: Colors.orange,
      ),
    );
  }

  void _sendFriendRequest(Suggestion suggestion) {
    setState(() {
      suggestions.remove(suggestion);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('📨 ${suggestion.name} kişisine arkadaşlık isteği gönderildi!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _addFriend() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Arkadaş Ekle', style: TextStyle(color: AppTheme.primaryGold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Kullanıcı adı veya e-posta',
                hintStyle: TextStyle(color: Colors.white54),
                prefixIcon: Icon(Icons.search, color: AppTheme.primaryGold),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('🔍 Kullanıcı aranıyor...'),
                  backgroundColor: Colors.blue,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.darkBlue,
            ),
            child: Text('Ara'),
          ),
        ],
      ),
    );
  }
}

class Friend {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final String status;
  final String lastActivity;
  final int mutualFriends;
  final DateTime joinDate;

  Friend({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.status,
    required this.lastActivity,
    required this.mutualFriends,
    required this.joinDate,
  });
}

class FriendRequest {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final int mutualFriends;
  final String? message;

  FriendRequest({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.mutualFriends,
    this.message,
  });
}

class Suggestion {
  final String id;
  final String name;
  final String avatar;
  final int level;
  final int mutualFriends;
  final String reason;

  Suggestion({
    required this.id,
    required this.name,
    required this.avatar,
    required this.level,
    required this.mutualFriends,
    required this.reason,
  });
}
