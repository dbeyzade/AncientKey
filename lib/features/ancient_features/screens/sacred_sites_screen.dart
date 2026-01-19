import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/services/sacred_sites_service.dart';

final sacredSitesProvider = FutureProvider<List<SacredSite>>((ref) async {
  return SacredSitesService().getAllSites();
});

class SacredSitesScreen extends ConsumerWidget {
  const SacredSitesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sitesAsync = ref.watch(sacredSitesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Kutsal Mekanlar'),
        elevation: 2,
      ),
      body: sitesAsync.when(
        loading: () => Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Hata: $error')),
        data: (sites) {
          if (sites.isEmpty) {
            return Center(child: Text('Henüz veri yok'));
          }

          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: sites.length,
            itemBuilder: (context, index) {
              final site = sites[index];
              return _SacredSiteCard(site: site);
            },
          );
        },
      ),
    );
  }
}

class _SacredSiteCard extends StatelessWidget {
  final SacredSite site;

  const _SacredSiteCard({required this.site});

  Color _getReligionColor(String religion) {
    if (religion.contains('İslam')) return Colors.green;
    if (religion.contains('Hristiyanlık')) return Colors.blue;
    if (religion.contains('Yahudilik')) return Colors.indigo;
    if (religion.contains('Hinduizm')) return Colors.orange;
    if (religion.contains('Budizm')) return Colors.amber;
    if (religion.contains('Yunan')) return Colors.cyan;
    if (religion.contains('Mısır')) return Colors.deepOrange;
    if (religion.contains('Şintoizm')) return Colors.red;
    if (religion.contains('Sihizm')) return Colors.yellow[700]!;
    return Colors.purple;
  }

  IconData _getReligionIcon(String religion) {
    if (religion.contains('İslam')) return Icons.mosque;
    if (religion.contains('Hristiyanlık')) return Icons.church;
    if (religion.contains('Yahudilik')) return Icons.star_border;
    if (religion.contains('Hinduizm')) return Icons.temple_hindu;
    if (religion.contains('Budizm')) return Icons.self_improvement;
    if (religion.contains('Yunan')) return Icons.account_balance;
    if (religion.contains('Mısır')) return Icons.change_history;
    if (religion.contains('Şintoizm')) return Icons.festival;
    return Icons.place;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getReligionColor(site.religion);

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
              builder: (_) => SacredSiteDetailScreen(site: site),
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
                  _getReligionIcon(site.religion),
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
                      site.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey[600]),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            site.location,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        site.religion,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: color,
                        ),
                      ),
                    ),
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

class SacredSiteDetailScreen extends StatelessWidget {
  final SacredSite site;

  const SacredSiteDetailScreen({super.key, required this.site});

  Color _getReligionColor(String religion) {
    if (religion.contains('İslam')) return Colors.green;
    if (religion.contains('Hristiyanlık')) return Colors.blue;
    if (religion.contains('Yahudilik')) return Colors.indigo;
    if (religion.contains('Hinduizm')) return Colors.orange;
    if (religion.contains('Budizm')) return Colors.amber;
    if (religion.contains('Yunan')) return Colors.cyan;
    if (religion.contains('Mısır')) return Colors.deepOrange;
    if (religion.contains('Şintoizm')) return Colors.red;
    if (religion.contains('Sihizm')) return Colors.yellow[700]!;
    return Colors.purple;
  }

  IconData _getReligionIcon(String religion) {
    if (religion.contains('İslam')) return Icons.mosque;
    if (religion.contains('Hristiyanlık')) return Icons.church;
    if (religion.contains('Yahudilik')) return Icons.star_border;
    if (religion.contains('Hinduizm')) return Icons.temple_hindu;
    if (religion.contains('Budizm')) return Icons.self_improvement;
    if (religion.contains('Yunan')) return Icons.account_balance;
    if (religion.contains('Mısır')) return Icons.change_history;
    if (religion.contains('Şintoizm')) return Icons.festival;
    return Icons.place;
  }

  @override
  Widget build(BuildContext context) {
    final color = _getReligionColor(site.religion);

    return Scaffold(
      appBar: AppBar(
        title: Text(site.name),
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
                      _getReligionIcon(site.religion),
                      size: 80,
                      color: Colors.white,
                    ),
                    SizedBox(height: 12),
                    Text(
                      site.name,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
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
                  Row(
                    children: [
                      Icon(Icons.location_on, color: color, size: 20),
                      SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          site.location,
                          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      site.religion,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                  ),
                  if (site.builtYear != null) ...[
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 18, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text(
                          'İnşa: ${site.builtYear! < 0 ? "MÖ ${-site.builtYear!}" : "MS ${site.builtYear}"}',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (site.architectureStyle != null) ...[
                    SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.architecture, size: 18, color: Colors.grey[600]),
                        SizedBox(width: 8),
                        Text(
                          site.architectureStyle!,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (site.significance != null) ...[
                    SizedBox(height: 20),
                    Text(
                      'Tarihi Önemi',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: color.withOpacity(0.3)),
                      ),
                      child: Text(
                        site.significance!,
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.6,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                  ],
                  if (site.rituals != null) ...[
                    SizedBox(height: 20),
                    Text(
                      'Ritüeller ve Törenler',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.amber[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.amber[200]!),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.auto_awesome, color: Colors.amber[700], size: 24),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              site.rituals!,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.6,
                                color: Colors.grey[800],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
