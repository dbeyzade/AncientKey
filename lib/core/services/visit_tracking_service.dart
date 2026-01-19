import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import 'package:sqflite/sqflite.dart' show Sqflite;
import '../database/app_database.dart';

class VisitedPlace {
  final String id;
  final String mapId;
  final LatLng location;
  final DateTime visitedAt;

  VisitedPlace({
    required this.id,
    required this.mapId,
    required this.location,
    required this.visitedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'map_id': mapId,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'visited_at': visitedAt.millisecondsSinceEpoch,
    };
  }

  factory VisitedPlace.fromMap(Map<String, dynamic> map) {
    return VisitedPlace(
      id: map['id'],
      mapId: map['map_id'],
      location: LatLng(map['latitude'], map['longitude']),
      visitedAt: DateTime.fromMillisecondsSinceEpoch(map['visited_at']),
    );
  }
}

class VisitTrackingService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  VisitTrackingService(this._db);

  Future<void> markPlaceAsVisited(String mapId, LatLng location) async {
    final db = await _db.database;
    
    // Check if already visited
    final existing = await db.query(
      'visited_places',
      where: 'map_id = ? AND latitude = ? AND longitude = ?',
      whereArgs: [mapId, location.latitude, location.longitude],
    );

    if (existing.isEmpty) {
      await db.insert('visited_places', {
        'id': _uuid.v4(),
        'map_id': mapId,
        'latitude': location.latitude,
        'longitude': location.longitude,
        'visited_at': DateTime.now().millisecondsSinceEpoch,
      });

      // Update user progress
      await _updateProgress();
    }
  }

  Future<bool> isPlaceVisited(String mapId, LatLng location) async {
    final db = await _db.database;
    final result = await db.query(
      'visited_places',
      where: 'map_id = ? AND latitude = ? AND longitude = ?',
      whereArgs: [mapId, location.latitude, location.longitude],
    );
    return result.isNotEmpty;
  }

  Future<List<VisitedPlace>> getVisitedPlaces() async {
    final db = await _db.database;
    final result = await db.query('visited_places', orderBy: 'visited_at DESC');
    return result.map((map) => VisitedPlace.fromMap(map)).toList();
  }

  Future<List<VisitedPlace>> getVisitedPlacesByMapId(String mapId) async {
    final db = await _db.database;
    final result = await db.query(
      'visited_places',
      where: 'map_id = ?',
      whereArgs: [mapId],
      orderBy: 'visited_at DESC',
    );
    return result.map((map) => VisitedPlace.fromMap(map)).toList();
  }

  Future<int> getTotalVisitedPlaces() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM visited_places');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> _updateProgress() async {
    final db = await _db.database;
    final visitedCount = await getTotalVisitedPlaces();
    
    await db.update(
      'user_progress',
      {'places_visited': visitedCount},
      where: 'id = ?',
      whereArgs: ['default'],
    );
  }

  Future<int> getUniqueVisitedMapsCount() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(DISTINCT map_id) as count FROM visited_places');
    return Sqflite.firstIntValue(result) ?? 0;
  }
}

final visitTrackingServiceProvider = Provider<VisitTrackingService>((ref) {
  return VisitTrackingService(AppDatabase());
});
