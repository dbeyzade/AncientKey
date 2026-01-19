import 'package:flutter/material.dart';
import 'dart:math';

class PotteryRestoreGameScreen extends StatefulWidget {
  const PotteryRestoreGameScreen({super.key});

  @override
  State<PotteryRestoreGameScreen> createState() => _PotteryRestoreGameScreenState();
}

class _PotteryRestoreGameScreenState extends State<PotteryRestoreGameScreen> with TickerProviderStateMixin {
  int _currentLevel = 1;
  int _score = 0;
  int _moves = 0;
  bool _isCompleted = false;
  
  late List<int> _pieces;
  late List<int> _targetOrder;
  int? _selectedIndex;
  
  late AnimationController _shakeController;
  late AnimationController _completeController;

  final List<Map<String, dynamic>> _levels = [
    {'name': 'Basit Kase', 'pieces': 4, 'icon': '🏺', 'color': Colors.brown},
    {'name': 'Antik Vazo', 'pieces': 6, 'icon': '🏺', 'color': Colors.deepOrange},
    {'name': 'Küp', 'pieces': 8, 'icon': '🏺', 'color': Colors.amber},
    {'name': 'Seramik Tabak', 'pieces': 9, 'icon': '🍽️', 'color': Colors.red},
    {'name': 'Süslü Amfora', 'pieces': 12, 'icon': '🏺', 'color': Colors.orange},
  ];

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _completeController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _initializeLevel();
  }

  void _initializeLevel() {
    final pieceCount = _levels[_currentLevel - 1]['pieces'] as int;
    _targetOrder = List.generate(pieceCount, (index) => index);
    _pieces = List.from(_targetOrder)..shuffle(Random());
    _selectedIndex = null;
    _isCompleted = false;
    _moves = 0;
  }

  void _onPieceTap(int index) {
    if (_isCompleted) return;

    setState(() {
      if (_selectedIndex == null) {
        _selectedIndex = index;
      } else {
        if (_selectedIndex != index) {
          // Swap pieces
          final temp = _pieces[_selectedIndex!];
          _pieces[_selectedIndex!] = _pieces[index];
          _pieces[index] = temp;
          _moves++;

          // Check if completed
          if (_checkComplete()) {
            _isCompleted = true;
            _score += (100 - _moves * 2).clamp(10, 100);
            _completeController.forward(from: 0);
            Future.delayed(const Duration(milliseconds: 500), () {
              _showCompletionDialog();
            });
          }
        }
        _selectedIndex = null;
      }
    });
  }

  bool _checkComplete() {
    for (int i = 0; i < _pieces.length; i++) {
      if (_pieces[i] != i) return false;
    }
    return true;
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.celebration, color: Colors.amber, size: 32),
            SizedBox(width: 8),
            Text('Tebrikler!'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${_levels[_currentLevel - 1]['name']} restore edildi!',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Text('Hamle: $_moves',
                style: const TextStyle(fontSize: 16)),
            Text('Kazanılan Puan: ${(100 - _moves * 2).clamp(10, 100)}',
                style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            Text('Toplam Skor: $_score',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber[700])),
          ],
        ),
        actions: [
          if (_currentLevel < _levels.length)
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                setState(() {
                  _currentLevel++;
                  _initializeLevel();
                });
              },
              child: const Text('Sonraki Level'),
            ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() {
                _initializeLevel();
              });
            },
            child: const Text('Tekrar Dene'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('Bitir'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final level = _levels[_currentLevel - 1];
    final gridSize = sqrt(level['pieces'] as int).ceil();

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏺 Seramik Restore'),
        backgroundColor: level['color'] as Color,
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Text('Skor: $_score',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: (level['color'] as Color).withOpacity(0.1),
            child: Column(
              children: [
                Text('Level $_currentLevel: ${level['name']}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('Hamle: $_moves',
                    style: const TextStyle(fontSize: 16, color: Colors.black54)),
                const SizedBox(height: 4),
                const Text('Parçaları doğru sıraya koy!',
                    style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic)),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: _pieces.length,
                    itemBuilder: (context, index) {
                      final pieceNumber = _pieces[index];
                      final isSelected = _selectedIndex == index;
                      final isCorrect = pieceNumber == index;

                      return GestureDetector(
                        onTap: () => _onPieceTap(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: isSelected
                                  ? [Colors.blue[400]!, Colors.blue[700]!]
                                  : isCorrect && _isCompleted
                                      ? [Colors.green[400]!, Colors.green[700]!]
                                      : [(level['color'] as Color).withOpacity(0.7), level['color'] as Color],
                            ),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? Colors.white : Colors.black26,
                              width: isSelected ? 3 : 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: isSelected
                                    ? Colors.blue.withOpacity(0.5)
                                    : Colors.black26,
                                blurRadius: isSelected ? 12 : 4,
                                offset: Offset(0, isSelected ? 6 : 2),
                              ),
                            ],
                          ),
                          child: Stack(
                            children: [
                              Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(level['icon'] as String,
                                        style: const TextStyle(fontSize: 32)),
                                    const SizedBox(height: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.9),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text('${pieceNumber + 1}',
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                              if (isCorrect && _isCompleted)
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: ScaleTransition(
                                    scale: _completeController,
                                    child: const Icon(Icons.check_circle,
                                        color: Colors.white, size: 24),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      setState(() {
                        _initializeLevel();
                      });
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Yeniden Başlat'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton.icon(
                    onPressed: () {
                      // Hint: show one correct position
                      for (int i = 0; i < _pieces.length; i++) {
                        if (_pieces[i] != i) {
                          final correctIndex = _pieces.indexOf(i);
                          setState(() {
                            final temp = _pieces[i];
                            _pieces[i] = _pieces[correctIndex];
                            _pieces[correctIndex] = temp;
                            _moves += 2;
                          });
                          break;
                        }
                      }
                    },
                    icon: const Icon(Icons.lightbulb),
                    label: const Text('İpucu (-2 hamle)'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.all(16),
                      backgroundColor: Colors.amber[700],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _shakeController.dispose();
    _completeController.dispose();
    super.dispose();
  }
}
