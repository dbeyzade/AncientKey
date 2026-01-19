import 'package:flutter/material.dart';

class ARMultiplayerScreen extends StatelessWidget {
  const ARMultiplayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final sessions = [
      ARSession(
        title: 'Efes AR Keşfi',
        host: 'Ahmet Y.',
        players: 3,
        maxPlayers: 4,
        location: 'Efes Antik Kenti',
        difficulty: 'Kolay',
        icon: '🏛️',
        color: Colors.purple,
      ),
      ARSession(
        title: 'Truva Hazine Avı',
        host: 'Zeynep K.',
        players: 2,
        maxPlayers: 6,
        location: 'Truva Ören Yeri',
        difficulty: 'Orta',
        icon: '🏺',
        color: Colors.orange,
      ),
      ARSession(
        title: 'Hitit Tapınak Yarışı',
        host: 'Mehmet D.',
        players: 4,
        maxPlayers: 4,
        location: 'Hattuşa',
        difficulty: 'Zor',
        icon: '🗿',
        color: Colors.red,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('🎮 AR Multiplayer'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple[600]!, Colors.deepPurple[400]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Container(
              padding: EdgeInsets.all(24),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [Colors.deepPurple[100]!, Colors.deepPurple[50]!],
                ),
              ),
              child: Column(
                children: [
                  Icon(Icons.view_in_ar, size: 64, color: Colors.deepPurple[700]),
                  SizedBox(height: 16),
                  Text(
                    'Artırılmış Gerçeklik ile Oyna',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[900],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Arkadaşlarınla AR dünyasında tarihi keşfet',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.deepPurple[700]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Aktif Oturumlar',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              TextButton.icon(
                onPressed: () => _showCreateSessionDialog(context),
                icon: Icon(Icons.add_circle),
                label: Text('Yeni Oturum'),
              ),
            ],
          ),
          SizedBox(height: 12),
          ...sessions.map((session) => _buildSessionCard(context, session)),
        ],
      ),
    );
  }

  Widget _buildSessionCard(BuildContext context, ARSession session) {
    final isFull = session.players >= session.maxPlayers;
    
    return Card(
      elevation: 4,
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: isFull ? null : () => _showSessionDetails(context, session),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isFull ? Border.all(color: Colors.grey[300]!) : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [session.color.withOpacity(0.3), session.color.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Center(
                      child: Text(session.icon, style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          session.title,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isFull ? Colors.grey : Colors.black87,
                          ),
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(Icons.person, size: 14, color: Colors.grey[600]),
                            SizedBox(width: 4),
                            Text(
                              session.host,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isFull)
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'DOLU',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 4),
                  Text(
                    session.location,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.people, size: 20, color: session.color),
                      SizedBox(width: 6),
                      Text(
                        '${session.players}/${session.maxPlayers} Oyuncu',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: session.color,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: session.color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      session.difficulty,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: session.color,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              LinearProgressIndicator(
                value: session.players / session.maxPlayers,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(session.color),
                minHeight: 6,
                borderRadius: BorderRadius.circular(3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSessionDetails(BuildContext context, ARSession session) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
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
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [session.color.withOpacity(0.3), session.color.withOpacity(0.1)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Text(session.icon, style: TextStyle(fontSize: 48)),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    session.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Oturum Sahibi: ${session.host}',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 24),
                  _buildDetailRow(Icons.location_on, 'Lokasyon', session.location),
                  _buildDetailRow(Icons.people, 'Oyuncular', '${session.players}/${session.maxPlayers}'),
                  _buildDetailRow(Icons.trending_up, 'Zorluk', session.difficulty),
                  SizedBox(height: 24),
                  Text(
                    'Oturum Bilgileri',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '• AR cihazınızı hazır bulundurun\n'
                    '• GPS ve kamera izinleri gereklidir\n'
                    '• Minimum 10m açık alan gerekir\n'
                    '• Tüm oyuncular aynı lokasyonda olmalı',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ARSessionPlayScreen(session: session),
                        ),
                      );
                    },
                    icon: Icon(Icons.login),
                    label: Text('Oturuma Katıl'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: session.color,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateSessionDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Yeni AR Oturumu'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.view_in_ar, size: 64, color: Colors.deepPurple),
            SizedBox(height: 16),
            Text(
              'AR oturumu oluşturmak için lokasyona gitmeniz gerekiyor.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Lokasyonları Gör'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple[700], size: 24),
          SizedBox(width: 12),
          Text(
            '$label:',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[900],
            ),
          ),
        ],
      ),
    );
  }
}

class ARSession {
  final String title;
  final String host;
  final int players;
  final int maxPlayers;
  final String location;
  final String difficulty;
  final String icon;
  final Color color;

  ARSession({
    required this.title,
    required this.host,
    required this.players,
    required this.maxPlayers,
    required this.location,
    required this.difficulty,
    required this.icon,
    required this.color,
  });
}

class ARSessionPlayScreen extends StatefulWidget {
  final ARSession session;

  const ARSessionPlayScreen({super.key, required this.session});

