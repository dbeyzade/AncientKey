import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/quiz_service.dart';

final quizQuestionsProvider = FutureProvider<List<QuizQuestion>>((ref) async {
  final service = QuizService(ref);
  return await service.getAllQuestions();
});

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  List<QuizQuestion> _allQuestions = [];
  List<QuizQuestion> _selectedQuestions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _timeLeft = 30;
  Timer? _timer;
  bool _quizStarted = false;
  bool _answered = false;
  int? _selectedAnswerIndex;
  String? _selectedCategory;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _currentQuestionIndex = 0;
      _score = 0;

      if (_selectedCategory == null || _selectedCategory == 'Tümü') {
        _selectedQuestions = List.from(_allQuestions)..shuffle();
      } else {
        _selectedQuestions =
            _allQuestions.where((q) => q.category == _selectedCategory).toList()
              ..shuffle();
      }

      _selectedQuestions = _selectedQuestions.take(10).toList();
      _startTimer();
    });
  }

  void _startTimer() {
    _timeLeft = 30;
    _answered = false;
    _selectedAnswerIndex = null;

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() => _timeLeft--);
      } else {
        _timer?.cancel();
        _showTimeUpDialog();
      }
    });
  }

  void _showTimeUpDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Süre Doldu! ⏰'),
        content: const Text('Zamanınız bitti. Bir sonraki soruya geçilecek.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _nextQuestion();
            },
            child: const Text('DEVAM ET'),
          ),
        ],
      ),
    );
  }

  void _checkAnswer(int selectedIndex) {
    if (_answered) return;

    _timer?.cancel();
    setState(() {
      _answered = true;
      _selectedAnswerIndex = selectedIndex;

      if (selectedIndex ==
          _selectedQuestions[_currentQuestionIndex].correctAnswerIndex) {
        _score += 10;
      }
    });

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) _nextQuestion();
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < _selectedQuestions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _startTimer();
      });
    } else {
      _showResultScreen();
    }
  }

  void _showResultScreen() {
    _timer?.cancel();
    final totalPossibleScore = _selectedQuestions.length * 10;
    final percentage = (_score / totalPossibleScore * 100).round();

    // Save result to database and check achievements
    ref
        .read(quizServiceProvider)
        .saveQuizResult(_score, _selectedQuestions.length);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                percentage >= 70
                    ? Icons.emoji_events
                    : percentage >= 50
                    ? Icons.thumb_up
                    : Icons.sentiment_neutral,
                size: 80,
                color: percentage >= 70
                    ? Colors.amber
                    : percentage >= 50
                    ? Colors.blue
                    : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                percentage >= 70
                    ? 'Harika! 🎉'
                    : percentage >= 50
                    ? 'İyi! 👍'
                    : 'Çalış! 📚',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Skorunuz: $_score / $totalPossibleScore',
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                'Başarı: %$percentage',
                style: TextStyle(fontSize: 18, color: Colors.grey[600]),
              ),

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      _quizStarted = false;
                      _selectedCategory = null;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: const Text(
                    'YENİDEN BAŞLA',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final questionsAsync = ref.watch(quizQuestionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Tarih Bilgi Yarışması'), elevation: 2),
      body: questionsAsync.when(
        data: (questions) {
          _allQuestions = questions;

          if (!_quizStarted) {
            return _buildCategorySelection();
          }

          if (_selectedQuestions.isEmpty) {
            return const Center(child: Text('Soru bulunamadı'));
          }

          return _buildQuizContent();
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }

  Widget _buildCategorySelection() {
    final categories = [
      'Tümü',
      'Antik Yunan',
      'Antik Roma',
      'Antik Mısır',
      'Mezopotamya',
      'Genel Tarih',
    ];

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.quiz, size: 80, color: Colors.green),
          const SizedBox(height: 24),
          const Text(
            'Tarih Bilgi Yarışması',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            '10 soru • 30 saniye/soru',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
          const SizedBox(height: 40),
          const Text(
            'Kategori Seç:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = _selectedCategory == category;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: isSelected ? 4 : 1,
                  color: isSelected ? Colors.green[50] : null,
                  child: ListTile(
                    leading: Icon(
                      Icons.category,
                      color: isSelected ? Colors.green[700] : Colors.grey,
                    ),
                    title: Text(
                      category,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected ? Colors.green[700] : null,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
                    onTap: () => setState(() => _selectedCategory = category),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _selectedCategory != null ? _startQuiz : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                disabledBackgroundColor: Colors.grey[300],
              ),
              child: const Text(
                'BAŞLA',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizContent() {
    final question = _selectedQuestions[_currentQuestionIndex];
    final progress = (_currentQuestionIndex + 1) / _selectedQuestions.length;

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.green[700],
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Soru ${_currentQuestionIndex + 1}/${_selectedQuestions.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _timeLeft > 10 ? Colors.white : Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 18,
                          color: _timeLeft > 10
                              ? Colors.green[700]
                              : Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '$_timeLeft s',
                          style: TextStyle(
                            color: _timeLeft > 10
                                ? Colors.green[700]
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.white.withOpacity(0.3),
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.category, size: 20, color: Colors.green[700]),
                      const SizedBox(width: 8),
                      Text(
                        question.category,
                        style: TextStyle(
                          color: Colors.green[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  question.question,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 32),
                ...List.generate(question.options.length, (index) {
                  final isCorrect = index == question.correctAnswerIndex;
                  final isSelected = index == _selectedAnswerIndex;

                  Color? backgroundColor;
                  Color? borderColor;
                  IconData? icon;

                  if (_answered) {
                    if (isCorrect) {
                      backgroundColor = Colors.green[50];
                      borderColor = Colors.green;
                      icon = Icons.check_circle;
                    } else if (isSelected) {
                      backgroundColor = Colors.red[50];
                      borderColor = Colors.red;
                      icon = Icons.cancel;
                    }
                  } else if (isSelected) {
                    backgroundColor = Colors.blue[50];
                    borderColor = Colors.blue;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Material(
                      color: backgroundColor ?? Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      child: InkWell(
                        onTap: () => _checkAnswer(index),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: borderColor ?? Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  question.options[index],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight:
                                        isSelected || (_answered && isCorrect)
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (icon != null)
                                Icon(
                                  icon,
                                  color: isCorrect ? Colors.green : Colors.red,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                if (_answered) ...[
                  const SizedBox(height: 24),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.lightbulb, color: Colors.blue[700]),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            question.explanation,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.blue[900],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
