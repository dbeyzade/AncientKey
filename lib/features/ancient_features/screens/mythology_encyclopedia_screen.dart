import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/mythology_service.dart';

final mythologyProvider = FutureProvider<List<MythologyEntry>>((ref) async {
  final service = ref.watch(mythologyServiceProvider);
  return service.getAllEntries();
});

final mythologyFilterProvider = StateProvider<String?>((ref) => null);

class MythologyEncyclopediaScreen extends ConsumerWidget {
  const MythologyEncyclopediaScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mythologyAsync = ref.watch(mythologyProvider);
    final filter = ref.watch(mythologyFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mitoloji Ansiklopedisi'),
        elevation: 2,
        actions: [
          PopupMenuButton<String?>(
            icon: Icon(Icons.filter_list),
            onSelected: (value) {
              ref.read(mythologyFilterProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              PopupMenuItem(value: null, child: Text('Tümü')),
              PopupMenuItem(value: 'Yunan', child: Text('Yunan')),
              PopupMenuItem(value: 'Mısır', child: Text('Mısır')),
              PopupMenuItem(value: 'Norse', child: Text('Norse')),
              PopupMenuItem(value: 'Hindu', child: Text('Hindu')),
              PopupMenuItem(value: 'Mezopotamya', child: Text('Mezopotamya')),
            ],
          ),
        ],
      ),
      body: mythologyAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
        data: (entries) {
          final filtered = filter == null
              ? entries
              : entries.where((e) => e.civilization == filter).toList();

          if (filtered.isEmpty) {
            return Center(child: Text('Henüz veri yok'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: filtered.length,
            itemBuilder: (context, index) {
              final entry = filtered[index];
              return _DeityCard(entry: entry);
            },
          );
        },
      ),
    );
  }
}

class _DeityCard extends StatelessWidget {
  final MythologyEntry entry;

  const _DeityCard({required this.entry});

  Color _getCivilizationColor(String civilization) {
    final colors = {
      'Yunan': Colors.blue,
      'Mısır': Colors.amber,
      'Norse': Colors.blueGrey,
      'Hindu': Colors.orange,
      'Mezopotamya': Colors.deepPurple,
    };
    return colors[civilization] ?? Colors.grey;
  }

  IconData _getCivilizationIcon(String civilization) {
    final icons = {
      'Yunan': Icons.account_balance,
      'Mısır': Icons.change_history,
      'Norse': Icons.shield,
      'Hindu': Icons.self_improvement,
      'Mezopotamya': Icons.apartment,
    };
    return icons[civilization] ?? Icons.auto_awesome;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCivilizationColor(entry.civilization);

    return Card(
      margin: EdgeInsets.only(bottom: 16),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => DeityDetailScreen(entry: entry),
            ),
          );
        },
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withOpacity(0.1),
                color.withOpacity(0.05),
              ],
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  _getCivilizationIcon(entry.civilization),
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.deityName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        entry.civilization,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
                    if (entry.role != null) ...[
                      SizedBox(height: 8),
                      Text(
                        entry.role!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}

class DeityDetailScreen extends StatelessWidget {
  final MythologyEntry entry;

  const DeityDetailScreen({super.key, required this.entry});

  Color _getCivilizationColor(String civilization) {
    final colors = {
      'Yunan': Colors.blue,
      'Mısır': Colors.amber,
      'Norse': Colors.blueGrey,
      'Hindu': Colors.orange,
      'Mezopotamya': Colors.deepPurple,
    };
    return colors[civilization] ?? Colors.grey;
  }

  IconData _getCivilizationIcon(String civilization) {
    final icons = {
      'Yunan': Icons.account_balance,
      'Mısır': Icons.change_history,
      'Norse': Icons.shield,
      'Hindu': Icons.self_improvement,
      'Mezopotamya': Icons.apartment,
    };
    return icons[civilization] ?? Icons.auto_awesome;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getCivilizationColor(entry.civilization);

    return Scaffold(
      appBar: AppBar(
        title: Text(entry.deityName),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    color.withOpacity(0.8),
                    color.withOpacity(0.5),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _getCivilizationIcon(entry.civilization),
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      entry.deityName,
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      entry.civilization,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  if (entry.role != null) ...[
                    SizedBox(height: 16),
                    Text(
                      'Rol ve Sorumluluklar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      entry.role!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[800],
                      ),
                    ),
                  ],
                  if (entry.description != null) ...[
                    SizedBox(height: 20),
                    Text(
                      'Açıklama',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      entry.description!,
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.6,
                        color: Colors.grey[700],
                      ),
                    ),
                  ],
                  if (entry.symbolsList.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      'Semboller',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: entry.symbolsList.map((symbol) {
                        return Chip(
                          avatar: Icon(Icons.star, color: color, size: 18),
                          label: Text(symbol),
                          backgroundColor: color.withOpacity(0.1),
                          labelStyle: TextStyle(
                            fontSize: 14,
                            color: color,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                  if (entry.mythsList.isNotEmpty) ...[
                    SizedBox(height: 20),
                    Text(
                      'İlgili Mitler',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 12),
                    ...entry.mythsList.map((myth) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.auto_stories, color: color, size: 20),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                myth,
                                style: TextStyle(
                                  fontSize: 15,
                                  height: 1.5,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
