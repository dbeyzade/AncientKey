import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/quest_system_screen.dart';
import 'screens/treasure_hunt_screen.dart';
import 'screens/leaderboard_screen.dart';
import 'screens/social_tours_screen.dart';
import 'screens/friends_screen.dart';
import 'screens/multiplayer_challenges_screen.dart';
import 'screens/live_events_screen.dart';
import 'screens/ar_multiplayer_screen.dart';
import 'screens/mini_games_screen.dart';
import 'screens/achievement_badges_screen.dart';
import 'screens/creative/3d_model_creator_screen.dart';
import 'screens/creative/custom_map_editor_screen.dart';
import 'screens/creative/photo_filters_screen.dart';
import 'screens/professional/site_simulator_screen.dart';
import 'screens/professional/dating_calculator_screen.dart';
import 'screens/professional/restoration_planner_screen.dart';
import 'screens/professional/field_notes_screen.dart';
import 'screens/analytics/heat_map_screen.dart';
import 'screens/personalized_recommendations_screen.dart';
import 'screens/vr_historical_experiences_screen.dart';
import 'screens/hologram_projection_screen.dart';
import 'screens/audio_guides_3d_screen.dart';
import 'screens/time_travel_simulator_screen.dart';
import 'screens/climate_simulator_screen.dart';
import 'screens/virtual_laboratory_screen.dart';
import 'screens/research_projects_screen.dart';

class AdvancedFeaturesMenuScreen extends StatefulWidget {
  const AdvancedFeaturesMenuScreen({super.key});

  @override
  State<AdvancedFeaturesMenuScreen> createState() => _AdvancedFeaturesMenuScreenState();
}

