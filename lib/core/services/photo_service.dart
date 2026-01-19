import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import '../database/app_database.dart';

class UserPhoto {
  final String id;
  final String mapId;
  final String filePath;
  final LatLng location;
  final DateTime createdAt;

  UserPhoto({
    required this.id,
    required this.mapId,
    required this.filePath,
    required this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'map_id': mapId,
      'file_path': filePath,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserPhoto.fromMap(Map<String, dynamic> map) {
    return UserPhoto(
      id: map['id'],
      mapId: map['map_id'],
      filePath: map['file_path'],
      location: LatLng(map['latitude'], map['longitude']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class PhotoService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  PhotoService(this._db);

  Future<void> savePhoto(String mapId, String filePath, LatLng location) async {
    final db = await _db.database;
    await db.insert('user_photos', {
      'id': _uuid.v4(),
      'map_id': mapId,
      'file_path': filePath,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<UserPhoto>> getPhotosByMapId(String mapId) async {
    final db = await _db.database;
    final result = await db.query(
      'user_photos',
      where: 'map_id = ?',
      whereArgs: [mapId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => UserPhoto.fromMap(map)).toList();
  }

  Future<List<UserPhoto>> getAllPhotos() async {
    final db = await _db.database;
    final result = await db.query('user_photos', orderBy: 'created_at DESC');
    return result.map((map) => UserPhoto.fromMap(map)).toList();
  }

  Future<void> deletePhoto(String photoId) async {
    final db = await _db.database;
    await db.delete(
      'user_photos',
      where: 'id = ?',
      whereArgs: [photoId],
    );
  }
}

final photoServiceProvider = Provider<PhotoService>((ref) {
  return PhotoService(AppDatabase());
});
