import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math';
import '../../../core/services/virtual_excavation_service.dart';

final excavationProvider = FutureProvider<List<ExcavationSite>>((ref) async {
  return VirtualExcavationService().getAllSites();
});

class VirtualExcavationScreen extends ConsumerWidget {
  const VirtualExcavationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsync = ref.watch(excavationProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sanal Kazı'),
        elevation: 2,
      ),
      body: sitesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
        data: (sites) {
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return _ExcavationSiteCard(site: site);
            },
          );
        },
      ),
    );
  }
}

class _ExcavationSiteCard extends StatelessWidget {
  final ExcavationSite site;

  const _ExcavationSiteCard({required this.site});

  String _getSiteName(String siteId) {
    final names = {
      'troy_excavation': 'Truva',
      'pompeii_excavation': 'Pompeii',
      'giza_excavation': 'Giza Piramitleri',
      'babylon_excavation': 'Babil',
      'machu_picchu_excavation': 'Machu Picchu',
      'angkor_wat_excavation': 'Angkor Wat',
      'petra_excavation': 'Petra',
      'ephesus_excavation': 'Efes',
      'teotihuacan_excavation': 'Teotihuacan',
      'stonehenge_excavation': 'Stonehenge',
    };
    return names[siteId] ?? siteId;
  }

  Color _getCivilizationColor(String civilization) {
    final colors = {
      'troy': Colors.orange,
      'pompeii': Colors.red,
      'giza': Colors.amber,
      'babylon': Colors.purple,
      'machu': Colors.green,
      'angkor': Colors.teal,
      'petra': Colors.pink,
      'ephesus': Colors.blue,
      'teotihuacan': Colors.indigo,
      'stonehenge': Colors.blueGrey,
    };
    return colors[civilization] ?? Colors.brown;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ExcavationGameScreen(site: site),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getCivilizationColor(site.civilization).withOpacity(0.1),
                _getCivilizationColor(site.civilization).withOpacity(0.05),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.construction,
                    size: 32,
                    color: _getCivilizationColor(site.civilization),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getSiteName(site.name),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        Text(
                          'Seviye ${site.userLevel}',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.chevron_right, color: Colors.grey),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildStat('Eserler', site.artifactsFound.toString(), Icons.diamond),
                  ),
                  Expanded(
                    child: _buildStat('Alanlar', site.areasExplored.toString(), Icons.explore),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStat(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: _getCivilizationColor(site.civilization)),
        SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

class ExcavationGameScreen extends StatefulWidget {
  final ExcavationSite site;

  const ExcavationGameScreen({super.key, required this.site});

  @override
  State<ExcavationGameScreen> createState() => _ExcavationGameScreenState();
}

class _ExcavationGameScreenState extends State<ExcavationGameScreen> {
  late int artifactsFound;
  late int areasExplored;
  final Random random = Random();
  List<String> recentFinds = [];

  @override
  void initState() {
    super.initState();
    artifactsFound = widget.site.artifactsFound;
    areasExplored = widget.site.areasExplored;
  }

  void _dig() {
    setState(() {
      areasExplored++;
      
      // 60% chance to find something
      if (random.nextDouble() < 0.6) {
        artifactsFound++;
        final artifacts = [
          'Antik Çömlek',
          'Bronz Heykelcik',
          'Altın Sikke',
          'Mermer Parçası',
          'Seramik Kap',
          'Değerli Taş',
          'Eski Silah',
          'Mühür',
          'Mücevher',
          'Tablet',
        ];
        recentFinds.add(artifacts[random.nextInt(artifacts.length)]);
        if (recentFinds.length > 5) recentFinds.removeAt(0);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('🎉 ${recentFinds.last} buldunuz!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Bu alanda bir şey bulamadınız.'),
            duration: Duration(seconds: 1),
          ),
        );
      }
    });

    // Save progress
    VirtualExcavationService().updateProgress(
      widget.site.name,
      artifactsFound,
      areasExplored,
      recentFinds,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kazı - ${_getSiteName(widget.site.name)}'),
        elevation: 2,
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.brown[100],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatChip('Bulunan Eser', artifactsFound.toString(), Icons.diamond, Colors.amber),
                _buildStatChip('Kazılan Alan', areasExplored.toString(), Icons.explore, Colors.blue),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.construction,
                    size: 120,
                    color: Colors.brown[300],
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: _dig,
                    icon: Icon(Icons.touch_app, size: 28),
                    label: Text(
                      'KAZI YAP',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 20),
                      backgroundColor: Colors.brown[700],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                  SizedBox(height: 32),
                  if (recentFinds.isNotEmpty) ...[
                    Text(
                      'Son Bulunanlar:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 16),
                    ...recentFinds.reversed.take(5).map((find) => Padding(
                      padding: EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 20),
                          SizedBox(width: 8),
                          Text(
                            find,
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ],
                      ),
                    )),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatChip(String label, String value, IconData icon, Color color) {
    return Chip(
      avatar: Icon(icon, color: color, size: 20),
      label: Text('$label: $value'),
      backgroundColor: Colors.white,
      labelStyle: TextStyle(fontWeight: FontWeight.bold),
    );
  }

  String _getSiteName(String siteId) {
    final names = {
      'troy_excavation': 'Truva',
      'pompeii_excavation': 'Pompeii',
      'giza_excavation': 'Giza Piramitleri',
      'babylon_excavation': 'Babil',
      'machu_picchu_excavation': 'Machu Picchu',
      'angkor_wat_excavation': 'Angkor Wat',
      'petra_excavation': 'Petra',
      'ephesus_excavation': 'Efes',
      'teotihuacan_excavation': 'Teotihuacan',
      'stonehenge_excavation': 'Stonehenge',
    };
    return names[siteId] ?? siteId;
  }
}
