import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ExcavationJournalScreen extends StatefulWidget {
  const ExcavationJournalScreen({super.key});

  @override
  State<ExcavationJournalScreen> createState() =>
      _ExcavationJournalScreenState();
}

class _ExcavationJournalScreenState extends State<ExcavationJournalScreen> {
  final List<Map<String, dynamic>> _entries = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadEntries();
  }

  Future<void> _loadEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = prefs.getStringList('excavation_entries') ?? [];
    setState(() {
      _entries.clear();
      _entries.addAll(
        entriesJson.map((e) => jsonDecode(e) as Map<String, dynamic>),
      );
    });
  }

  Future<void> _saveEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final entriesJson = _entries.map((e) => jsonEncode(e)).toList();
    await prefs.setStringList('excavation_entries', entriesJson);
  }

  Future<void> _addNewEntry() async {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    String? imagePath;
    String selectedType = 'Seramik';
    String selectedCondition = 'İyi';

    final result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Yeni Kayıt Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    labelText: 'Başlık',
                    prefixIcon: Icon(Icons.title),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Buluntu Türü',
                    prefixIcon: Icon(Icons.category),
                    border: OutlineInputBorder(),
                  ),
                  items:
                      [
                            'Seramik',
                            'Heykel',
                            'Sikke',
                            'Takı',
                            'Silah',
                            'Günlük Eşya',
                            'Diğer',
                          ]
                          .map(
                            (type) => DropdownMenuItem(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedType = value!),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: selectedCondition,
                  decoration: const InputDecoration(
                    labelText: 'Durum',
                    prefixIcon: Icon(Icons.assessment),
                    border: OutlineInputBorder(),
                  ),
                  items: ['Mükemmel', 'İyi', 'Orta', 'Kötü', 'Parçalı']
                      .map(
                        (condition) => DropdownMenuItem(
                          value: condition,
                          child: Text(condition),
                        ),
                      )
                      .toList(),
                  onChanged: (value) =>
                      setDialogState(() => selectedCondition = value!),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: notesController,
                  maxLines: 4,
                  decoration: const InputDecoration(
                    labelText: 'Notlar',
                    prefixIcon: Icon(Icons.notes),
                    border: OutlineInputBorder(),
                    hintText: 'Buluntuyla ilgili detaylar...',
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () async {
                    final XFile? image = await _picker.pickImage(
                      source: ImageSource.camera,
                    );
                    if (image != null) {
                      setDialogState(() => imagePath = image.path);
                    }
                  },
                  icon: const Icon(Icons.camera_alt),
                  label: Text(
                    imagePath == null ? 'Fotoğraf Çek' : 'Fotoğraf Eklendi ✓',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      ),
    );

    if (result == true && titleController.text.isNotEmpty) {
      setState(() {
        _entries.insert(0, {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'title': titleController.text,
          'type': selectedType,
          'condition': selectedCondition,
          'notes': notesController.text,
          'imagePath': imagePath,
          'date': DateTime.now().toIso8601String(),
        });
      });
      await _saveEntries();
    }
  }

  void _deleteEntry(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Kaydı Sil'),
        content: const Text('Bu kaydı silmek istediğinize emin misiniz?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          FilledButton(
            onPressed: () {
              setState(() {
                _entries.removeAt(index);
              });
              _saveEntries();
              Navigator.pop(context);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Sil'),
          ),
        ],
      ),
    );
  }

  String _getTypeIcon(String type) {
    switch (type) {
      case 'Seramik':
        return '🏺';
      case 'Heykel':
        return '🗿';
      case 'Sikke':
        return '🪙';
      case 'Takı':
        return '💍';
      case 'Silah':
        return '⚔️';
      case 'Günlük Eşya':
        return '🏛️';
      default:
        return '📦';
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case 'Mükemmel':
        return Colors.green;
      case 'İyi':
        return Colors.blue;
      case 'Orta':
        return Colors.orange;
      case 'Kötü':
        return Colors.red;
      case 'Parçalı':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📓 Kazı Defteri'),
        backgroundColor: Colors.brown[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Kazı Defteri Hakkında'),
                  content: const Text(
                    'Arkeolojik buluntularınızı kaydedin!\n\n'
                    '• Fotoğraf çekin\n'
                    '• Buluntu türünü seçin\n'
                    '• Durumunu değerlendirin\n'
                    '• Notlar ekleyin\n\n'
                    'Tüm kayıtlar cihazınızda güvenle saklanır.',
                  ),
                  actions: [
                    FilledButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Anladım'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _addNewEntry,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Kayıt'),
        backgroundColor: Colors.brown[700],
      ),
      body: _entries.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.book, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz kayıt yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İlk buluntunu kaydet!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _entries.length,
              itemBuilder: (context, index) {
                final entry = _entries[index];
                final date = DateTime.parse(entry['date']);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (entry['imagePath'] != null)
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                          child: Image.file(
                            File(entry['imagePath']),
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  _getTypeIcon(entry['type']),
                                  style: const TextStyle(fontSize: 32),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        entry['title'],
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        entry['type'],
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _deleteEntry(index),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: _getConditionColor(
                                  entry['condition'],
                                ).withOpacity(0.2),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: _getConditionColor(entry['condition']),
                                ),
                              ),
                              child: Text(
                                'Durum: ${entry['condition']}',
                                style: TextStyle(
                                  color: _getConditionColor(entry['condition']),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (entry['notes'].isNotEmpty) ...[
                              const SizedBox(height: 12),
                              Text(
                                entry['notes'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                            ],
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_today,
                                  size: 14,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${date.day}.${date.month}.${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
