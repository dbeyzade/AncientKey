import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class AudioGuide {
  final String id;
  final String mapId;
  final String title;
  final String filePath;
  final int duration;
  final bool downloaded;

  AudioGuide({
    required this.id,
    required this.mapId,
    required this.title,
    required this.filePath,
    required this.duration,
    required this.downloaded,
  });

  factory AudioGuide.fromMap(Map<String, dynamic> map) {
    return AudioGuide(
      id: map['id'],
      mapId: map['map_id'],
      title: map['title'],
      filePath: map['file_path'],
      duration: map['duration'],
      downloaded: map['downloaded'] == 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'map_id': mapId,
      'title': title,
      'file_path': filePath,
      'duration': duration,
      'downloaded': downloaded ? 1 : 0,
    };
  }
}

class AudioGuideService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  AudioGuideService(this._db);

  Future<void> addAudioGuide({
    required String mapId,
    required String title,
    required String filePath,
    required int duration,
  }) async {
    final db = await _db.database;
    await db.insert('audio_guides', {
      'id': _uuid.v4(),
      'map_id': mapId,
      'title': title,
      'file_path': filePath,
      'duration': duration,
      'downloaded': 0,
    });
  }

  Future<List<AudioGuide>> getAudioGuidesByMapId(String mapId) async {
    final db = await _db.database;
    final existing = await db.query(
      'audio_guides',
      where: 'map_id = ?',
      whereArgs: [mapId],
    );

    if (existing.isEmpty) {
      await _insertSampleGuides(mapId);
    }

    final result = await db.query(
      'audio_guides',
      where: 'map_id = ?',
      whereArgs: [mapId],
    );
    return result.map((map) => AudioGuide.fromMap(map)).toList();
  }

  Future<void> _insertSampleGuides(String mapId) async {
    final db = await _db.database;
    final samples = [
      {
        'title': 'History - Kısa Rehber 1 (CC0)',
        'file_path': 'https://upload.wikimedia.org/wikipedia/commons/3/38/LL-Q1860_%28eng%29-Wodencafe-history.wav',
        'duration': 1,
      },
      {
        'title': 'History - Kısa Rehber 2 (CC0)',
        'file_path': 'https://upload.wikimedia.org/wikipedia/commons/4/4b/LL-Q1860_%28eng%29-Grendelkhan-history.wav',
        'duration': 1,
      },
      {
        'title': 'Oral History - Örnek (CC0)',
        'file_path': 'https://upload.wikimedia.org/wikipedia/commons/8/84/Oral_history_interview_with_Ernest_T._Gross_about_subcamp_KZ_Kaufering_III_-_Collections_-_Ausschnitte.ogg',
        'duration': 1113,
      },
    ];

    for (final sample in samples) {
      await db.insert('audio_guides', {
        'id': _uuid.v4(),
        'map_id': mapId,
        'title': sample['title'],
        'file_path': sample['file_path'],
        'duration': sample['duration'],
        'downloaded': 0,
      });
    }
  }

  Future<void> markAsDownloaded(String audioGuideId, String localPath) async {
    final db = await _db.database;
    await db.update(
      'audio_guides',
      {
        'downloaded': 1,
        'file_path': localPath,
      },
      where: 'id = ?',
      whereArgs: [audioGuideId],
    );
  }

  Future<void> deleteAudioGuide(String audioGuideId) async {
    final db = await _db.database;
    await db.delete(
      'audio_guides',
      where: 'id = ?',
      whereArgs: [audioGuideId],
    );
  }
}

final audioGuideServiceProvider = Provider<AudioGuideService>((ref) {
  return AudioGuideService(AppDatabase());
});
