import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/inscriptions_service.dart';

final inscriptionsProvider = FutureProvider<List<Inscription>>((ref) async {
  return await InscriptionsService().getAllInscriptions();
});

final scriptTypeFilterProvider = StateProvider<String?>((ref) => null);

class InscriptionsScreen extends ConsumerWidget {
  const InscriptionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inscriptionsAsync = ref.watch(inscriptionsProvider);
    final selectedType = ref.watch(scriptTypeFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Antik Yazıtlar'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(scriptTypeFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: null, child: Text('Tümü')),
              const PopupMenuItem(value: 'Mısır Hiyeroglifleri', child: Text('Mısır Hiyeroglifleri')),
              const PopupMenuItem(value: 'Çivi Yazısı', child: Text('Çivi Yazısı')),
              const PopupMenuItem(value: 'Antik Yunan', child: Text('Antik Yunan')),
              const PopupMenuItem(value: 'Latince', child: Text('Latince')),
              const PopupMenuItem(value: 'Rune Yazısı', child: Text('Rune Yazısı')),
              const PopupMenuItem(value: 'Maya Hiyeroglifleri', child: Text('Maya Hiyeroglifleri')),
              const PopupMenuItem(value: 'Antik Çin', child: Text('Antik Çin')),
              const PopupMenuItem(value: 'Sanskritçe', child: Text('Sanskritçe')),
              const PopupMenuItem(value: 'Arap Yazısı', child: Text('Arap Yazısı')),
            ],
          ),
        ],
      ),
      body: inscriptionsAsync.when(
        data: (inscriptions) {
          final filtered = selectedType == null
              ? inscriptions
              : inscriptions.where((i) => i.scriptType == selectedType).toList();

          if (filtered.isEmpty) {
            return const Center(child: Text('Yazıt bulunamadı'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final inscription = filtered[index];
              return _InscriptionCard(inscription: inscription);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
      ),
    );
  }
}

class _InscriptionCard extends StatelessWidget {
  final Inscription inscription;

  const _InscriptionCard({required this.inscription});

  Color _getScriptColor() {
    switch (inscription.scriptType) {
      case 'Mısır Hiyeroglifleri':
        return Colors.amber;
      case 'Çivi Yazısı':
        return Colors.brown;
      case 'Antik Yunan':
        return Colors.blue;
      case 'Latince':
        return Colors.red;
      case 'Rune Yazısı':
        return Colors.teal;
      case 'Maya Hiyeroglifleri':
        return Colors.green;
      case 'Antik Çin':
        return Colors.orange;
      case 'Sanskritçe':
        return Colors.purple;
      case 'Arap Yazısı':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  IconData _getScriptIcon() {
    switch (inscription.scriptType) {
      case 'Mısır Hiyeroglifleri':
        return Icons.border_all;
      case 'Çivi Yazısı':
        return Icons.format_shapes;
      case 'Antik Yunan':
      case 'Latince':
        return Icons.sort_by_alpha;
      case 'Rune Yazısı':
        return Icons.catching_pokemon;
      case 'Maya Hiyeroglifleri':
        return Icons.calendar_view_week;
      case 'Antik Çin':
        return Icons.translate;
      case 'Sanskritçe':
        return Icons.auto_stories;
      case 'Arap Yazısı':
        return Icons.text_fields;
      default:
        return Icons.article;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => InscriptionDetailScreen(inscription: inscription),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              colors: [
                _getScriptColor().withOpacity(0.1),
                _getScriptColor().withOpacity(0.05),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: _getScriptColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(_getScriptIcon(), color: _getScriptColor(), size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          inscription.scriptType,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _getScriptColor(),
                          ),
                        ),
                        if (inscription.language != null)
                          Text(
                            inscription.language!,
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                      ],
                    ),
                  ),
                  if (inscription.deciphered)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Çözüldü',
                        style: TextStyle(fontSize: 10, color: Colors.green, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: _getScriptColor().withOpacity(0.3)),
                ),
                child: Text(
                  inscription.originalText,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
              if (inscription.transliteration != null) ...[
                const SizedBox(height: 8),
                Text(
                  inscription.transliteration!,
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.grey[700]),
                ),
              ],
              if (inscription.translation != null) ...[
                const SizedBox(height: 8),
                Text(
                  inscription.translation!,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
              if (inscription.dateCarved != null) ...[
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Text(
                      inscription.dateCarved!,
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class InscriptionDetailScreen extends StatelessWidget {
  final Inscription inscription;

  const InscriptionDetailScreen({super.key, required this.inscription});

  Color _getScriptColor() {
    switch (inscription.scriptType) {
      case 'Mısır Hiyeroglifleri':
        return Colors.amber;
      case 'Çivi Yazısı':
        return Colors.brown;
      case 'Antik Yunan':
        return Colors.blue;
      case 'Latince':
        return Colors.red;
      case 'Rune Yazısı':
        return Colors.teal;
      case 'Maya Hiyeroglifleri':
        return Colors.green;
      case 'Antik Çin':
        return Colors.orange;
      case 'Sanskritçe':
        return Colors.purple;
      case 'Arap Yazısı':
        return Colors.deepPurple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(inscription.scriptType),
        backgroundColor: _getScriptColor(),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      _getScriptColor().withOpacity(0.2),
                      _getScriptColor().withOpacity(0.05),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      inscription.originalText,
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (inscription.deciphered) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Yazıt Çözüldü',
                              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            _buildInfoSection('Yazı Sistemi', inscription.scriptType, Icons.text_format, _getScriptColor()),
            if (inscription.language != null)
              _buildInfoSection('Dil', inscription.language!, Icons.language, Colors.blue),
            if (inscription.transliteration != null)
              _buildInfoSection('Transkripsiyon', inscription.transliteration!, Icons.spellcheck, Colors.orange),
            if (inscription.translation != null)
              _buildInfoSection('Çeviri', inscription.translation!, Icons.translate, Colors.green),
            if (inscription.dateCarved != null)
              _buildInfoSection('Tarih', inscription.dateCarved!, Icons.calendar_today, Colors.purple),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content, IconData icon, Color color) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
