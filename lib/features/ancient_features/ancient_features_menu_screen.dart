import 'package:flutter/material.dart';
import '../timeline/timeline_screen.dart';
import 'screens/historical_characters_screen.dart';
import 'screens/dynasties_screen.dart';
import 'screens/artifacts_collection_screen.dart';
import 'screens/historical_documents_screen.dart';
import 'screens/virtual_excavation_screen.dart';
import 'screens/archaeological_layers_screen.dart';
import 'screens/mythology_encyclopedia_screen.dart';
import 'screens/sacred_sites_screen.dart';
import 'screens/rituals_screen.dart';
import 'screens/inscriptions_screen.dart';
import 'screens/art_gallery_screen.dart';
import 'screens/costumes_screen.dart';
import 'screens/museum_tour_screen.dart';
import 'screens/historical_recipes_screen.dart';
import 'screens/ancient_music_screen.dart';
import 'screens/trade_routes_screen.dart';
import 'screens/historical_battles_screen.dart';
import 'screens/quiz_screen.dart';
import 'screens/civilization_comparison_screen.dart';
import 'screens/daily_life_screen.dart';
import 'screens/expert_interviews_screen.dart';
import 'screens/archaeology_news_screen.dart';
import 'screens/community_forum_screen.dart';
import 'screens/time_travel_screen.dart';
import 'screens/virtual_reconstruction_screen.dart';
import 'screens/historical_stories_screen.dart';
import 'screens/guided_tours_screen.dart';
import 'screens/period_weather_screen.dart';
import 'screens/my_collections_screen.dart';
import 'screens/ancient_languages_screen.dart';

