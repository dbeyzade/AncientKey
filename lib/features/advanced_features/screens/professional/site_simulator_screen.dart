import 'package:flutter/material.dart';
import 'dart:math';

class SiteSimulatorScreen extends StatefulWidget {
  const SiteSimulatorScreen({super.key});

  @override
  State<SiteSimulatorScreen> createState() => _SiteSimulatorScreenState();
}

class _SiteSimulatorScreenState extends State<SiteSimulatorScreen> {
  int excavationDepth = 0;
  int budget = 10000;
  int teamSize = 3;
  List<Artifact> discoveredArtifacts = [];
  String selectedTool = 'shovel';
  bool isExcavating = false;

  final Map<String, Map<String, dynamic>> tools = {
    'shovel': {'name': 'Kürek', 'emoji': '🔨', 'speed': 1, 'accuracy': 60},
    'brush': {'name': 'Fırça', 'emoji': '🖌️', 'speed': 3, 'accuracy': 95},
    'trowel': {'name': 'Mala', 'emoji': '🔧', 'speed': 2, 'accuracy': 80},
    'scanner': {'name': 'Radar', 'emoji': '📡', 'speed': 5, 'accuracy': 99},
  };

  final List<Map<String, dynamic>> artifactTypes = [
    {'name': 'Seramik Parçası', 'emoji': '🏺', 'value': 100, 'rarity': 70},
    {'name': 'Sikke', 'emoji': '🪙', 'value': 500, 'rarity': 40},
    {'name': 'Takı', 'emoji': '💍', 'value': 1000, 'rarity': 20},
    {'name': 'Heykel Parçası', 'emoji': '🗿', 'value': 2000, 'rarity': 10},
    {'name': 'Tablet', 'emoji': '📜', 'value': 5000, 'rarity': 5},
  ];

  void _excavate() {
    if (budget < 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Yetersiz bütçe! Her kazı 100₺ tutar.')),
      );
      return;
    }

    setState(() {
      isExcavating = true;
      budget -= 100;
    });

