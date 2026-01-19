import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:latlong2/latlong.dart';
import '../database/app_database.dart';

class UserNote {
  final String id;
  final String mapId;
  final String note;
  final LatLng location;
  final DateTime createdAt;

  UserNote({
    required this.id,
    required this.mapId,
    required this.note,
    required this.location,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'map_id': mapId,
      'note': note,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserNote.fromMap(Map<String, dynamic> map) {
    return UserNote(
      id: map['id'],
      mapId: map['map_id'],
      note: map['note'],
      location: LatLng(map['latitude'], map['longitude']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class NoteService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  NoteService(this._db);

  Future<void> addNote(String mapId, String note, LatLng location) async {
    final db = await _db.database;
    await db.insert('user_notes', {
      'id': _uuid.v4(),
      'map_id': mapId,
      'note': note,
      'latitude': location.latitude,
      'longitude': location.longitude,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<UserNote>> getNotesByMapId(String mapId) async {
    final db = await _db.database;
    final result = await db.query(
      'user_notes',
      where: 'map_id = ?',
      whereArgs: [mapId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => UserNote.fromMap(map)).toList();
  }

  Future<List<UserNote>> getAllNotes() async {
    final db = await _db.database;
    final result = await db.query('user_notes', orderBy: 'created_at DESC');
    return result.map((map) => UserNote.fromMap(map)).toList();
  }

  Future<void> deleteNote(String noteId) async {
    final db = await _db.database;
    await db.delete(
      'user_notes',
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }

  Future<void> updateNote(String noteId, String newNote) async {
    final db = await _db.database;
    await db.update(
      'user_notes',
      {'note': newNote},
      where: 'id = ?',
      whereArgs: [noteId],
    );
  }
}

final noteServiceProvider = Provider<NoteService>((ref) {
  return NoteService(AppDatabase());
});