  @override
  State<ARSessionPlayScreen> createState() => _ARSessionPlayScreenState();
}

class _ARSessionPlayScreenState extends State<ARSessionPlayScreen> {
  late int playerCount;
  bool arEnabled = false;
  List<String> playerScores = [];
  bool gpsConnected = false;
  bool cameraReady = false;

  @override
  void initState() {
    super.initState();
    playerCount = widget.session.players;
    playerScores = List.filled(widget.session.maxPlayers, '0');
    _simulateARSetup();
  }

  void _simulateARSetup() {
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => gpsConnected = true);
      }
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => cameraReady = true);
      }
    });
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() => arEnabled = true);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🎮 ${widget.session.title}'),
        backgroundColor: widget.session.color,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: !arEnabled
          ? _buildLoadingView()
          : Column(
              children: [
                // AR View Area
                Expanded(
                  flex: 3,
                  child: Container(
                    color: Colors.black,
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                widget.session.icon,
                                style: const TextStyle(fontSize: 120),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'AR Görünümü Canlı',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Top HUD
                        Positioned(
                          top: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      widget.session.location,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black54,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.people,
                                      color: Colors.blue,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$playerCount/${widget.session.maxPlayers}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Bottom Controls
                        Positioned(
                          bottom: 16,
                          left: 16,
                          right: 16,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blue.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.blue,
                                  elevation: 8,
                                  onPressed: () {
                                    if (mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('📸 Fotoğraf çekildi!'),
                                          backgroundColor: Colors.blue,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.camera_alt, size: 24),
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                child: FloatingActionButton(
                                  mini: true,
                                  backgroundColor: Colors.green,
                                  elevation: 8,
                                  onPressed: () {
                                    if (mounted) {
                                      setState(() {
                                        try {
                                          int currentScore = int.parse(playerScores[0]);
                                          playerScores[0] = (currentScore + 10).toString();
                                        } catch (e) {
                                          playerScores[0] = '10';
                                        }
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('✅ 10 Puan kazandınız!'),
                                          backgroundColor: Colors.green,
                                          duration: Duration(seconds: 2),
                                        ),
                                      );
                                    }
                                  },
                                  child: const Icon(Icons.add, size: 24),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Stats Panel
                Expanded(
                  child: Container(
                    color: Colors.grey[100],
                    padding: const EdgeInsets.all(16),
                    child: ListView(
                      children: [
                        const Text(
                          'Oyuncu Puanları',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 12),
                        ..._buildPlayerScores(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildLoadingView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 20),
        const Text(
          'AR Oturumu Başlatılıyor',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 32),
        _buildStatusItem(
          'GPS Bağlantısı',
          gpsConnected,
          Icons.location_on,
        ),
        const SizedBox(height: 16),
        _buildStatusItem(
          'Kamera Hazırlama',
          cameraReady,
          Icons.camera_alt,
        ),
        const SizedBox(height: 16),
        _buildStatusItem(
          'AR Kurulumu',
          arEnabled,
          Icons.view_in_ar,
        ),
        const SizedBox(height: 32),
        SizedBox(
          width: 200,
          child: LinearProgressIndicator(
            value: (gpsConnected ? 0.33 : 0) +
                (cameraReady ? 0.33 : 0) +
                (arEnabled ? 0.34 : 0),
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildStatusItem(String label, bool isReady, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isReady ? Colors.green[50] : Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isReady ? Colors.green[300]! : Colors.grey[300]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            isReady ? Icons.check_circle : Icons.hourglass_empty,
            color: isReady ? Colors.green : Colors.grey,
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: isReady ? Colors.green[800] : Colors.grey[600],
              ),
            ),
          ),
          if (isReady)
            const Icon(Icons.done, color: Colors.green, size: 20),
        ],
      ),
    );
  }

  List<Widget> _buildPlayerScores() {
    return [
      _buildScoreRow('Siziz', playerScores[0], Colors.blue, true),
      const SizedBox(height: 8),
      if (widget.session.players >= 2)
        _buildScoreRow(
          widget.session.host,
          '${(int.parse(playerScores[0]) - 5).clamp(0, 999)}',
          Colors.orange,
          false,
        ),
      if (widget.session.players >= 3)
        const SizedBox(height: 8),
      if (widget.session.players >= 3)
        _buildScoreRow(
          'Oyuncu 3',
          '${(int.parse(playerScores[0]) - 10).clamp(0, 999)}',
          Colors.purple,
          false,
        ),
      if (widget.session.players >= 4)
        const SizedBox(height: 8),
      if (widget.session.players >= 4)
        _buildScoreRow(
          'Oyuncu 4',
          '${(int.parse(playerScores[0]) - 15).clamp(0, 999)}',
          Colors.teal,
          false,
        ),
    ];
  }

  Widget _buildScoreRow(
    String playerName,
    String score,
    Color color,
    bool isYou,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isYou ? color : Colors.grey[200]!,
          width: isYou ? 2 : 1,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 16,
            child: Text(
              playerName[0],
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isYou ? '$playerName (Siz)' : playerName,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isYou ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
          Text(
            score,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
