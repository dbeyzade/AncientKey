import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

class UserComment {
  final String id;
  final String mapId;
  final String comment;
  final int rating;
  final DateTime createdAt;

  UserComment({
    required this.id,
    required this.mapId,
    required this.comment,
    required this.rating,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'map_id': mapId,
      'comment': comment,
      'rating': rating,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory UserComment.fromMap(Map<String, dynamic> map) {
    return UserComment(
      id: map['id'],
      mapId: map['map_id'],
      comment: map['comment'],
      rating: map['rating'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class CommentService {
  final AppDatabase _db;
  final _uuid = const Uuid();

  CommentService(this._db);

  Future<void> addComment(String mapId, String comment, int rating) async {
    final db = await _db.database;
    await db.insert('user_comments', {
      'id': _uuid.v4(),
      'map_id': mapId,
      'comment': comment,
      'rating': rating,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<List<UserComment>> getCommentsByMapId(String mapId) async {
    final db = await _db.database;
    final result = await db.query(
      'user_comments',
      where: 'map_id = ?',
      whereArgs: [mapId],
      orderBy: 'created_at DESC',
    );
    return result.map((map) => UserComment.fromMap(map)).toList();
  }

  Future<List<UserComment>> getAllComments() async {
    final db = await _db.database;
    final result = await db.query('user_comments', orderBy: 'created_at DESC');
    return result.map((map) => UserComment.fromMap(map)).toList();
  }

  Future<void> deleteComment(String commentId) async {
    final db = await _db.database;
    await db.delete(
      'user_comments',
      where: 'id = ?',
      whereArgs: [commentId],
    );
  }

  Future<double> getAverageRating(String mapId) async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT AVG(rating) as avg_rating FROM user_comments WHERE map_id = ?',
      [mapId],
    );
    
    if (result.isEmpty || result.first['avg_rating'] == null) return 0.0;
    return (result.first['avg_rating'] as num).toDouble();
  }
}

final commentServiceProvider = Provider<CommentService>((ref) {
  return CommentService(AppDatabase());
});
