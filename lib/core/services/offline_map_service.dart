import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class OfflineMapService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  OfflineMapService(this._db);

  Future<bool> isMapDownloaded(String mapId) async {
    final db = await _db.database;
    final result = await db.query(
      'offline_maps',
      where: 'map_id = ?',
      whereArgs: [mapId],
    );
    return result.isNotEmpty;
  }

  Future<void> saveOfflineMap(String mapId, String filePath) async {
    final db = await _db.database;
    await db.insert(
      'offline_maps',
      {
        'id': _uuid.v4(),
        'map_id': mapId,
        'file_path': filePath,
        'downloaded_at': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<String?> getOfflineMapPath(String mapId) async {
    final db = await _db.database;
    final result = await db.query(
      'offline_maps',
      where: 'map_id = ?',
      whereArgs: [mapId],
    );
    
    if (result.isEmpty) return null;
    return result.first['file_path'] as String;
  }

  Future<List<Map<String, dynamic>>> getAllOfflineMaps() async {
    final db = await _db.database;
    return await db.query('offline_maps');
  }

  Future<void> deleteOfflineMap(String mapId) async {
    final db = await _db.database;
    await db.delete(
      'offline_maps',
      where: 'map_id = ?',
      whereArgs: [mapId],
    );
  }
}

final offlineMapServiceProvider = Provider<OfflineMapService>((ref) {
  return OfflineMapService(AppDatabase());
});
