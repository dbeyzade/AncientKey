import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class TreasureHuntScreen extends StatefulWidget {
  const TreasureHuntScreen({super.key});

  @override
  State<TreasureHuntScreen> createState() => _TreasureHuntScreenState();
}

class _TreasureHuntScreenState extends State<TreasureHuntScreen> {
  final List<Treasure> nearbyTreasures = [
    Treasure(
      id: '1',
      name: 'Antik Roma Sikkesi',
      description: 'İmparator Augustus dönemine ait altın sikke',
      distance: 120,
      rarity: 'Efsanevi',
      reward: 1500,
      imageIcon: Icons.monetization_on,
      discovered: false,
    ),
    Treasure(
      id: '2',
      name: 'Mısır Papirüsü',
      description: 'Hiyeroglif yazıtlar içeren kadim papirüs',
      distance: 350,
      rarity: 'Nadir',
      reward: 800,
      imageIcon: Icons.description,
      discovered: false,
    ),
    Treasure(
      id: '3',
      name: 'Yunan Amforası',
      description: 'MÖ 5. yüzyıla ait süslemeli seramik vazo',
      distance: 580,
      rarity: 'Normal',
      reward: 400,
      imageIcon: Icons.local_drink,
      discovered: false,
    ),
    Treasure(
      id: '4',
      name: 'Viking Kılıcı',
      description: 'Rünler işlenmiş kadim savaşçı kılıcı',
      distance: 920,
      rarity: 'Nadir',
      reward: 900,
      imageIcon: Icons.sports_martial_arts,
      discovered: false,
    ),
  ];

