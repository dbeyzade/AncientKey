import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

class CarbonDatingScreen extends StatefulWidget {
  const CarbonDatingScreen({super.key});

  @override
  State<CarbonDatingScreen> createState() => _CarbonDatingScreenState();
}

class _CarbonDatingScreenState extends State<CarbonDatingScreen> {
  final TextEditingController _remainingC14Controller = TextEditingController();
  final TextEditingController _originalC14Controller = TextEditingController(text: '100');
  
  double? _calculatedAge;
  String? _errorMessage;
  int _selectedPresetIndex = -1;

  final List<Map<String, dynamic>> _presets = [
    {'name': '🏺 Antik Seramik', 'remaining': 87.5, 'expected': 1100},
    {'name': '🦴 Dinozor Fosili', 'remaining': 0.1, 'expected': 65000000},
    {'name': '📜 Ölü Deniz Yazmaları', 'remaining': 78.2, 'expected': 2000},
    {'name': '🗿 Göbekli Tepe', 'remaining': 12.5, 'expected': 11500},
    {'name': '🏛️ Mısır Piramidi', 'remaining': 61.8, 'expected': 4500},
    {'name': '🎨 Lascaux Mağara', 'remaining': 8.2, 'expected': 17000},
  ];

  void _calculate() {
    setState(() {
      _errorMessage = null;
      _calculatedAge = null;

      try {
        final remaining = double.parse(_remainingC14Controller.text);
        final original = double.parse(_originalC14Controller.text);

        if (remaining <= 0 || remaining > original) {
          _errorMessage = 'Kalan miktar 0 ile başlangıç değeri arasında olmalı';
          return;
        }

        if (original <= 0) {
          _errorMessage = 'Başlangıç değeri pozitif olmalı';
          return;
        }

        // Karbon-14 yarı ömrü: 5730 yıl
        const halfLife = 5730.0;
        
        // N(t) = N₀ × (1/2)^(t/t½)
        // t = t½ × (ln(N(t)/N₀) / ln(1/2))
        final ratio = remaining / original;
        final age = halfLife * (log(ratio) / log(0.5));

        _calculatedAge = age;
      } catch (e) {
        _errorMessage = 'Geçerli sayılar girin';
      }
    });
  }

  void _usePreset(int index) {
    setState(() {
      _selectedPresetIndex = index;
      _remainingC14Controller.text = _presets[index]['remaining'].toString();
      _originalC14Controller.text = '100';
    });
    _calculate();
  }