    Future.delayed(Duration(seconds: tools[selectedTool]!['speed']), () {
      final random = Random();
      final toolAccuracy = tools[selectedTool]!['accuracy'];

      if (random.nextInt(100) < toolAccuracy) {
        // Artefakt bulundu
        final possibleArtifacts = artifactTypes.where((art) {
          return random.nextInt(100) < art['rarity'];
        }).toList();

        if (possibleArtifacts.isNotEmpty) {
          final found =
              possibleArtifacts[random.nextInt(possibleArtifacts.length)];
          setState(() {
            excavationDepth += 1;
            discoveredArtifacts.add(
              Artifact(
                name: found['name'],
                emoji: found['emoji'],
                value: found['value'],
                depth: excavationDepth,
              ),
            );
            budget += found['value'] as int;
            isExcavating = false;
          });

          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('🎉 ${found['emoji']} Bulundu!'),
              content: Text(
                '${found['name']} buldunuz!\n'
                'Derinlik: ${excavationDepth}m\n'
                'Değer: ${found['value']}₺',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Devam Et'),
                ),
              ],
            ),
          );
        } else {
          setState(() {
            excavationDepth += 1;
            isExcavating = false;
          });
        }
      } else {
        // Hasar verildi
        if (discoveredArtifacts.isNotEmpty && random.nextBool()) {
          setState(() {
            discoveredArtifacts.removeLast();
            isExcavating = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '💔 Dikkatli olmadığınız için bir eser zarar gördü!',
              ),
              backgroundColor: Colors.red,
            ),
          );
        } else {
          setState(() {
            excavationDepth += 1;
            isExcavating = false;
          });
        }
      }
    });
  }

  void _hireTeamMember() {
    if (budget < 500) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('❌ Yetersiz bütçe! Ekip üyesi 500₺')),
      );
      return;
    }

    setState(() {
      budget -= 500;
      teamSize += 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Yeni ekip üyesi işe alındı!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  void _resetSite() {
    setState(() {
      excavationDepth = 0;
      budget = 10000;
      teamSize = 3;
      discoveredArtifacts.clear();
      selectedTool = 'shovel';
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalValue = discoveredArtifacts.fold<int>(
      0,
      (sum, art) => sum + art.value,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('🏗️ Arkeolojik Saha Simülatörü'),
        backgroundColor: Colors.orange[800],
        actions: [
          IconButton(
            icon: const Icon(Icons.restart_alt),
            onPressed: _resetSite,
            tooltip: 'Siteyi Sıfırla',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Stats Cards
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    'Derinlik',
                    '${excavationDepth}m',
                    Icons.arrow_downward,
                    Colors.blue,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    'Bütçe',
                    '$budget₺',
                    Icons.attach_money,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    'Ekip',
                    '$teamSize',
                    Icons.people,
                    Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Excavation Site Visualization
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.brown[200]!,
                    Colors.brown[600]!,
                    Colors.brown[900]!,
                  ],
                ),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.brown[900]!, width: 3),
              ),
              child: Stack(
                children: [
                  // Depth markers
                  Positioned(
                    left: 16,
                    top: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '0m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${excavationDepth}m',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  // Artifacts in ground
                  ...discoveredArtifacts.asMap().entries.map((entry) {
                    final index = entry.key;
                    final artifact = entry.value;
                    return Positioned(
                      left: 60.0 + (index % 3) * 80.0,
                      top: 30.0 + (artifact.depth * 15.0),
                      child: Text(
                        artifact.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                    );
                  }),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Tools Selection
            const Text(
              'Kazı Aletleri',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: tools.entries.map((entry) {
                  final isSelected = selectedTool == entry.key;
                  final tool = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: GestureDetector(
                      onTap: () => setState(() => selectedTool = entry.key),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.orange[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? Colors.orange[900]!
                                : Colors.grey[400]!,
                            width: 2,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              tool['emoji'],
                              style: const TextStyle(fontSize: 32),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              tool['name'],
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Hız: ${tool['speed']}s',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                            Text(
                              'Doğruluk: ${tool['accuracy']}%',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected
                                    ? Colors.white70
                                    : Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 24),

            // Excavate Button
            ElevatedButton.icon(
              onPressed: isExcavating ? null : _excavate,
              icon: Icon(
                isExcavating ? Icons.hourglass_empty : Icons.construction,
              ),
              label: Text(
                isExcavating ? 'Kazı Yapılıyor...' : 'Kazı Yap (100₺)',
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange[800],
                padding: const EdgeInsets.all(16),
                textStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Hire Team Member Button
            OutlinedButton.icon(
              onPressed: _hireTeamMember,
              icon: const Icon(Icons.person_add),
              label: const Text('Ekip Üyesi İşe Al (500₺)'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.all(16),
                side: BorderSide(color: Colors.orange[800]!),
              ),
            ),
            const SizedBox(height: 24),

            // Discovered Artifacts
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bulunan Eserler',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    'Toplam: $totalValue₺',
                    style: TextStyle(
                      color: Colors.green[900],
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (discoveredArtifacts.isEmpty)
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Column(
                    children: [
                      Icon(Icons.search_off, size: 48, color: Colors.grey),
                      SizedBox(height: 8),
                      Text(
                        'Henüz eser bulunamadı.\nKazıya başlayın!',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: discoveredArtifacts.length,
                itemBuilder: (context, index) {
                  final artifact = discoveredArtifacts[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      leading: Text(
                        artifact.emoji,
                        style: const TextStyle(fontSize: 32),
                      ),
                      title: Text(
                        artifact.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('Derinlik: ${artifact.depth}m'),
                      trailing: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${artifact.value}₺',
                          style: TextStyle(
                            color: Colors.amber[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _StatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: color.withOpacity(0.7)),
          ),
        ],
      ),
    );
  }
}

class Artifact {
  final String name;
  final String emoji;
  final int value;
  final int depth;

  Artifact({
    required this.name,
    required this.emoji,
    required this.value,
    required this.depth,
  });
}
