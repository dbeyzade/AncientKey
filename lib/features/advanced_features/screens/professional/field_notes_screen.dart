import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FieldNotesScreen extends StatefulWidget {
  const FieldNotesScreen({super.key});

  @override
  State<FieldNotesScreen> createState() => _FieldNotesScreenState();
}

class _FieldNotesScreenState extends State<FieldNotesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final List<Map<String, dynamic>> _notes = [];
  final List<Map<String, dynamic>> _sketches = [];
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final notesJson = prefs.getStringList('field_notes') ?? [];
    final sketchesJson = prefs.getStringList('field_sketches') ?? [];

    setState(() {
      _notes.clear();
      _notes.addAll(
        notesJson.map((e) => jsonDecode(e) as Map<String, dynamic>),
      );
      _sketches.clear();
      _sketches.addAll(
        sketchesJson.map((e) => jsonDecode(e) as Map<String, dynamic>),
      );
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      'field_notes',
      _notes.map((e) => jsonEncode(e)).toList(),
    );
    await prefs.setStringList(
      'field_sketches',
      _sketches.map((e) => jsonEncode(e)).toList(),
    );
  }

  Future<void> _addNote() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _AddNoteDialog(),
    );

    if (result != null) {
      setState(() {
        _notes.insert(0, {
          ...result,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'date': DateTime.now().toIso8601String(),
        });
      });
      await _saveData();
    }
  }

  Future<void> _addSketch() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final title = await showDialog<String>(
        context: context,
        builder: (context) => _TitleDialog(),
      );

      if (title != null && title.isNotEmpty) {
        setState(() {
          _sketches.insert(0, {
            'id': DateTime.now().millisecondsSinceEpoch.toString(),
            'title': title,
            'imagePath': image.path,
            'date': DateTime.now().toIso8601String(),
          });
        });
        await _saveData();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📝 Saha Notları & Eskizler'),
        backgroundColor: Colors.green[700],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.notes), text: 'Notlar'),
            Tab(icon: Icon(Icons.brush), text: 'Eskizler'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _addNote();
          } else {
            _addSketch();
          }
        },
        icon: Icon(_tabController.index == 0 ? Icons.add : Icons.camera_alt),
        label: Text(_tabController.index == 0 ? 'Not Ekle' : 'Eskiz Ekle'),
        backgroundColor: Colors.green[700],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildNotesList(), _buildSketchesList()],
      ),
    );
  }

  Widget _buildNotesList() {
    if (_notes.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.note_add, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Henüz not yok',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: _notes.length,
      itemBuilder: (context, index) {
        final note = _notes[index];
        final date = DateTime.parse(note['date']);

        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: _getCategoryColor(note['category']),
                shape: BoxShape.circle,
              ),
              child: Icon(
                _getCategoryIcon(note['category']),
                color: Colors.white,
              ),
            ),
            title: Text(
              note['title'],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  note['content'],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '${date.day}.${date.month}.${date.year} - ${note['location']}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() => _notes.removeAt(index));
                _saveData();
              },
            ),
            onTap: () => _showNoteDetails(note),
          ),
        );
      },
    );
  }

  Widget _buildSketchesList() {
    if (_sketches.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.draw, size: 80, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'Henüz eskiz yok',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.8,
      ),
      itemCount: _sketches.length,
      itemBuilder: (context, index) {
        final sketch = _sketches[index];
        final date = DateTime.parse(sketch['date']);

        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () => _showSketchDetails(sketch),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Image.file(
                    File(sketch['imagePath']),
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  color: Colors.green[700],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        sketch['title'],
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${date.day}.${date.month}.${date.year}',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Keşif':
        return Colors.blue;
      case 'Analiz':
        return Colors.purple;
      case 'Gözlem':
        return Colors.orange;
      case 'Hipotez':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Keşif':
        return Icons.explore;
      case 'Analiz':
        return Icons.analytics;
      case 'Gözlem':
        return Icons.visibility;
      case 'Hipotez':
        return Icons.lightbulb;
      default:
        return Icons.note;
    }
  }

  void _showNoteDetails(Map<String, dynamic> note) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(note['category']),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getCategoryIcon(note['category']),
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          note['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          note['category'],
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Text(
                'Konum: ${note['location']}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                note['content'],
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSketchDetails(Map<String, dynamic> sketch) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text(sketch['title']),
            backgroundColor: Colors.green[700],
            actions: [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  Navigator.pop(context);
                  setState(() => _sketches.remove(sketch));
                  _saveData();
                },
              ),
            ],
          ),
          body: InteractiveViewer(
            child: Center(child: Image.file(File(sketch['imagePath']))),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

class _AddNoteDialog extends StatefulWidget {
  const _AddNoteDialog();

  @override
  State<_AddNoteDialog> createState() => _AddNoteDialogState();
}

class _AddNoteDialogState extends State<_AddNoteDialog> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  String _selectedCategory = 'Keşif';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Saha Notu'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Başlık',
                prefixIcon: Icon(Icons.title),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<String>(
              initialValue: _selectedCategory,
              decoration: const InputDecoration(
                labelText: 'Kategori',
                prefixIcon: Icon(Icons.category),
                border: OutlineInputBorder(),
              ),
              items: ['Keşif', 'Analiz', 'Gözlem', 'Hipotez']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (value) => setState(() => _selectedCategory = value!),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                labelText: 'Konum',
                prefixIcon: Icon(Icons.location_on),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Not İçeriği',
                prefixIcon: Icon(Icons.notes),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () {
            if (_titleController.text.isNotEmpty &&
                _contentController.text.isNotEmpty) {
              Navigator.pop(context, {
                'title': _titleController.text,
                'category': _selectedCategory,
                'location': _locationController.text,
                'content': _contentController.text,
              });
            }
          },
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}

class _TitleDialog extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  _TitleDialog();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Eskiz Başlığı'),
      content: TextField(
        controller: _controller,
        decoration: const InputDecoration(
          labelText: 'Başlık',
          border: OutlineInputBorder(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(context, _controller.text),
          child: const Text('Kaydet'),
        ),
      ],
    );
  }
}
