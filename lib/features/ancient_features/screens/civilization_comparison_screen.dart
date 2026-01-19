import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/civilization_comparison_service.dart';

final civilizationsProvider = FutureProvider<List<Civilization>>((ref) async {
  final service = ref.read(civilizationComparisonServiceProvider);
  return service.getAllCivilizations();
});

class CivilizationComparisonScreen extends ConsumerStatefulWidget {
  const CivilizationComparisonScreen({super.key});

  @override
  ConsumerState<CivilizationComparisonScreen> createState() => _CivilizationComparisonScreenState();
}

class _CivilizationComparisonScreenState extends ConsumerState<CivilizationComparisonScreen> {
  Civilization? selectedCiv1;
  Civilization? selectedCiv2;

  @override
  Widget build(BuildContext context) {
    final civilizationsAsync = ref.watch(civilizationsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medeniyet Karşılaştırma'),
        elevation: 2,
      ),
      body: civilizationsAsync.when(
        data: (civilizations) {
          if (civilizations.isEmpty) {
            return const Center(child: Text('Medeniyet verisi bulunamadı'));
          }

          return Column(
            children: [
              // Selection Row
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue[800]!, Colors.blue[600]!],
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildCivilizationSelector(
                        civilizations,
                        selectedCiv1,
                        'Medeniyet 1',
                        (civ) => setState(() => selectedCiv1 = civ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.compare_arrows, color: Colors.white, size: 32),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _buildCivilizationSelector(
                        civilizations,
                        selectedCiv2,
                        'Medeniyet 2',
                        (civ) => setState(() => selectedCiv2 = civ),
                      ),
                    ),
                  ],
                ),
              ),

              // Comparison Content
              Expanded(
                child: selectedCiv1 != null && selectedCiv2 != null
                    ? _buildComparisonView(selectedCiv1!, selectedCiv2!)
                    : Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.compare, size: 80, color: Colors.grey[400]),
                            const SizedBox(height: 16),
                            Text(
                              'Karşılaştırmak için iki medeniyet seçin',
                              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Hata: $err')),
      ),
    );
  }

  Widget _buildCivilizationSelector(
    List<Civilization> civilizations,
    Civilization? selected,
    String label,
    Function(Civilization?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<Civilization>(
        value: selected,
        hint: Text(label, style: const TextStyle(fontSize: 14)),
        isExpanded: true,
        underline: const SizedBox(),
        items: civilizations.map((civ) {
          return DropdownMenuItem(
            value: civ,
            child: Text(civ.name, style: const TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildComparisonView(Civilization civ1, Civilization civ2) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildComparisonRow('📅 Dönem', civ1.period, civ2.period),
        _buildComparisonRow('🌍 Bölge', civ1.region, civ2.region),
        _buildComparisonRow('👑 Yönetim', civ1.government, civ2.government),
        _buildComparisonRow('🔬 Teknoloji', civ1.technology, civ2.technology),
        _buildComparisonRow('🏛️ Mimari', civ1.architecture, civ2.architecture),
        _buildComparisonRow('🎨 Sanat', civ1.art, civ2.art),
        _buildComparisonRow('🙏 Din', civ1.religion, civ2.religion),
        _buildComparisonRow('⚔️ Ordu', civ1.military, civ2.military),
        _buildComparisonRow('💰 Ekonomi', civ1.economy, civ2.economy),
        _buildComparisonRow('✍️ Yazı', civ1.writing, civ2.writing),
        _buildComparisonRow('⭐ Başarılar', civ1.achievements, civ2.achievements),
      ],
    );
  }

  Widget _buildComparisonRow(String title, String value1, String value2) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value1,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.orange[50],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      value2,
                      style: const TextStyle(fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
