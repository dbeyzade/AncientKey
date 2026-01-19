import 'package:flutter/material.dart';
import 'screens/civilizations_encyclopedia_screen.dart';
import 'screens/interactive_timeline_screen.dart';
import 'screens/mythology_screen.dart';
import 'screens/trade_routes_screen.dart';
import 'screens/ancient_wars_screen.dart';
import 'screens/virtual_excavation_screen.dart';
import 'screens/history_quiz_screen.dart';
import 'screens/hieroglyph_decoder_screen.dart';
import 'screens/carbon_dating_screen.dart';
import 'screens/pottery_restore_game_screen.dart';
import 'screens/excavation_journal_screen.dart';

class AncientHistoryHubScreen extends StatelessWidget {
  const AncientHistoryHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Tarih ve Medeniyetler'),
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[800]!, Colors.purple[600]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple[900]!, Colors.black],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSectionHeader('📚 Bilgi ve Eğitim', Icons.school),
            _buildFeatureGrid(context, [
              _HistoryFeature(
                'Antik Medeniyetler',
                Icons.account_balance,
                Colors.amber,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CivilizationsEncyclopediaScreen(),
                  ),
                ),
              ),
              _HistoryFeature(
                'Tarih Zaman Çizelgesi',
                Icons.timeline,
                Colors.blue,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const InteractiveTimelineScreen(),
                  ),
                ),
              ),
              _HistoryFeature(
                'Hiyeroglif Çözücü',
                Icons.translate,
                Colors.green,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HieroglyphDecoderScreen(),
                  ),
                ),
              ),
              _HistoryFeature(
                'Karbon-14 Tarihleme',
                Icons.science,
                Colors.cyan,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CarbonDatingScreen()),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionHeader('🏺 Kültür ve Sanat', Icons.museum),
            _buildFeatureGrid(context, [
              _HistoryFeature(
                'Seramik Restore',
                Icons.broken_image,
                Colors.brown,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const PotteryRestoreGameScreen(),
                  ),
                ),
              ),
              _HistoryFeature(
                'Kazı Defteri',
                Icons.book,
                Colors.red,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ExcavationJournalScreen(),
                  ),
                ),
              ),
              _HistoryFeature(
                'Mitoloji & Tanrılar',
                Icons.auto_awesome,
                Colors.purple,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MythologyScreen()),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionHeader('⚔️ Yaşam ve Toplum', Icons.groups),
            _buildFeatureGrid(context, [
              _HistoryFeature(
                'Ticaret Yolları',
                Icons.route,
                Colors.teal,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TradeRoutesScreen()),
                ),
              ),
              _HistoryFeature(
                'Antik Savaşlar',
                Icons.shield,
                Colors.red[800]!,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AncientWarsScreen()),
                ),
              ),
            ]),

            const SizedBox(height: 24),
            _buildSectionHeader(
              '🎮 İnteraktif Deneyimler',
              Icons.sports_esports,
            ),
            _buildFeatureGrid(context, [
              _HistoryFeature(
                'Sanal Kazı',
                Icons.landscape,
                Colors.brown[600]!,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VirtualExcavationScreen(),
                  ),
                ),
              ),
              _HistoryFeature(
                'Tarih Bilgi Yarışması',
                Icons.quiz,
                Colors.deepOrange,
                () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const HistoryQuizScreen()),
                ),
              ),
            ]),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.amber, Colors.orange]),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.black, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(
    BuildContext context,
    List<_HistoryFeature> features,
  ) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.2,
      children: features.map((feature) => _buildFeatureCard(feature)).toList(),
    );
  }

  Widget _buildFeatureCard(_HistoryFeature feature) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: feature.onTap,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                feature.color.withOpacity(0.8),
                feature.color.withOpacity(0.6),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: feature.color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(feature.icon, size: 32, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  feature.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.2,
                    shadows: [
                      Shadow(
                        color: Colors.black54,
                        offset: Offset(1, 1),
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HistoryFeature {
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _HistoryFeature(this.title, this.icon, this.color, this.onTap);
}