  final List<Treasure> myCollection = [
    Treasure(
      id: 'c1',
      name: 'Bronz Heykel',
      description: 'Antik Yunan bronz heykel fragmanı',
      distance: 0,
      rarity: 'Normal',
      reward: 300,
      imageIcon: Icons.accessibility_new,
      discovered: true,
    ),
    Treasure(
      id: 'c2',
      name: 'Sümer Tableti',
      description: 'Çivi yazısı içeren kil tablet',
      distance: 0,
      rarity: 'Nadir',
      reward: 700,
      imageIcon: Icons.tablet,
      discovered: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF1A237E), Color(0xFF0D47A1), Color(0xFF01579B)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildStats(),
              Expanded(
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      _buildTabBar(),
                      Expanded(
                        child: TabBarView(
                          children: [_buildNearbyTab(), _buildCollectionTab()],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _startScanning,
        backgroundColor: AppTheme.primaryGold,
        foregroundColor: AppTheme.darkBlue,
        icon: Icon(Icons.radar),
        label: Text('Tara', style: TextStyle(fontWeight: FontWeight.bold)),
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
                  'Hazine Avı',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Etrafındaki tarihi hazineleri keşfet!',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          Icon(Icons.location_on, color: AppTheme.primaryGold),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGold.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            Icons.search,
            '${nearbyTreasures.length}',
            'Yakınında',
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem(
            Icons.inventory,
            '${myCollection.length}',
            'Koleksiyon',
          ),
          Container(width: 1, height: 40, color: Colors.white24),
          _buildStatItem(Icons.stars, '3250', 'Toplam XP'),
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
        Text(label, style: TextStyle(color: Colors.white60, fontSize: 11)),
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
        indicator: BoxDecoration(
          color: AppTheme.primaryGold,
          borderRadius: BorderRadius.circular(12),
        ),
        labelColor: AppTheme.darkBlue,
        unselectedLabelColor: Colors.white70,
        tabs: [
          Tab(text: 'Yakınımda'),
          Tab(text: 'Koleksiyonum'),
        ],
      ),
    );
  }

  Widget _buildNearbyTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: nearbyTreasures.length,
      itemBuilder: (context, index) {
        return _buildTreasureCard(nearbyTreasures[index], false);
      },
    );
  }

  Widget _buildCollectionTab() {
    if (myCollection.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.white30),
            SizedBox(height: 16),
            Text(
              'Henüz hazine bulamadın',
              style: TextStyle(color: Colors.white60, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Etrafını tara ve hazineleri keşfet!',
              style: TextStyle(color: Colors.white30, fontSize: 12),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.85,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: myCollection.length,
      itemBuilder: (context, index) {
        return _buildCollectionCard(myCollection[index]);
      },
    );
  }

  Widget _buildTreasureCard(Treasure treasure, bool isCollection) {
    Color rarityColor = _getRarityColor(treasure.rarity);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [rarityColor.withOpacity(0.2), rarityColor.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rarityColor.withOpacity(0.5), width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showTreasureDetails(treasure),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      colors: [
                        rarityColor.withOpacity(0.3),
                        rarityColor.withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                    border: Border.all(color: rarityColor, width: 2),
                  ),
                  child: Icon(treasure.imageIcon, color: rarityColor, size: 32),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              treasure.name,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(width: 8),
                          _buildRarityBadge(treasure.rarity, rarityColor),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        treasure.description,
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                color: AppTheme.primaryGold,
                                size: 14,
                              ),
                              SizedBox(width: 4),
                              Text(
                                '${treasure.distance}m uzakta',
                                style: TextStyle(
                                  color: AppTheme.primaryGold,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.stars, color: Colors.amber, size: 14),
                              SizedBox(width: 4),
                              Text(
                                '+${treasure.reward}',
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCollectionCard(Treasure treasure) {
    Color rarityColor = _getRarityColor(treasure.rarity);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [rarityColor.withOpacity(0.3), rarityColor.withOpacity(0.1)],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: rarityColor, width: 2),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => _showTreasureDetails(treasure),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(treasure.imageIcon, color: rarityColor, size: 48),
                SizedBox(height: 12),
                Text(
                  treasure.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                ),
                SizedBox(height: 8),
                _buildRarityBadge(treasure.rarity, rarityColor),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.stars, color: Colors.amber, size: 14),
                    SizedBox(width: 4),
                    Text(
                      '+${treasure.reward}',
                      style: TextStyle(color: Colors.amber, fontSize: 12),
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

  Widget _buildRarityBadge(String rarity, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        rarity,
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'Efsanevi':
        return Color(0xFFFF6B00);
      case 'Nadir':
        return Color(0xFF9C27B0);
      case 'Normal':
        return Color(0xFF2196F3);
      default:
        return Colors.grey;
    }
  }

  void _startScanning() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppTheme.primaryGold),
            SizedBox(height: 20),
            Text(
              'Etraf taranıyor...',
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
            SizedBox(height: 8),
            Text(
              'Hazineler aranıyor 📡',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Navigator.pop(context);
      _showScanResults();
    });
  }

  void _showScanResults() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.search, color: AppTheme.primaryGold),
            SizedBox(width: 12),
            Text(
              'Tarama Tamamlandı!',
              style: TextStyle(color: AppTheme.primaryGold),
            ),
          ],
        ),
        content: Text(
          '${nearbyTreasures.length} hazine tespit edildi! En yakın hazine ${nearbyTreasures.first.distance}m uzaklıkta.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _navigateToTreasure(nearbyTreasures.first);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.primaryGold,
              foregroundColor: AppTheme.darkBlue,
            ),
            child: Text('Yönlendir'),
          ),
        ],
      ),
    );
  }

  void _navigateToTreasure(Treasure treasure) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('🧭 ${treasure.name} konumuna yönlendiriliyor...'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _showTreasureDetails(Treasure treasure) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.darkBlue,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(treasure.imageIcon, color: _getRarityColor(treasure.rarity)),
            SizedBox(width: 12),
            Expanded(
              child: Text(treasure.name, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(treasure.description, style: TextStyle(color: Colors.white70)),
            SizedBox(height: 16),
            _buildDetailRow('Nadir Seviyesi', treasure.rarity),
            _buildDetailRow('Ödül', '+${treasure.reward} XP'),
            if (!treasure.discovered)
              _buildDetailRow('Uzaklık', '${treasure.distance}m'),
            if (treasure.discovered) _buildDetailRow('Durum', 'Keşfedildi ✅'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Kapat', style: TextStyle(color: Colors.white70)),
          ),
          if (!treasure.discovered)
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _navigateToTreasure(treasure);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primaryGold,
                foregroundColor: AppTheme.darkBlue,
              ),
              child: Text('Git'),
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
          Text(label, style: TextStyle(color: Colors.white60)),
          Text(
            value,
            style: TextStyle(
              color: AppTheme.primaryGold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class Treasure {
  final String id;
  final String name;
  final String description;
  final int distance;
  final String rarity;
  final int reward;
  final IconData imageIcon;
  final bool discovered;

  Treasure({
    required this.id,
    required this.name,
    required this.description,
    required this.distance,
    required this.rarity,
    required this.reward,
    required this.imageIcon,
    required this.discovered,
  });
}