class AncientFeaturesMenuScreen extends StatelessWidget {
  const AncientFeaturesMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kadim Özellikler'),
        elevation: 2,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        children: [
          _buildSectionHeader('📜 Tarih & Kültür'),
          _buildFeatureGrid(context, [
            _Feature('Zaman Çizelgesi', Icons.timeline, Colors.amber, '/timeline'),
            _Feature('Tarihi Karakterler', Icons.person_pin, Colors.purple, '/characters'),
            _Feature('Hanedanlar', Icons.account_tree, Colors.brown, '/dynasties'),
            _Feature('Tarihi Belgeler', Icons.description, Colors.blueGrey, '/documents'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('🏺 Arkeoloji & Eserler'),
          _buildFeatureGrid(context, [
            _Feature('Eserler Koleksiyonu', Icons.museum, Colors.deepOrange, '/artifacts'),
            _Feature('Sanal Kazı', Icons.construction, Colors.orange[800]!, '/excavation'),
            _Feature('Arkeolojik Katmanlar', Icons.layers, Colors.teal, '/layers'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('🎭 Mitoloji & İnanç'),
          _buildFeatureGrid(context, [
            _Feature('Mitoloji Ansiklopedisi', Icons.auto_stories, Colors.indigo, '/mythology'),
            _Feature('Kutsal Mekanlar', Icons.temple_hindu, Colors.deepPurple, '/sacred-sites'),
            _Feature('Ritüeller & Törenler', Icons.celebration, Colors.pink, '/rituals'),
            _Feature('Antik Yazıtlar', Icons.text_fields, Colors.red[900]!, '/inscriptions'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('🎨 Sanat & Kültür'),
          _buildFeatureGrid(context, [
            _Feature('Antik Sanat Galerisi', Icons.palette, Colors.pink[700]!, '/art-gallery'),
            _Feature('Dönem Kıyafetleri', Icons.checkroom, Colors.purple[400]!, '/costumes'),
            _Feature('Antik Müzik', Icons.music_note, Colors.deepPurple[300]!, '/music'),
            _Feature('Tarihi Yemekler', Icons.restaurant, Colors.orange, '/recipes'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('🗺️ Keşif & Öğrenme'),
          _buildFeatureGrid(context, [
            _Feature('Sanal Müze Turu', Icons.video_label, Colors.blue[700]!, '/museum-tour'),
            _Feature('Rehberli Turlar', Icons.tour, Colors.green, '/guided-tours'),
            _Feature('Ticaret Yolları', Icons.route, Colors.brown[600]!, '/trade-routes'),
            _Feature('Tarihi Savaşlar', Icons.shield, Colors.red[800]!, '/battles'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('📚 Eğitim & Test'),
          _buildFeatureGrid(context, [
            _Feature('Tarih Bilgi Yarışması', Icons.quiz, Colors.green[700]!, '/quiz'),
            _Feature('Antik Dil Öğrenimi', Icons.translate, Colors.teal[600]!, '/languages'),
            _Feature('Medeniyet Karşılaştırma', Icons.compare_arrows, Colors.blue[800]!, '/civilizations'),
            _Feature('Günlük Yaşam', Icons.home_work, Colors.amber[700]!, '/daily-life'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('🌟 Topluluk & Kaynaklar'),
          _buildFeatureGrid(context, [
            _Feature('Uzman Röportajları', Icons.record_voice_over, Colors.purple[600]!, '/interviews'),
            _Feature('Arkeoloji Haberleri', Icons.newspaper, Colors.blueGrey[700]!, '/news'),
            _Feature('Topluluk Forumu', Icons.forum, Colors.indigo[600]!, '/forum'),
            _Feature('Zamanda Yolculuk', Icons.history, Colors.cyan[700]!, '/time-travel'),
          ]),
          SizedBox(height: 16),
          _buildSectionHeader('🎬 Görsel İçerik'),
          _buildFeatureGrid(context, [
            _Feature('Rekonstrüksiyon', Icons.architecture, Colors.orange[700]!, '/reconstruction'),
            _Feature('Tarihi Anlatılar', Icons.auto_stories, Colors.brown[500]!, '/stories'),
            _Feature('Dönem Hava Durumu', Icons.wb_sunny, Colors.yellow[700]!, '/weather'),
            _Feature('Koleksiyonlarım', Icons.bookmarks, Colors.red[600]!, '/bookmarks'),
          ]),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 10, top: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, List<_Feature> features) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.65,
      children: features.map((feature) {
        return _buildFeatureCard(context, feature);
      }).toList(),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _Feature feature) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Widget? screen;
          switch (feature.route) {
            case '/timeline':
              screen = const TimelineScreen(mapId: 'default');
              break;
            case '/characters':
              screen = const HistoricalCharactersScreen();
              break;
            case '/dynasties':
              screen = const DynastiesScreen();
              break;
            case '/artifacts':
              screen = const ArtifactsCollectionScreen();
              break;
            case '/documents':
              screen = const HistoricalDocumentsScreen();
              break;
            case '/excavation':
              screen = const VirtualExcavationScreen();
              break;
            case '/layers':
              screen = const ArchaeologicalLayersScreen();
              break;
            case '/mythology':
              screen = const MythologyEncyclopediaScreen();
              break;
            case '/sacred-sites':
              screen = const SacredSitesScreen();
              break;
            case '/rituals':
              screen = const RitualsScreen();
              break;
            case '/inscriptions':
              screen = const InscriptionsScreen();
              break;
            case '/art-gallery':
              screen = const ArtGalleryScreen();
              break;
            case '/costumes':
              screen = const CostumesScreen();
              break;
            case '/museum-tour':
              screen = const MuseumTourScreen();
              break;
            case '/guided-tours':
              screen = const GuidedToursScreen();
              break;
            case '/recipes':
              screen = const HistoricalRecipesScreen();
              break;
            case '/music':
              screen = const AncientMusicScreen();
              break;
            case '/trade-routes':
              screen = const TradeRoutesScreen();
              break;
            case '/battles':
              screen = const HistoricalBattlesScreen();
              break;
            case '/quiz':
              screen = const QuizScreen();
              break;
            case '/languages':
              screen = const AncientLanguagesScreen();
              break;
            case '/civilizations':
              screen = const CivilizationComparisonScreen();
              break;
            case '/daily-life':
              screen = const DailyLifeScreen();
              break;
            case '/interviews':
              screen = const ExpertInterviewsScreen();
              break;
            case '/news':
              screen = const ArchaeologyNewsScreen();
              break;
            case '/forum':
              screen = const CommunityForumScreen();
              break;
            case '/time-travel':
              screen = const TimeTravelScreen();
              break;
            case '/reconstruction':
              screen = const VirtualReconstructionScreen();
              break;
            case '/stories':
              screen = HistoricalStoriesScreen();
              break;
            case '/weather':
              screen = const PeriodWeatherScreen();
              break;
            case '/bookmarks':
              screen = const MyCollectionsScreen();
              break;
            default:
              return;
          }
          
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen!),
          );
        },
        child: Container(
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                feature.color.withOpacity(0.8),
                feature.color.withOpacity(0.6),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                feature.icon,
                size: 40,
                color: Colors.white,
              ),
              SizedBox(height: 8),
              Flexible(
                child: Text(
                  feature.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black26,
                        offset: Offset(1, 1),
                        blurRadius: 2,
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

class _Feature {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _Feature(this.title, this.icon, this.color, this.route);
}