  String _formatAge(double years) {
    if (years < 1000) {
      return '${years.toStringAsFixed(0)} yıl';
    } else if (years < 1000000) {
      return '${(years / 1000).toStringAsFixed(1)} bin yıl';
    } else {
      return '${(years / 1000000).toStringAsFixed(1)} milyon yıl';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('⚛️ Karbon-14 Tarihleme'),
        backgroundColor: Colors.blue[900],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildInfoCard(),
            const SizedBox(height: 24),
            _buildPresetsSection(),
            const SizedBox(height: 24),
            _buildCalculatorCard(),
            if (_calculatedAge != null || _errorMessage != null) ...[
              const SizedBox(height: 24),
              _buildResultCard(),
            ],
            const SizedBox(height: 24),
            _buildFormulaCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      color: Colors.blue[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[900], size: 28),
                const SizedBox(width: 12),
                const Text('Karbon-14 Tarihleme Nedir?',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Karbon-14, organik materyallerin yaşını belirlemek için kullanılan radyoaktif bir karbon izotopudur. '
              'Yarı ömrü 5,730 yıldır ve bu sürede C-14\'ün yarısı bozunur.',
              style: TextStyle(fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.schedule, color: Colors.orange, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Tarihlenebilir Aralık: ~300 - 50,000 yıl',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPresetsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('📦 Örnek Senaryolar',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _presets.length,
            itemBuilder: (context, index) {
              final preset = _presets[index];
              final isSelected = _selectedPresetIndex == index;
              
              return GestureDetector(
                onTap: () => _usePreset(index),
                child: Container(
                  width: 140,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isSelected
                          ? [Colors.blue[700]!, Colors.blue[900]!]
                          : [Colors.grey[300]!, Colors.grey[400]!],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: isSelected
                        ? [BoxShadow(color: Colors.blue[700]!.withOpacity(0.5), blurRadius: 8, offset: const Offset(0, 4))]
                        : [],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(preset['name'].split(' ').first,
                            style: const TextStyle(fontSize: 32)),
                        const SizedBox(height: 8),
                        Text(preset['name'].split(' ').skip(1).join(' '),
                            style: TextStyle(
                              color: isSelected ? Colors.white : Colors.black87,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 4),
                        Text('~${_formatAge(preset['expected'].toDouble())}',
                            style: TextStyle(
                              color: isSelected ? Colors.white70 : Colors.black54,
                              fontSize: 11,
                            )),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCalculatorCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('🧮 Yaş Hesaplama',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _originalC14Controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: InputDecoration(
                labelText: 'Başlangıç C-14 Miktarı (%)',
                prefixIcon: const Icon(Icons.science),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _remainingC14Controller,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}'))],
              decoration: InputDecoration(
                labelText: 'Kalan C-14 Miktarı (%)',
                prefixIcon: const Icon(Icons.radar),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                filled: true,
                fillColor: Colors.grey[100],
                helperText: 'Örnek: 50 (yarı ömür), 25 (iki yarı ömür)',
              ),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _calculate,
              icon: const Icon(Icons.calculate),
              label: const Text('Yaşı Hesapla', style: TextStyle(fontSize: 16)),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.all(16),
                backgroundColor: Colors.blue[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Card(
      color: _errorMessage != null ? Colors.red[50] : Colors.green[50],
      elevation: 8,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              _errorMessage != null ? Icons.error_outline : Icons.check_circle_outline,
              size: 48,
              color: _errorMessage != null ? Colors.red[700] : Colors.green[700],
            ),
            const SizedBox(height: 12),
            Text(
              _errorMessage != null ? 'Hata!' : 'Sonuç',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: _errorMessage != null ? Colors.red[900] : Colors.green[900],
              ),
            ),
            const SizedBox(height: 8),
            if (_errorMessage != null)
              Text(_errorMessage!,
                  style: TextStyle(fontSize: 16, color: Colors.red[700]),
                  textAlign: TextAlign.center)
            else if (_calculatedAge != null) ...[
              Text(
                _formatAge(_calculatedAge!),
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[900],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Yaklaşık ${_calculatedAge!.toStringAsFixed(0)} yıl önce',
                style: const TextStyle(fontSize: 16, color: Colors.black54),
              ),
              if (_selectedPresetIndex >= 0) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      const Text('Beklenen Yaş ile Karşılaştırma:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        'Beklenen: ${_formatAge(_presets[_selectedPresetIndex]['expected'].toDouble())}',
                        style: const TextStyle(fontSize: 14),
                      ),
                      Text(
                        'Fark: ${(((_calculatedAge! - _presets[_selectedPresetIndex]['expected']) / _presets[_selectedPresetIndex]['expected']) * 100).abs().toStringAsFixed(1)}%',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildFormulaCard() {
    return Card(
      color: Colors.grey[50],
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('📐 Formül',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('t = t½ × (ln(N/N₀) / ln(0.5))',
                      style: TextStyle(fontFamily: 'Courier', fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 12),
                  Text('t = Geçen süre (yıl)', style: TextStyle(fontSize: 14)),
                  Text('t½ = Yarı ömür (5,730 yıl)', style: TextStyle(fontSize: 14)),
                  Text('N = Kalan C-14 miktarı', style: TextStyle(fontSize: 14)),
                  Text('N₀ = Başlangıç C-14 miktarı', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _remainingC14Controller.dispose();
    _originalC14Controller.dispose();
    super.dispose();
  }
}
