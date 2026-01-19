import '../database/app_database.dart';

class ExcavationSite {
  final String id;
  final String name;
  final String civilization;
  final int userLevel;
  final int artifactsFound;
  final int areasExplored;
  final List<String> discoveries;

  ExcavationSite({
    required this.id,
    required this.name,
    required this.civilization,
    required this.userLevel,
    required this.artifactsFound,
    required this.areasExplored,
    required this.discoveries,
  });

  factory ExcavationSite.fromMap(Map<String, dynamic> map) {
    return ExcavationSite(
      id: map['id'],
      name: map['site_id'],
      civilization: map['site_id'].toString().split('_').first,
      userLevel: map['user_level'] ?? 1,
      artifactsFound: map['artifacts_found'] ?? 0,
      areasExplored: map['areas_explored'] ?? 0,
      discoveries: (map['discoveries'] as String?)?.split(',') ?? [],
    );
  }
}

class VirtualExcavationService {
  Future<List<ExcavationSite>> getAllSites() async {
    final db = await AppDatabase().database;
    
    // Check if sites exist
    final existing = await db.query('excavation_progress');
    if (existing.isEmpty) {
      await insertSampleSites();
    }
    
    final results = await db.query('excavation_progress');
    return results.map((map) => ExcavationSite.fromMap(map)).toList();
  }

  Future<ExcavationSite?> getSite(String siteId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'excavation_progress',
      where: 'site_id = ?',
      whereArgs: [siteId],
    );
    if (results.isEmpty) return null;
    return ExcavationSite.fromMap(results.first);
  }

  Future<void> updateProgress(String siteId, int artifactsFound, int areasExplored, List<String> discoveries) async {
    final db = await AppDatabase().database;
    await db.update(
      'excavation_progress',
      {
        'artifacts_found': artifactsFound,
        'areas_explored': areasExplored,
        'discoveries': discoveries.join(','),
        'last_dig': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'site_id = ?',
      whereArgs: [siteId],
    );
  }

  Future<void> insertSampleSites() async {
    final db = await AppDatabase().database;
    
    final sites = [
      {'site_id': 'troy_excavation', 'user_level': 1},
      {'site_id': 'pompeii_excavation', 'user_level': 1},
      {'site_id': 'giza_excavation', 'user_level': 1},
      {'site_id': 'babylon_excavation', 'user_level': 1},
      {'site_id': 'machu_picchu_excavation', 'user_level': 1},
      {'site_id': 'angkor_wat_excavation', 'user_level': 1},
      {'site_id': 'petra_excavation', 'user_level': 1},
      {'site_id': 'ephesus_excavation', 'user_level': 1},
      {'site_id': 'teotihuacan_excavation', 'user_level': 1},
      {'site_id': 'stonehenge_excavation', 'user_level': 1},
    ];

    for (var site in sites) {
      await db.insert('excavation_progress', {
        'id': 'progress_${site['site_id']}',
        'site_id': site['site_id'],
        'user_level': site['user_level'],
        'artifacts_found': 0,
        'areas_explored': 0,
        'discoveries': '',
        'last_dig': DateTime.now().millisecondsSinceEpoch,
        'created_at': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }
}
