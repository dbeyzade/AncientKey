import 'package:flutter/material.dart';
import 'package:ancientkey/core/theme/app_theme.dart';
import 'package:ancientkey/core/widgets/cyber_background.dart';

class _ResearchProject {
  final String id;
  final String title;
  final String description;
  final String category;
  final int progress;
  final IconData icon;
  final int participants;
  final bool completed;

  _ResearchProject({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.progress,
    required this.icon,
    required this.participants,
    required this.completed,
  });
}

class ResearchProjectsScreen extends StatefulWidget {
  const ResearchProjectsScreen({super.key});

  @override
  State<ResearchProjectsScreen> createState() => _ResearchProjectsScreenState();
}

class _ResearchProjectsScreenState extends State<ResearchProjectsScreen> {
  late List<_ResearchProject> projects;
  String _selectedFilter = 'all';

  @override
  void initState() {
    super.initState();
    projects = [
      _ResearchProject(
        id: '1',
        title: 'Antik Yazılar Dokümantasyonu',
        description: 'Hieroglif ve Çivi Yazısını dijital formatta kayıt edin',
        category: 'linguistics',
        progress: 65,
        icon: Icons.description,
        participants: 234,
        completed: false,
      ),
      _ResearchProject(
        id: '2',
        title: 'Arkeolojik Buluntuları Katalog',
        description: 'Müze koleksiyonlarını dijital katalogda düzenleyin',
        category: 'archaeology',
        progress: 42,
        icon: Icons.inventory_2,
        participants: 156,
        completed: false,
      ),
      _ResearchProject(
        id: '3',
        title: 'Antik Hastalıklar Araştırması',
        description: 'Eski dönem tıbbı hakkında veri toplama',
        category: 'medicine',
        progress: 88,
        icon: Icons.local_hospital,
        participants: 89,
        completed: false,
      ),
      _ResearchProject(
        id: '4',
        title: 'Ticari Yollar Haritalandırması',
        description: 'İpek Yolu ve ticari ağları model leyin',
        category: 'geography',
        progress: 71,
        icon: Icons.location_on,
        participants: 198,
        completed: false,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Araştırma Projeleri'),
        backgroundColor: Colors.black87,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const CyberBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          AppTheme.neonPink.withOpacity(0.2),
                          Colors.purple.withOpacity(0.1),
                        ],
                      ),
                      border: Border.all(
                        color: AppTheme.neonPink.withOpacity(0.3),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.trending_up,
                            color: AppTheme.neonPink,
                            size: 32,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Katıl & Katkı Yap',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'Dünya çapında araştırmalara dil çıkış bilim sever olarak katılın',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _StatBox(
                        icon: Icons.people,
                        value:
                            '${projects.fold<int>(0, (sum, p) => sum + p.participants)}',
                        label: 'Katılımcı',
                      ),
                      _StatBox(
                        icon: Icons.folder,
                        value: '${projects.length}',
                        label: 'Proje',
                      ),
                      _StatBox(
                        icon: Icons.check_circle,
                        value: '${projects.where((p) => p.completed).length}',
                        label: 'Tamamlanan',
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Filters
                  const Text(
                    'Filtrele',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  _buildFilterButtons(),

                  const SizedBox(height: 24),

                  // Projects
                  const Text(
                    'Aktif Projeler',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  ..._buildProjectCards(),

                  const SizedBox(height: 24),
                  // Create Project Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        _showCreateProjectDialog();
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Yeni Proje Öner'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.neonPink.withOpacity(0.2),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButtons() {
    final filters = [
      ('all', 'Tümü'),
      ('archaeology', 'Arkeoloji'),
      ('linguistics', 'Dil Bilim'),
      ('medicine', 'Tıp Tarihi'),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: filters
            .map(
              (filter) => Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter.$1;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _selectedFilter == filter.$1
                            ? AppTheme.neonPink.withOpacity(0.5)
                            : AppTheme.neonPink.withOpacity(0.2),
                      ),
                      color: _selectedFilter == filter.$1
                          ? AppTheme.neonPink.withOpacity(0.15)
                          : Colors.white.withOpacity(0.03),
                    ),
                    child: Text(
                      filter.$2,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: _selectedFilter == filter.$1
                            ? AppTheme.neonPink
                            : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  List<Widget> _buildProjectCards() {
    final filtered = _selectedFilter == 'all'
        ? projects
        : projects.where((p) => p.category == _selectedFilter).toList();

    return filtered
        .map(
          (project) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: GestureDetector(
              onTap: () {
                _showProjectDetails(project);
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: AppTheme.neonPink.withOpacity(0.2)),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.05),
                      Colors.white.withOpacity(0.02),
                    ],
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withOpacity(0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            project.icon,
                            color: AppTheme.neonPink,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                project.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                project.description,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.5),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Progress Bar
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'İlerleme',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.white.withOpacity(0.6),
                              ),
                            ),
                            Text(
                              '${project.progress}%',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppTheme.neonPink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: project.progress / 100,
                            minHeight: 6,
                            backgroundColor: AppTheme.neonPink.withOpacity(0.1),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppTheme.neonPink.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Participants
                    Row(
                      children: [
                        Icon(
                          Icons.people_outline,
                          size: 16,
                          color: Colors.white.withOpacity(0.5),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '${project.participants} katılımcı',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.5),
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.neonPink.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Katıl',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppTheme.neonPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }

  void _showProjectDetails(_ResearchProject project) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Row(
          children: [
            Icon(project.icon, color: AppTheme.neonPink),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                project.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(project.description, style: const TextStyle(fontSize: 14)),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: AppTheme.neonPink.withOpacity(0.1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'İlerleme',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${project.progress}%',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neonPink,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Katılımcı',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withOpacity(0.6),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          project.participants.toString(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.neonPink,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Kapat'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${project.title} projesine katıldınız!'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonPink),
            child: const Text('Katıl'),
          ),
        ],
      ),
    );
  }

  void _showCreateProjectDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: const Row(
          children: [
            Icon(Icons.add, color: AppTheme.neonPink),
            SizedBox(width: 8),
            Text('Yeni Proje Öner'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Proje adı',
                isDense: true,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: const InputDecoration(
                hintText: 'Açıklama',
                isDense: true,
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('İptal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Proje öneriniz gönderildi!'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.neonPink),
            child: const Text('Gönder'),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;

  const _StatBox({
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withOpacity(0.05),
        border: Border.all(color: AppTheme.neonPink.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppTheme.neonPink, size: 24),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
