import 'package:flutter/material.dart';

class RestorationPlannerScreen extends StatefulWidget {
  const RestorationPlannerScreen({super.key});

  @override
  State<RestorationPlannerScreen> createState() =>
      _RestorationPlannerScreenState();
}

class _RestorationPlannerScreenState extends State<RestorationPlannerScreen> {
  final List<Map<String, dynamic>> _projects = [];

  void _addProject() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => const _AddProjectDialog(),
    );

    if (result != null) {
      setState(() {
        _projects.insert(0, {
          ...result,
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'createdAt': DateTime.now(),
          'progress': 0,
        });
      });
    }
  }

  void _updateProgress(int index, int progress) {
    setState(() {
      _projects[index]['progress'] = progress;
    });
  }

  Color _getStatusColor(int progress) {
    if (progress == 100) return Colors.green;
    if (progress >= 50) return Colors.orange;
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🏛️ Restorasyon Planlayıcı'),
        backgroundColor: Colors.brown[700],
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Restorasyon Planlama'),
                  content: const Text(
                    'Tarihi eserlerin restorasyon süreçlerini planlayın ve takip edin.\n\n'
                    '• Proje oluşturun\n'
                    '• İlerlemeyi izleyin\n'
                    '• Görevleri yönetin\n'
                    '• Maliyetleri hesaplayın',
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
        onPressed: _addProject,
        icon: const Icon(Icons.add),
        label: const Text('Yeni Proje'),
        backgroundColor: Colors.brown[700],
      ),
      body: _projects.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.architecture, size: 80, color: Colors.grey[400]),
                  const SizedBox(height: 16),
                  Text(
                    'Henüz proje yok',
                    style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'İlk restorasyon projesini oluştur!',
                    style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _projects.length,
              itemBuilder: (context, index) {
                final project = _projects[index];
                final progress = project['progress'] as int;
                final statusColor = _getStatusColor(progress);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  elevation: 4,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [statusColor, statusColor.withOpacity(0.7)],
                          ),
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(12),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                _getTypeIcon(project['type']),
                                color: statusColor,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project['name'],
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    project['type'],
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                setState(() => _projects.removeAt(index));
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Durum:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(_getStatusText(progress)),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'İlerleme:',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      '$progress%',
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: statusColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            LinearProgressIndicator(
                              value: progress / 100,
                              backgroundColor: Colors.grey[300],
                              valueColor: AlwaysStoppedAnimation<Color>(
                                statusColor,
                              ),
                              minHeight: 8,
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: OutlinedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => _ProgressDialog(
                                          currentProgress: progress,
                                          onUpdate: (newProgress) {
                                            _updateProgress(index, newProgress);
                                          },
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.edit),
                                    label: const Text('İlerlemeyi Güncelle'),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: FilledButton.icon(
                                    onPressed: () {
                                      _showProjectDetails(project);
                                    },
                                    icon: const Icon(Icons.visibility),
                                    label: const Text('Detaylar'),
                                    style: FilledButton.styleFrom(
                                      backgroundColor: statusColor,
                                    ),
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

  IconData _getTypeIcon(String type) {
    switch (type) {
      case 'Seramik':
        return Icons.local_florist;
      case 'Heykel':
        return Icons.account_balance;
      case 'Bina':
        return Icons.architecture;
      case 'Mozaik':
        return Icons.grid_on;
      default:
        return Icons.category;
    }
  }

  String _getStatusText(int progress) {
    if (progress == 0) return 'Başlamadı';
    if (progress < 25) return 'Planlama';
    if (progress < 50) return 'Hazırlık';
    if (progress < 75) return 'Restorasyon';
    if (progress < 100) return 'Tamamlanıyor';
    return 'Tamamlandı';
  }

  void _showProjectDetails(Map<String, dynamic> project) {
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
              Text(
                project['name'],
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              _buildDetailRow('Tür', project['type']),
              _buildDetailRow('Öncelik', project['priority']),
              _buildDetailRow('Durum', _getStatusText(project['progress'])),
              _buildDetailRow('İlerleme', '${project['progress']}%'),
              const SizedBox(height: 24),
              const Text(
                'Önerilen Adımlar:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              ..._getSteps(project['type']).map(
                (step) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: Colors.brown[700],
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(step)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }

  List<String> _getSteps(String type) {
    return [
      'Ön inceleme ve dokümantasyon',
      'Hasar tespiti ve analiz',
      'Restorasyon planının hazırlanması',
      'Malzeme ve teknik seçimi',
      'Uygulama ve işleme',
      'Son kontroller ve koruma',
    ];
  }
}

class _AddProjectDialog extends StatefulWidget {
  const _AddProjectDialog();

  @override
  State<_AddProjectDialog> createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<_AddProjectDialog> {
  final TextEditingController _nameController = TextEditingController();
  String _selectedType = 'Seramik';
  String _selectedPriority = 'Orta';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Yeni Restorasyon Projesi'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Proje Adı',
              prefixIcon: Icon(Icons.title),
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Eser Türü',
              prefixIcon: Icon(Icons.category),
              border: OutlineInputBorder(),
            ),
            items: ['Seramik', 'Heykel', 'Bina', 'Mozaik', 'Diğer']
                .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                .toList(),
            onChanged: (value) => setState(() => _selectedType = value!),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            initialValue: _selectedPriority,
            decoration: const InputDecoration(
              labelText: 'Öncelik',
              prefixIcon: Icon(Icons.priority_high),
              border: OutlineInputBorder(),
            ),
            items: ['Düşük', 'Orta', 'Yüksek', 'Acil']
                .map(
                  (priority) =>
                      DropdownMenuItem(value: priority, child: Text(priority)),
                )
                .toList(),
            onChanged: (value) => setState(() => _selectedPriority = value!),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              Navigator.pop(context, {
                'name': _nameController.text,
                'type': _selectedType,
                'priority': _selectedPriority,
              });
            }
          },
          child: const Text('Oluştur'),
        ),
      ],
    );
  }
}

class _ProgressDialog extends StatefulWidget {
  final int currentProgress;
  final Function(int) onUpdate;

  const _ProgressDialog({
    required this.currentProgress,
    required this.onUpdate,
  });

  @override
  State<_ProgressDialog> createState() => _ProgressDialogState();
}

class _ProgressDialogState extends State<_ProgressDialog> {
  late double _progress;

  @override
  void initState() {
    super.initState();
    _progress = widget.currentProgress.toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('İlerlemeyi Güncelle'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${_progress.toInt()}%',
            style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _progress,
            min: 0,
            max: 100,
            divisions: 20,
            label: '${_progress.toInt()}%',
            onChanged: (value) => setState(() => _progress = value),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('İptal'),
        ),
        FilledButton(
          onPressed: () {
            widget.onUpdate(_progress.toInt());
            Navigator.pop(context);
          },
          child: const Text('Güncelle'),
        ),
      ],
    );
  }
}