class _AdvancedFeaturesMenuScreenState extends State<AdvancedFeaturesMenuScreen> {
  bool _showBanner = false;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _checkBannerStatus();
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkBannerStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final hasJoined = prefs.getBool('joined_competition') ?? false;
    final joinTimestamp = prefs.getInt('join_timestamp') ?? 0;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    // Eğer katıldıysa ve 2 saniye geçmediyse banner'ı göster
    if (hasJoined && (now - joinTimestamp) < 2000) {
      setState(() {
        _showBanner = true;
      });
      
      // Kalan süreyi hesapla ve timer başlat
      final remainingTime = 2000 - (now - joinTimestamp);
      _bannerTimer = Timer(Duration(milliseconds: remainingTime), () {
        if (mounted) {
          setState(() {
            _showBanner = false;
          });
        }
      });
    } else {
      setState(() {
        _showBanner = false;
      });
    }
  }

  Future<void> _dismissBanner() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('joined_competition', true);
    setState(() {
      _showBanner = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Check banner status every time this screen is built
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBannerStatus();
    });
    
    return Scaffold(
      appBar: AppBar(
        title: Text('🚀 İleri Seviye Özellikler'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purple[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          ListView(
            padding: EdgeInsets.only(left: 16, right: 16, top: 16, bottom: _showBanner ? 100 : 16),
        children: [
          _buildSectionHeader('👥 Sosyal & Çok Oyunculu'),
          _buildFeatureGrid(context, [
            _Feature('Çok Oyunculu Mücadeleler', Icons.emoji_events, Colors.amber[700]!, '/multiplayer'),
            _Feature('Sosyal Keşif Turları', Icons.groups, Colors.green[600]!, '/expeditions'),
            _Feature('Canlı Etkinlikler', Icons.live_tv, Colors.red[700]!, '/live-events'),
            _Feature('Arkadaş Sistemi', Icons.people, Colors.pink[600]!, '/friends'),
            _Feature('AR Multiplayer', Icons.view_in_ar, Colors.deepPurple[500]!, '/ar-multi'),
          ]),
          SizedBox(height: 24),
          _buildSectionHeader('🎮 Oyunlaştırma & Macera'),
          _buildFeatureGrid(context, [
            _Feature('Görev Sistemi', Icons.assignment, Colors.orange[700]!, '/quests'),
            _Feature('Hazine Avı', Icons.map_outlined, Colors.brown[600]!, '/treasure-hunt'),
            _Feature('Mini Oyunlar', Icons.games, Colors.lightBlue[600]!, '/mini-games'),
            _Feature('Lider Tablosu', Icons.leaderboard, Colors.yellow[800]!, '/leaderboard'),
            _Feature('Başarım Rozetleri', Icons.military_tech, Colors.amber[900]!, '/badges'),
          ]),
          SizedBox(height: 24),
          _buildSectionHeader('🎨 Yaratıcı Araçlar'),
          _buildFeatureGrid(context, [
            _Feature('3D Model Oluşturucu', Icons.view_in_ar, Colors.cyan[600]!, '/3d-creator'),
            _Feature('Özel Harita Editörü', Icons.edit_location, Colors.teal[700]!, '/map-editor'),
            _Feature('Fotoğraf Filtreleri', Icons.filter_vintage, Colors.purple[500]!, '/photo-filters'),
          ]),
          SizedBox(height: 24),
          _buildSectionHeader('🔬 Profesyonel Araçlar'),
          _buildFeatureGrid(context, [
            _Feature('Arkeolojik Saha Simülatörü', Icons.construction, Colors.orange[800]!, '/site-simulator'),
            _Feature('Tarihleme Hesaplayıcı', Icons.science, Colors.blue[800]!, '/dating-calculator'),
            _Feature('Restorasyon Planlayıcı', Icons.architecture, Colors.brown[700]!, '/restoration-planner'),
            _Feature('Saha Notları & Eskizler', Icons.draw, Colors.green[700]!, '/field-notes'),
          ]),
          SizedBox(height: 24),
          _buildSectionHeader('📊 Analitik & İçgörüler'),
          _buildFeatureGrid(context, [
            _Feature('Ziyaret Isı Haritaları', Icons.thermostat, Colors.red[800]!, '/heatmaps'),
            _Feature('Kullanıcı Davranış Analizi', Icons.insights, Colors.indigo[700]!, '/user-analytics'),
            _Feature('Kişiselleştirilmiş Öneriler', Icons.recommend, Colors.purple[700]!, '/recommendations'),
          ]),
          SizedBox(height: 24),
          _buildSectionHeader('🌟 İleri Seviye Deneyimler'),
          _buildFeatureGrid(context, [
            _Feature('VR Tarihi Deneyimler', Icons.vrpano, Colors.deepPurple[600]!, '/vr-experiences'),
            _Feature('Hologram Projeksiyon', Icons.layers, Colors.cyan[800]!, '/holograms'),
            _Feature('Sesli Rehberler', Icons.spatial_audio, Colors.teal[800]!, '/spatial-audio'),
            _Feature('Zaman Yolculuğu Simülatörü', Icons.av_timer, Colors.amber[800]!, '/time-travel-sim'),
          ]),
          SizedBox(height: 24),
          _buildSectionHeader('🌍 Simülasyon & Laboratuvar'),
          _buildFeatureGrid(context, [
            _Feature('İklim Simülatörü', Icons.cloud, Colors.blue[600]!, '/climate-sim'),
            _Feature('Sanal Laboratuvar', Icons.biotech, Colors.green[800]!, '/virtual-lab'),
            _Feature('Araştırma Projeleri', Icons.search, Colors.purple[800]!, '/research'),
          ]),
          SizedBox(height: 32),
        ],
      ),
          // Competition Banner
          if (_showBanner)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Material(
                elevation: 8,
                color: Colors.green[600],
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const MultiplayerChallengesScreen(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.emoji_events,
                          size: 32,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                '🎉 Antik Yapı Yarışması',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'mücadelesine katıldınız!',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.white.withOpacity(0.9),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'Detay',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12, top: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.purple, Colors.deepPurple],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context, List<_Feature> features) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: features.map((feature) {
        return _buildFeatureCard(context, feature);
      }).toList(),
    );
  }

  Widget _buildFeatureCard(BuildContext context, _Feature feature) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () {
          Widget? screen;
          switch (feature.route) {
            case '/quests':
              screen = const QuestSystemScreen();
              break;
            case '/treasure-hunt':
              screen = const TreasureHuntScreen();
              break;
            case '/leaderboard':
              screen = const LeaderboardScreen();
              break;
            case '/expeditions':
              screen = const SocialToursScreen();
              break;
            case '/friends':
              screen = const FriendsScreen();
              break;
            case '/multiplayer':
              screen = const MultiplayerChallengesScreen();
              break;
            case '/live-events':
              screen = const LiveEventsScreen();
              break;
            case '/ar-multi':
              screen = const ARMultiplayerScreen();
              break;
            case '/mini-games':
              screen = const MiniGamesScreen();
              break;
            case '/badges':
              screen = const AchievementBadgesScreen();
              break;
            case '/3d-creator':
              screen = const ThreeDModelCreatorScreen();
              break;
            case '/map-editor':
              screen = const CustomMapEditorScreen();
              break;
            case '/photo-filters':
              screen = const PhotoFiltersScreen();
              break;
            case '/site-simulator':
              screen = const SiteSimulatorScreen();
              break;
            case '/dating-calculator':
              screen = const DatingCalculatorScreen();
              break;
            case '/restoration-planner':
              screen = const RestorationPlannerScreen();
              break;
            case '/field-notes':
              screen = const FieldNotesScreen();
              break;
            case '/heatmaps':
              screen = const HeatMapScreen();
              break;
            case '/user-analytics':
              screen = const HeatMapScreen();
              break;
            case '/recommendations':
              screen = const PersonalizedRecommendationsScreen();
              break;
            case '/vr-experiences':
              screen = const VRHistoricalExperiencesScreen();
              break;
            case '/holograms':
              screen = const HologramProjectionScreen();
              break;
            case '/spatial-audio':
              screen = const AudioGuides3DScreen();
              break;
            case '/time-travel-sim':
              screen = const TimeTravelSimulatorScreen();
              break;
            case '/climate-sim':
              screen = const ClimateSimulatorScreen();
              break;
            case '/virtual-lab':
              screen = const VirtualLaboratoryScreen();
              break;
            case '/research':
              screen = const ResearchProjectsScreen();
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
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                feature.color.withOpacity(0.9),
                feature.color.withOpacity(0.7),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: feature.color.withOpacity(0.3),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  feature.icon,
                  size: 24,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 6),
              Flexible(
                child: Text(
                  feature.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    height: 1.1,
                    shadows: [
                      Shadow(
                        color: Colors.black38,
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

class _Feature {
  final String title;
  final IconData icon;
  final Color color;
  final String route;

  _Feature(this.title, this.icon, this.color, this.route);
}
