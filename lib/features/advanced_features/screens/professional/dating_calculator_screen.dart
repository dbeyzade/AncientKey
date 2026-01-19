import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class DatingCalculatorScreen extends StatefulWidget {
  const DatingCalculatorScreen({super.key});

  @override
  State<DatingCalculatorScreen> createState() => _DatingCalculatorScreenState();
}

class _DatingCalculatorScreenState extends State<DatingCalculatorScreen> {
  final TextEditingController _yearController = TextEditingController();
  String _selectedMethod = 'Karbon-14';
  String? _result;
  String? _accuracy;

  final Map<String, Map<String, dynamic>> _methods = {
    'Karbon-14': {
      'icon': Icons.science,
      'range': '300 - 50,000 yıl',
      'accuracy': '±40 yıl',
      'color': Colors.blue,
      'description': 'Organik materyaller için en yaygın yöntem',
    },
    'Dendrokronoloji': {
      'icon': Icons.park,
      'range': '10,000+ yıl',
      'accuracy': '±1 yıl',
      'color': Colors.green,
      'description': 'Ağaç halkalarıyla mutlak tarihleme',
    },
    'Termolüminesans': {
      'icon': Icons.wb_sunny,
      'range': '100 - 500,000 yıl',
      'accuracy': '±5-10%',
      'color': Colors.orange,
      'description': 'Seramik ve kil nesneler için',
    },
    'Potasyum-Argon': {
      'icon': Icons.volcano,
      'range': '100,000 - 4.6B yıl',
      'accuracy': '±2-5%',
      'color': Colors.red,
      'description': 'Volkanik kayaçlar için',
    },
    'Stratigrafik': {
      'icon': Icons.layers,
      'range': 'Değişken',
      'accuracy': '±100-1000 yıl',
      'color': Colors.brown,
      'description': 'Toprak katmanlarıyla göreceli tarihleme',
    },
  };

  void _calculate() {
    if (_yearController.text.isEmpty) {
      setState(() {
        _result = null;
        _accuracy = null;
      });
      return;
    }

    final year = int.tryParse(_yearController.text);
    if (year == null) return;

    final method = _methods[_selectedMethod]!;
    setState(() {
      _accuracy = method['accuracy'];
      
      if (year < 0) {
        _result = 'MÖ ${year.abs()}';
      } else if (year < 1000) {
        _result = 'MS $year';
      } else if (year < 10000) {
        _result = '${(year / 1000).toStringAsFixed(1)} bin yıl önce';
      } else if (year < 1000000) {
        _result = '${(year / 1000).toStringAsFixed(0)} bin yıl önce';
      } else {
        _result = '${(year / 1000000).toStringAsFixed(2)} milyon yıl önce';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚗️ Tarihleme Hesaplayıcı'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              color: Colors.blue[900],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Icon(Icons.info_outline, size: 32, color: Colors.white),
                    const SizedBox(height: 8),
                    const Text(
                      'Karbon-14 Tarihleme Nedir?',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Karbon-14, organik materyallerin yaşını belirlemek için kullanılan radyoaktif bir karbon izotopudur. Yarı ömrü 5,730 yıldır ve bu sürede C-14\'ün yarısı bozunur.',
                      style: TextStyle(color: Colors.white70),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Tarihleme Yöntemi Seçin:',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            ..._methods.entries.map((entry) {
              final isSelected = _selectedMethod == entry.key;
              return GestureDetector(
                onTap: () => setState(() => _selectedMethod = entry.key),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? LinearGradient(
                            colors: [entry.value['color'], entry.value['color'].withOpacity(0.7)])
                        : null,
                    color: isSelected ? null : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? Colors.white : Colors.grey[400]!,
                      width: isSelected ? 3 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(entry.value['icon'], color: entry.value['color']),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              entry.key,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? Colors.white : Colors.black87,
                              ),
                            ),
                            Text(
                              entry.value['description'],
                              style: TextStyle(
                                fontSize: 12,
                                color: isSelected ? Colors.white70 : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Aralık: ${entry.value['range']}',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? Colors.white60 : Colors.grey[500],
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.white),
                    ],
                  ),
                ),
              );
            }),
            const SizedBox(height: 24),
            TextField(
              controller: _yearController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              style: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
              decoration: InputDecoration(
                labelText: 'Başlangıç C-14 Miktarı (%)',
                labelStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
                prefixIcon: const Icon(Icons.science, color: Colors.blue),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.white,
                helperText: 'Örnek: 50 (yarı ömür), 25 (iki yarı ömür)',
                helperStyle: const TextStyle(color: Colors.black87),
              ),
              onChanged: (_) => _calculate(),
            ),
            const SizedBox(height: 24),
            if (_result != null) ...[
              Card(
                color: Colors.green[700],
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      const Icon(Icons.check_circle, size: 48, color: Colors.white),
                      const SizedBox(height: 12),
                      const Text('Hesaplanan Tarih:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                        _result!,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Yöntem:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                Text(_selectedMethod, style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Doğruluk:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
                                Text(_accuracy!, style: const TextStyle(color: Colors.black87)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 24),
            const Text(
              '📦 Örnek Senaryolar',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildExampleCard('Antik Seramik', '~1.1 bin yıl', '🏺', Colors.orange),
            _buildExampleCard('Dinozor Fosili', '~65.0 milyon yıl', '🦴', Colors.brown),
            _buildExampleCard('Ölü Deniz Yazmaları', '~2.0 bin yıl', '📜', Colors.amber),
          ],
        ),
      ),
    );
  }

  Widget _buildExampleCard(String title, String age, String emoji, Color color) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(emoji, style: const TextStyle(fontSize: 24)),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
        subtitle: Text(
          age,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _yearController.dispose();
    super.dispose();
  }
}
