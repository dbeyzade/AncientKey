import 'package:flutter/material.dart';
import 'dart:math';

class HieroglyphDecoderScreen extends StatefulWidget {
  const HieroglyphDecoderScreen({super.key});

  @override
  State<HieroglyphDecoderScreen> createState() => _HieroglyphDecoderScreenState();
}

class _HieroglyphDecoderScreenState extends State<HieroglyphDecoderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _score = 0;
  int _currentQuestionIndex = 0;
  
  final List<Map<String, dynamic>> _hieroglyphs = [
    {'symbol': '𓀀', 'meaning': 'Adam', 'description': 'Oturan adam figürü'},
    {'symbol': '𓁐', 'meaning': 'Kadın', 'description': 'Oturan kadın figürü'},
    {'symbol': '𓃀', 'meaning': 'Ayak', 'description': 'İnsan ayağı'},
    {'symbol': '𓄿', 'meaning': 'Kol', 'description': 'Uzanmış kol'},
    {'symbol': '𓆓', 'meaning': 'Kalp', 'description': 'İnsan kalbi'},
    {'symbol': '𓂋', 'meaning': 'Ağız', 'description': 'İnsan ağzı'},
    {'symbol': '𓇳', 'meaning': 'Güneş', 'description': 'Ra (Güneş Tanrısı)'},
    {'symbol': '𓏠', 'meaning': 'Ay', 'description': 'Hilal şeklinde ay'},
    {'symbol': '𓈖', 'meaning': 'Su', 'description': 'Dalgalanan su'},
    {'symbol': '𓊪', 'meaning': 'Ev', 'description': 'Basit ev yapısı'},
    {'symbol': '𓉔', 'meaning': 'Tapınak', 'description': 'Sütunlu bina'},
    {'symbol': '𓃭', 'meaning': 'Aslan', 'description': 'Güç ve krallık sembolü'},
    {'symbol': '𓅃', 'meaning': 'Şahin', 'description': 'Horus tanrısı'},
    {'symbol': '𓆑', 'meaning': 'Yılan', 'description': 'Kobra yılanı'},
    {'symbol': '𓆣', 'meaning': 'Kelebek', 'description': 'Dönüşüm sembolü'},
  ];

  final List<Map<String, dynamic>> _cuneiform = [
    {'symbol': '𒀀', 'meaning': 'A', 'description': 'Su veya "a" sesi'},
    {'symbol': '𒁹', 'meaning': '1', 'description': 'Bir sayısı'},
    {'symbol': '𒌋', 'meaning': 'An', 'description': 'Gök tanrısı'},
    {'symbol': '𒀭', 'meaning': 'Tanrı', 'description': 'İlahi varlık işareti'},
    {'symbol': '𒈗', 'meaning': 'Kral', 'description': 'Hükümdar unvanı'},
    {'symbol': '𒆳', 'meaning': 'Dağ', 'description': 'Yüksek yer'},
    {'symbol': '𒌓', 'meaning': 'Güneş', 'description': 'Şamaş tanrısı'},
    {'symbol': '𒄿', 'meaning': 'I', 'description': 'Çivi işareti'},
    {'symbol': '𒌑', 'meaning': 'U', 'description': 'Bitki veya "u" sesi'},
  ];

  List<Map<String, dynamic>> _quizQuestions = [];
  String? _selectedAnswer;
  bool _showResult = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _generateQuiz();
  }

  void _generateQuiz() {
    final random = Random();
    final allSymbols = [..._hieroglyphs, ..._cuneiform]..shuffle(random);
    
    _quizQuestions = allSymbols.take(10).map((correct) {
      final options = [correct['meaning']];
      final otherSymbols = allSymbols.where((s) => s['meaning'] != correct['meaning']).toList()..shuffle(random);
      options.addAll(otherSymbols.take(3).map((s) => s['meaning'] as String));
      options.shuffle(random);
      
      return {
        'symbol': correct['symbol'],
        'correct': correct['meaning'],
        'options': options,
      };
    }).toList();
  }

  void _checkAnswer(String answer) {
    setState(() {
      _selectedAnswer = answer;
      _showResult = true;
      
      if (answer == _quizQuestions[_currentQuestionIndex]['correct']) {
        _score++;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          if (_currentQuestionIndex < _quizQuestions.length - 1) {
            _currentQuestionIndex++;
            _selectedAnswer = null;
            _showResult = false;
          } else {
            _showFinalScore();
          }
        });
      }
    });
  }

  void _showFinalScore() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('🎉 Quiz Tamamlandı!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Skorun: $_score / ${_quizQuestions.length}',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text(_score >= 8 ? '🏆 Mükemmel!' : _score >= 5 ? '👍 İyi!' : '📚 Pratik yap!'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _score = 0;
                _currentQuestionIndex = 0;
                _selectedAnswer = null;
                _showResult = false;
                _generateQuiz();
              });
            },
            child: const Text('Tekrar Dene'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _tabController.animateTo(0);
            },
            child: const Text('Anasayfa'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Antik Yazı Çözücü'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.book), text: 'Hiyeroglif'),
            Tab(icon: Icon(Icons.menu_book), text: 'Çivi Yazısı'),
            Tab(icon: Icon(Icons.quiz), text: 'Quiz'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSymbolList(_hieroglyphs, 'Mısır Hiyeroglifleri'),
          _buildSymbolList(_cuneiform, 'Sümer Çivi Yazısı'),
          _buildQuiz(),
        ],
      ),
    );
  }

  Widget _buildSymbolList(List<Map<String, dynamic>> symbols, String title) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.amber[900]!, Colors.amber[700]!],
            ),
          ),
          child: Text(title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: symbols.length,
            padding: const EdgeInsets.all(8),
            itemBuilder: (context, index) {
              final item = symbols[index];
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: ListTile(
                  leading: Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.amber[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(item['symbol'],
                          style: const TextStyle(fontSize: 36)),
                    ),
                  ),
                  title: Text(item['meaning'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  subtitle: Text(item['description']),
                  trailing: IconButton(
                    icon: const Icon(Icons.volume_up, color: Colors.amber),
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Telaffuz: ${item['meaning']}')),
                      );
                    },
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuiz() {
    if (_quizQuestions.isEmpty) return const Center(child: CircularProgressIndicator());

    final question = _quizQuestions[_currentQuestionIndex];

    return Column(
      children: [
        LinearProgressIndicator(
          value: (_currentQuestionIndex + 1) / _quizQuestions.length,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.amber[700]!),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Soru ${_currentQuestionIndex + 1}/${_quizQuestions.length}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              Text('Skor: $_score', style: TextStyle(fontSize: 16, color: Colors.amber[700], fontWeight: FontWeight.bold)),
            ],
          ),
        ),
        const SizedBox(height: 32),
        Container(
          width: 150,
          height: 150,
          decoration: BoxDecoration(
            color: Colors.amber[50],
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: const Offset(0, 4))],
          ),
          child: Center(
            child: Text(question['symbol'], style: const TextStyle(fontSize: 80)),
          ),
        ),
        const SizedBox(height: 32),
        const Text('Bu sembol ne anlama gelir?',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
        const SizedBox(height: 24),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: (question['options'] as List).length,
            itemBuilder: (context, index) {
              final option = question['options'][index];
              final isSelected = _selectedAnswer == option;
              final isCorrect = option == question['correct'];
              
              Color? backgroundColor;
              if (_showResult && isSelected) {
                backgroundColor = isCorrect ? Colors.green[100] : Colors.red[100];
              } else if (_showResult && isCorrect) {
                backgroundColor = Colors.green[100];
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: backgroundColor ?? Colors.white,
                    padding: const EdgeInsets.all(20),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: isSelected ? 8 : 2,
                  ),
                  onPressed: _showResult ? null : () => _checkAnswer(option),
                  child: Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(String.fromCharCode(65 + index),
                              style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(option, style: const TextStyle(fontSize: 18, color: Colors.black87)),
                      ),
                      if (_showResult && isCorrect)
                        const Icon(Icons.check_circle, color: Colors.green),
                      if (_showResult && isSelected && !isCorrect)
                        const Icon(Icons.cancel, color: Colors.red),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
