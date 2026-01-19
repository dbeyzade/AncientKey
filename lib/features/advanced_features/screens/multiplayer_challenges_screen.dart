import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'dart:math';

class MultiplayerChallengesScreen extends StatefulWidget {
  const MultiplayerChallengesScreen({super.key});

  @override
  State<MultiplayerChallengesScreen> createState() =>
      _MultiplayerChallengesScreenState();
}

class _MultiplayerChallengesScreenState
    extends State<MultiplayerChallengesScreen> {
  String _selectedTab = 'active';
  final Set<String> _joinedChallenges = {};
  Timer? _timer;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _startParticipantUpdater();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startParticipantUpdater() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted) {
        setState(() {
          // Katılımcı sayılarını rastgele artır
          for (var challenge in _challenges) {
            if (_random.nextDouble() > 0.7) {
              challenge.participants += _random.nextInt(3) + 1;
            }
          }
        });
      }
    });
  }

  final List<Challenge> _challenges = [
    Challenge(
      id: 'challenge_1',
      title: 'Antik Yapı Yarışması',
      description: 'En fazla antik yapıyı keşfet',
      prize: '500 Puan',
      participants: 24,
      timeLeft: '2 saat',
      difficulty: 'Kolay',
      icon: Icons.temple_buddhist,
      color: Colors.green,
    ),
    Challenge(
      id: 'challenge_2',
      title: 'Tarih Bilgini Test Et',
      description: '20 soruya doğru cevap ver',
      prize: '1000 Puan',
      participants: 156,
      timeLeft: '5 saat',
      difficulty: 'Orta',
      icon: Icons.quiz,
      color: Colors.orange,
    ),
    Challenge(
      id: 'challenge_3',
      title: 'Hız Turu',
      description: '10 lokasyonu 30 dakikada ziyaret et',
      prize: '750 Puan',
      participants: 89,
      timeLeft: '1 gün',
      difficulty: 'Zor',
      icon: Icons.speed,
      color: Colors.red,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🏆 Çok Oyunculu Mücadeleler'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[700]!, Colors.amber[500]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildStatsCard(),
                SizedBox(height: 24),
                ..._challenges.map(
                  (challenge) => _buildChallengeCard(challenge),
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
      margin: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(child: _buildTabButton('Aktif', 'active')),
          Expanded(child: _buildTabButton('Geçmiş', 'past')),
          Expanded(child: _buildTabButton('Liderlik', 'leaderboard')),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, String value) {
    final isSelected = _selectedTab == value;
    return GestureDetector(
      onTap: () => setState(() => _selectedTab = value),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.amber : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? Colors.white : Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildStatsCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [Colors.amber[100]!, Colors.amber[50]!],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Kazanılan', '12', Icons.emoji_events),
            _buildStatItem('Aktif', '3', Icons.play_circle),
            _buildStatItem('Sıralama', '#47', Icons.leaderboard),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber[700], size: 32),
        SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.amber[900],
          ),
        ),
        Text(label, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildChallengeCard(Challenge challenge) {
    final isJoined = _joinedChallenges.contains(challenge.id);

    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _showChallengeDetails(challenge),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: challenge.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      challenge.icon,
                      color: challenge.color,
                      size: 32,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          challenge.description,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildInfoChip(
                    Icons.people,
                    '${challenge.participants} kişi',
                    Colors.blue,
                  ),
                  _buildInfoChip(
                    Icons.timer,
                    challenge.timeLeft,
                    Colors.orange,
                  ),
                  _buildInfoChip(Icons.star, challenge.prize, Colors.amber),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: challenge.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      challenge.difficulty,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: challenge.color,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _joinChallenge(challenge),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isJoined ? Colors.green : Colors.amber,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isJoined ? Icons.check_circle : Icons.play_arrow,
                          size: 18,
                        ),
                        SizedBox(width: 4),
                        Text(isJoined ? 'Katıldın' : 'Katıl'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 4),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey[700])),
      ],
    );
  }

  void _showChallengeDetails(Challenge challenge) {
    final isJoined = _joinedChallenges.contains(challenge.id);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) {
          final modalIsJoined = _joinedChallenges.contains(challenge.id);

          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(20),
                    children: [
                      Icon(challenge.icon, size: 64, color: challenge.color),
                      SizedBox(height: 16),
                      Text(
                        challenge.title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        challenge.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                      SizedBox(height: 24),
                      _buildDetailRow(
                        'Ödül',
                        challenge.prize,
                        Icons.emoji_events,
                      ),
                      _buildDetailRow(
                        'Katılımcı',
                        '${challenge.participants} kişi',
                        Icons.people,
                      ),
                      _buildDetailRow(
                        'Kalan Süre',
                        challenge.timeLeft,
                        Icons.timer,
                      ),
                      _buildDetailRow(
                        'Zorluk',
                        challenge.difficulty,
                        Icons.trending_up,
                      ),

                      if (modalIsJoined) ...[
                        SizedBox(height: 24),
                        Container(
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green, width: 2),
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.green,
                                size: 48,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Mücadeleye Katıldınız!',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Diğer oyuncularla yarışıyorsunuz',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              SizedBox(height: 16),
                              _buildLiveLeaderboard(),
                            ],
                          ),
                        ),
                      ],

                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (!modalIsJoined) {
                            _joinChallenge(challenge);
                            setModalState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: modalIsJoined
                              ? Colors.green
                              : Colors.amber,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              modalIsJoined
                                  ? Icons.check_circle
                                  : Icons.play_arrow,
                            ),
                            SizedBox(width: 8),
                            Text(
                              modalIsJoined ? 'Katıldınız' : 'Mücadeleye Katıl',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildLiveLeaderboard() {
    final playerNames = [
      'TarihSever_${_random.nextInt(999)}',
      'AntikKaşif_${_random.nextInt(999)}',
      'GezginOyuncu_${_random.nextInt(999)}',
      'Sen',
      'KeşifciKral_${_random.nextInt(999)}',
    ];

    playerNames.shuffle(_random);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Canlı Sıralama',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12),
        ...playerNames.take(5).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final name = entry.value;
          final score = (100 - index * 10) + _random.nextInt(20);
          final isSelf = name == 'Sen';

          return Container(
            margin: EdgeInsets.only(bottom: 8),
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelf ? Colors.amber.withOpacity(0.2) : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelf ? Colors.amber : Colors.transparent,
                width: 2,
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: index == 0
                        ? Colors.amber
                        : index == 1
                        ? Colors.grey[400]
                        : index == 2
                        ? Colors.brown[300]
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      fontWeight: isSelf ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
                Text(
                  '$score puan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[700],
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Future<void> _joinChallenge(Challenge challenge) async {
    if (_joinedChallenges.contains(challenge.id)) {
      setState(() {
        _joinedChallenges.remove(challenge.id);
        challenge.participants--;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${challenge.title} mücadelesinden ayrıldınız'),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        _joinedChallenges.add(challenge.id);
        challenge.participants++;
      });

      // Save to SharedPreferences if it's the competition challenge
      if (challenge.id == 'challenge_1') {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('joined_competition', true);
        await prefs.setInt(
          'join_timestamp',
          DateTime.now().millisecondsSinceEpoch,
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('🎉 ${challenge.title} mücadelesine katıldınız!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
          action: SnackBarAction(
            label: 'Detay',
            textColor: Colors.white,
            onPressed: () => _showChallengeDetails(challenge),
          ),
        ),
      );
    }
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.amber[700], size: 24),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.amber[900],
            ),
          ),
        ],
      ),
    );
  }
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final String prize;
  int participants;
  final String timeLeft;
  final String difficulty;
  final IconData icon;
  final Color color;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.prize,
    required this.participants,
    required this.timeLeft,
    required this.difficulty,
    required this.icon,
    required this.color,
  });
}
