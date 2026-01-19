import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

final artifactServiceProvider = Provider((ref) => ArtifactService());

class Artifact {
  final String id;
  final String mapId;
  final String name;
  final String? description;
  final String? period;
  final String? material;
  final int? discoveredYear;
  final String? currentLocation;
  final String? imageUrl;
  final String? historicalSignificance;
  final DateTime createdAt;

  Artifact({
    required this.id,
    required this.mapId,
    required this.name,
    this.description,
    this.period,
    this.material,
    this.discoveredYear,
    this.currentLocation,
    this.imageUrl,
    this.historicalSignificance,
    required this.createdAt,
  });

  factory Artifact.fromMap(Map<String, dynamic> map) {
    return Artifact(
      id: map['id'],
      mapId: map['map_id'],
      name: map['name'],
      description: map['description'],
      period: map['period'],
      material: map['material'],
      discoveredYear: map['discovered_year'],
      currentLocation: map['current_location'],
      imageUrl: map['image_url'],
      historicalSignificance: map['historical_significance'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}

class ArtifactService {
  final _uuid = const Uuid();

  Future<void> addArtifact(Artifact artifact) async {
    final db = await AppDatabase().database;
    await db.insert('artifacts', {
      'id': artifact.id,
      'map_id': artifact.mapId,
      'name': artifact.name,
      'description': artifact.description,
      'period': artifact.period,
      'material': artifact.material,
      'discovered_year': artifact.discoveredYear,
      'current_location': artifact.currentLocation,
      'image_url': artifact.imageUrl,
      'historical_significance': artifact.historicalSignificance,
      'created_at': artifact.createdAt.millisecondsSinceEpoch,
    });
  }

  Future<List<Artifact>> getArtifactsForMap(String mapId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'artifacts',
      where: 'map_id = ?',
      whereArgs: [mapId],
      orderBy: 'name ASC',
    );
    return results.map((e) => Artifact.fromMap(e)).toList();
  }

  Future<List<Artifact>> getArtifactsByPeriod(String period) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'artifacts',
      where: 'period = ?',
      whereArgs: [period],
      orderBy: 'name ASC',
    );
    return results.map((e) => Artifact.fromMap(e)).toList();
  }

  Future<List<Artifact>> getArtifactsByMaterial(String material) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'artifacts',
      where: 'material LIKE ?',
      whereArgs: ['%$material%'],
      orderBy: 'name ASC',
    );
    return results.map((e) => Artifact.fromMap(e)).toList();
  }

  Future<List<Artifact>> searchArtifacts(String query) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'artifacts',
      where: 'name LIKE ? OR description LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return results.map((e) => Artifact.fromMap(e)).toList();
  }

  Future<Artifact?> getArtifactById(String id) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'artifacts',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Artifact.fromMap(results.first);
  }
}
