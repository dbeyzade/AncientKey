import 'package:flutter/material.dart';

class MiniGamesScreen extends StatelessWidget {
  const MiniGamesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🎮 Mini Oyunlar'),
        elevation: 2,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightBlue, Colors.blue[700]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: const EdgeInsets.all(16),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        children: [
          _buildGameCard(
            context,
            '🧩 Antik Bulmaca',
            'Tarihi eserleri doğru sıraya koy',
            Colors.purple,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AncientPuzzleGame()),
            ),
          ),
          _buildGameCard(
            context,
            '🎯 Tarih Quiz',
            'Bilgini test et, puan kazan',
            Colors.orange,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const HistoryQuizGame()),
            ),
          ),
          _buildGameCard(
            context,
            '🗺️ Harita Eşleştir',
            'Şehirleri haritada bul',
            Colors.green,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const MapMatchGame()),
            ),
          ),
          _buildGameCard(
            context,
            '⏱️ Zaman Yarışı',
            'Olayları kronolojik sırala',
            Colors.red,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const TimeRaceGame()),
            ),
          ),
          _buildGameCard(
            context,
            '🏛️ Yapı Tanıma',
            'Tarihi yapıları tanı',
            Colors.teal,
            () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const BuildingRecognitionGame(),
              ),
            ),
          ),
          _buildGameCard(
            context,
            '📜 Kelime Avı',
            'Tarihi terimleri bul',
            Colors.indigo,
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const WordHuntGame()),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameCard(
    BuildContext context,
    String title,
    String description,
    Color color,
    VoidCallback onTap,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [color.withValues(alpha: 0.8), color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withValues(alpha: 0.9),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Antik Bulmaca Oyunu
class AncientPuzzleGame extends StatefulWidget {
  const AncientPuzzleGame({super.key});

  @override
  State<AncientPuzzleGame> createState() => _AncientPuzzleGameState();
}

class _AncientPuzzleGameState extends State<AncientPuzzleGame> {
  final List<String> pieces = ['🏛️', '🗿', '⚱️', '🏺', '📜', '⚔️', '👑', '💎'];
  List<String> shuffled = [];
  List<String> placed = [];
  int score = 0;
  int moves = 0;

  @override
  void initState() {
    super.initState();
    shuffled = List.from(pieces)..shuffle();
    placed = List.filled(pieces.length, '');
  }

  void _onPieceTap(int index) {
    setState(() {
      if (placed[index].isEmpty) {
        placed[index] = shuffled.removeAt(0);
        moves++;
        if (shuffled.isEmpty) {
          _checkWin();
        }
      }
    });
  }

  void _checkWin() {
    bool isCorrect = true;
    for (int i = 0; i < pieces.length; i++) {
      if (placed[i] != pieces[i]) {
        isCorrect = false;
        break;
      }
    }
    if (isCorrect) {
      score = 1000 - (moves * 10);
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Tebrikler!'),
        content: Text(
          'Bulmacayı $moves hamlede tamamladınız!\nPuanınız: $score',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                shuffled = List.from(pieces)..shuffle();
                placed = List.filled(pieces.length, '');
                moves = 0;
              });
            },
            child: const Text('Yeniden Oyna'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🧩 Antik Bulmaca'),
        backgroundColor: Colors.purple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Hamle: $moves', style: const TextStyle(fontSize: 16)),
                    Text('Puan: $score', style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Parçaları doğru sıraya yerleştirin:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: shuffled
                  .map(
                    (piece) => Chip(
                      label: Text(piece, style: const TextStyle(fontSize: 24)),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: pieces.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () => shuffled.isNotEmpty && placed[index].isEmpty
                        ? _onPieceTap(index)
                        : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: placed[index].isEmpty
                            ? Colors.grey[300]
                            : Colors.purple[100],
                        border: Border.all(
                          color: placed[index] == pieces[index]
                              ? Colors.green
                              : Colors.purple,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          placed[index],
                          style: const TextStyle(fontSize: 32),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Tarih Quiz Oyunu
class HistoryQuizGame extends StatefulWidget {
  const HistoryQuizGame({super.key});

  @override
  State<HistoryQuizGame> createState() => _HistoryQuizGameState();
}

class _HistoryQuizGameState extends State<HistoryQuizGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  final List<Map<String, dynamic>> questions = [
    {
      'question': 'Efes antik kenti hangi medeniyete aittir?',
      'options': ['Roma', 'Yunan', 'Hitit', 'Sümer'],
      'correct': 1,
    },
    {
      'question': 'Truva savaşı yaklaşık kaç yıl önce gerçekleşti?',
      'options': ['1000', '2000', '3000', '4000'],
      'correct': 2,
    },
    {
      'question': 'Göbekli Tepe hangi şehirde bulunur?',
      'options': ['Konya', 'Şanlıurfa', 'Mardin', 'Diyarbakır'],
      'correct': 1,
    },
  ];

  int currentQuestion = 0;
  int score = 0;
  bool answered = false;
  int? selectedAnswer;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectAnswer(int index) {
    if (answered) return;

    setState(() {
      selectedAnswer = index;
      answered = true;
      if (index == questions[currentQuestion]['correct']) {
        score += 100;
      }
    });

    // Yanıp sönerek göster
    _animationController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _animationController.stop();
        _animationController.reset();

        if (currentQuestion < questions.length - 1) {
          setState(() {
            currentQuestion++;
            answered = false;
            selectedAnswer = null;
          });
        } else {
          _showResultDialog();
        }
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Quiz Tamamlandı!'),
        content: Text(
          'Toplam Puanınız: $score\n'
          'Doğru: ${score ~/ 100}/${questions.length}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                currentQuestion = 0;
                score = 0;
                answered = false;
                selectedAnswer = null;
              });
            },
            child: const Text('Tekrar Oyna'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Çık'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🎯 Tarih Quiz'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soru ${currentQuestion + 1}/${questions.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Puan: $score',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...(question['options'] as List<String>).asMap().entries.map((
              entry,
            ) {
              final index = entry.key;
              final option = entry.value;
              final isCorrect = index == question['correct'];
              final isSelected = index == selectedAnswer;

              Color? backgroundColor;
              if (answered) {
                if (isSelected) {
                  backgroundColor = isCorrect ? Colors.green : Colors.red;
                } else if (isCorrect) {
                  backgroundColor = Colors.green;
                }
              }

              // Yanıp sönerek göster - seçilen cevapa animasyon uygula
              if (isSelected && answered) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor ?? Colors.orange[100],
                        padding: const EdgeInsets.all(16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: answered ? null : () => _selectAnswer(index),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor ?? Colors.orange[100],
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    option,
                    style: TextStyle(
                      fontSize: 16,
                      color: answered ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Harita Eşleştirme Oyunu
class MapMatchGame extends StatefulWidget {
  const MapMatchGame({super.key});

  @override
  State<MapMatchGame> createState() => _MapMatchGameState();
}

class _MapMatchGameState extends State<MapMatchGame>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;

  final List<Map<String, String>> cities = [
    {'name': 'Efes', 'region': 'İzmir'},
    {'name': 'Truva', 'region': 'Çanakkale'},
    {'name': 'Göbekli Tepe', 'region': 'Şanlıurfa'},
  ];

  int currentCity = 0;
  int score = 0;
  String? selectedRegion;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectRegion(String region) {
    if (answered) return;

    final isCorrect = region == cities[currentCity]['region'];

    setState(() {
      selectedRegion = region;
      answered = true;
      if (isCorrect) {
        score += 50;
      }
    });

    // Yanıp sönerek göster
    _animationController.repeat(reverse: true);

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _animationController.stop();
        _animationController.reset();

        if (currentCity < cities.length - 1) {
          setState(() {
            currentCity++;
            selectedRegion = null;
            answered = false;
          });
        } else {
          _showResultDialog();
        }
      }
    });
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Oyun Bitti!'),
        content: Text('Toplam Puanınız: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final city = cities[currentCity];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🗺️ Harita Eşleştir'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Soru ${currentCity + 1}/${cities.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Puan: $score',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(
              '${city['name']} hangi bölgededir?',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ...['İzmir', 'Çanakkale', 'Şanlıurfa', 'Konya'].map((region) {
              final isCorrect = region == city['region'];
              final isSelected = region == selectedRegion;

              Color? backgroundColor;
              if (answered) {
                if (isSelected) {
                  backgroundColor = isCorrect ? Colors.green : Colors.red;
                } else if (isCorrect) {
                  backgroundColor = Colors.green;
                }
              }

              // Yanıp sönerek göster - seçilen seçeneğe animasyon uygula
              if (isSelected && answered) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: FadeTransition(
                    opacity: _opacityAnimation,
                    child: ElevatedButton(
                      onPressed: null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: backgroundColor ?? Colors.green[100],
                        padding: const EdgeInsets.all(16),
                        minimumSize: const Size(double.infinity, 60),
                      ),
                      child: Text(
                        region,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  onPressed: answered ? null : () => _selectRegion(region),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor ?? Colors.green[100],
                    padding: const EdgeInsets.all(16),
                    minimumSize: const Size(double.infinity, 60),
                  ),
                  child: Text(
                    region,
                    style: TextStyle(
                      fontSize: 18,
                      color: answered ? Colors.white : Colors.black,
                      fontWeight: answered
                          ? FontWeight.bold
                          : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

// Zaman Yarışı Oyunu
class TimeRaceGame extends StatefulWidget {
  const TimeRaceGame({super.key});

  @override
  State<TimeRaceGame> createState() => _TimeRaceGameState();
}

class _TimeRaceGameState extends State<TimeRaceGame> {
  final List<Map<String, dynamic>> events = [
    {'event': '🏛️ Eski Mısır Medeniyeti', 'year': -3000},
    {'event': '⚔️ Troia Savaşı', 'year': -1194},
    {'event': '🗿 Roma İmparatorluğu Kurulması', 'year': -27},
    {'event': '📚 İslam Medeniyetinin Çıkışı', 'year': 622},
    {'event': '🏰 Orta Çağ Başlangıcı', 'year': 500},
  ];

  late List<Map<String, dynamic>> shuffledEvents;
  int score = 0;
  int currentIndex = 0;
  bool gameOver = false;

  @override
  void initState() {
    super.initState();
    shuffledEvents = List.from(events)..shuffle();
  }

  void _onOrderSelected(int selectedIndex) {
    final correct = currentIndex == 0
        ? shuffledEvents[selectedIndex]['year'] == events[0]['year']
        : shuffledEvents[selectedIndex]['year'] >
              shuffledEvents[currentIndex - 1]['year'];

    if (correct) {
      score += 50;
      if (currentIndex < shuffledEvents.length - 1) {
        setState(() => currentIndex++);
      } else {
        setState(() => gameOver = true);
        _showResultDialog();
      }
    } else {
      _showWrongDialog();
    }
  }

  void _showWrongDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('❌ Yanlış!'),
        content: const Text('Olayları doğru kronolojik sıraya koyunuz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tamam'),
          ),
        ],
      ),
    );
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Tamamlandı!'),
        content: Text('Toplam Puanınız: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                shuffledEvents = List.from(events)..shuffle();
                score = 0;
                currentIndex = 0;
                gameOver = false;
              });
            },
            child: const Text('Tekrar Oyna'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Çık'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⏱️ Zaman Yarışı'),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Puan: $score',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Olayları kronolojik sıraya koyun:',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: shuffledEvents.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () => _onOrderSelected(index),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        '${shuffledEvents[index]['event']} (${shuffledEvents[index]['year']})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BuildingRecognitionGame extends StatefulWidget {
  const BuildingRecognitionGame({super.key});

  @override
  State<BuildingRecognitionGame> createState() =>
      _BuildingRecognitionGameState();
}

class _BuildingRecognitionGameState extends State<BuildingRecognitionGame> {
  final List<Map<String, dynamic>> buildings = [
    {
      'name': 'Kızıl Kule',
      'emoji': '🏰',
      'options': ['Kızıl Kule', 'Galata Kulesi', 'İçkale'],
    },
    {
      'name': 'Topkapı Sarayı',
      'emoji': '🏛️',
      'options': ['Topkapı Sarayı', 'Dolmabahçe', 'Yıldız Sarayı'],
    },
    {
      'name': 'Ayasofya',
      'emoji': '⛪',
      'options': ['Ayasofya', 'Sultanahmet Camii', 'Süleymaniye Camii'],
    },
    {
      'name': 'Koloseum',
      'emoji': '🏟️',
      'options': ['Koloseum', 'Pantheon', 'Romalı Forum'],
    },
    {
      'name': 'Parthenon',
      'emoji': '🏛️',
      'options': ['Parthenon', 'Erechteion', 'Stadyum'],
    },
  ];

  late List<Map<String, dynamic>> shuffledBuildings;
  int score = 0;
  int currentIndex = 0;
  bool answered = false;

  @override
  void initState() {
    super.initState();
    shuffledBuildings = List.from(buildings)..shuffle();
  }

  void _selectAnswer(String answer) {
    if (answered) return;

    setState(() => answered = true);

    if (answer == shuffledBuildings[currentIndex]['name']) {
      score += 100;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('✅ Doğru!'),
          content: const Text('Harika! Devam et.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (currentIndex < shuffledBuildings.length - 1) {
                  setState(() {
                    currentIndex++;
                    answered = false;
                  });
                } else {
                  _showResultDialog();
                }
              },
              child: const Text('Devam'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('❌ Yanlış!'),
          content: Text(
            'Doğru cevap: ${shuffledBuildings[currentIndex]['name']}',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                if (currentIndex < shuffledBuildings.length - 1) {
                  setState(() {
                    currentIndex++;
                    answered = false;
                  });
                } else {
                  _showResultDialog();
                }
              },
              child: const Text('Devam'),
            ),
          ],
        ),
      );
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Oyun Bitti!'),
        content: Text(
          'Toplam Puanınız: $score\n'
          'Doğru: ${score ~/ 100}/${shuffledBuildings.length}',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                shuffledBuildings = List.from(buildings)..shuffle();
                score = 0;
                currentIndex = 0;
                answered = false;
              });
            },
            child: const Text('Tekrar Oyna'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Çık'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final building = shuffledBuildings[currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Yapı Tanıma'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Puan: $score', style: const TextStyle(fontSize: 16)),
                    Text(
                      '${currentIndex + 1}/${shuffledBuildings.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text(building['emoji'], style: const TextStyle(fontSize: 72)),
            const SizedBox(height: 32),
            const Text(
              'Bu yapı hangisidir?',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: building['options'].length,
                itemBuilder: (context, index) {
                  final option = building['options'][index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: ElevatedButton(
                      onPressed: () => _selectAnswer(option),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal,
                        padding: const EdgeInsets.all(16),
                      ),
                      child: Text(
                        option,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WordHuntGame extends StatefulWidget {
  const WordHuntGame({super.key});

  @override
  State<WordHuntGame> createState() => _WordHuntGameState();
}

class _WordHuntGameState extends State<WordHuntGame> {
  final List<String> words = [
    'MEDENIYYET',
    'ARKEOLOJI',
    'TARIH',
    'HANEDANLIK',
    'IMPARATORLUK',
  ];

  final String grid = '''
    M E D E N I Y Y E T
    A R K E O L O J I T
    T A R I H L E M E T
    H A N E D A N L I K
    I M P A R A T O R L
    U K L A K A P I T A
    K B Y X Z W Q S T U
    M O D E S T Y L O P
    N I M E T S Y R E K
    A R A P S E N T E T
  ''';

  late List<String> foundWords;
  int score = 0;
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    foundWords = [];
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _checkWord() {
    final input = _controller.text.toUpperCase().trim();
    if (words.contains(input) && !foundWords.contains(input)) {
      setState(() {
        foundWords.add(input);
        score += 50;
      });
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Doğru! Kelimeyi buldunuz.'),
          duration: Duration(seconds: 1),
        ),
      );
    } else if (foundWords.contains(input)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚠️ Bu kelimeyi zaten buldunuz.'),
          duration: Duration(seconds: 1),
        ),
      );
      _controller.clear();
    } else {
      _controller.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('❌ Bu kelime bulunmuyor.'),
          duration: Duration(seconds: 1),
        ),
      );
    }

    if (foundWords.length == words.length) {
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Tamamladınız!'),
        content: Text('Toplam Puanınız: $score'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                foundWords = [];
                score = 0;
              });
            },
            child: const Text('Tekrar Oyna'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Çık'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📜 Kelime Avı'),
        backgroundColor: Colors.indigo,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text('Puan: $score', style: const TextStyle(fontSize: 16)),
                    Text(
                      'Bulunan: ${foundWords.length}/${words.length}',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.indigo),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  grid,
                  style: const TextStyle(
                    fontFamily: 'Courier',
                    fontSize: 12,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Kelime yazın...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onSubmitted: (_) => _checkWord(),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: _checkWord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text(
                'Kontrol Et',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Aranacak Kelimeler:',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: words.map((word) {
                return Chip(
                  label: Text(
                    word,
                    style: TextStyle(
                      color: foundWords.contains(word)
                          ? Colors.white
                          : Colors.grey[700],
                      decoration: foundWords.contains(word)
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  backgroundColor: foundWords.contains(word)
                      ? Colors.green
                      : Colors.grey[300],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
