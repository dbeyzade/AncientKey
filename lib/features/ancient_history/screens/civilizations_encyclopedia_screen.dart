import 'package:flutter/material.dart';
import '../data/civilizations_data.dart';
import '../models/civilization.dart';

class CivilizationsEncyclopediaScreen extends StatelessWidget {
  const CivilizationsEncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Antik Medeniyetler Ansiklopedisi'),
        backgroundColor: Colors.amber[800],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: ancientCivilizations.length,
        itemBuilder: (context, index) {
          final civ = ancientCivilizations[index];
          return _buildCivilizationCard(context, civ);
        },
      ),
    );
  }

  Widget _buildCivilizationCard(BuildContext context, Civilization civ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      child: InkWell(
        onTap: () => _showCivilizationDetails(context, civ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.amber[700]!, Colors.orange[600]!],
                ),
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Center(
                child: Icon(
                  Icons.account_balance,
                  size: 80,
                  color: Colors.white.withOpacity(0.7),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    civ.name,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(civ.period, style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(civ.location, style: const TextStyle(color: Colors.grey)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    civ.description,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCivilizationDetails(BuildContext context, Civilization civ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _CivilizationDetailScreen(civilization: civ),
      ),
    );
  }
}

class _CivilizationDetailScreen extends StatelessWidget {
  final Civilization civilization;

  const _CivilizationDetailScreen({required this.civilization});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(civilization.name),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Colors.amber[700]!, Colors.orange[600]!],
                  ),
                ),
                child: Center(
                  child: Icon(
                    Icons.account_balance,
                    size: 100,
                    color: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSection('📅 Dönem', civilization.period),
                  _buildSection('📍 Konum', civilization.location),
                  _buildSection('📖 Açıklama', civilization.description),
                  _buildSection('🌅 Yükseliş', civilization.rise),
                  _buildSection('⭐ Altın Çağ', civilization.peak),
                  _buildSection('🌆 Çöküş', civilization.decline),
                  _buildListSection('🏙️ Önemli Kentler', civilization.majorCities),
                  _buildListSection('🏆 Başarılar', civilization.achievements),
                  _buildListSection('👤 Ünlü Kişiler', civilization.famousFigures),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 15, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildListSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
          const SizedBox(height: 8),
          ...items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• ', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Expanded(child: Text(item, style: const TextStyle(fontSize: 15))),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
