import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

final historicalCharactersServiceProvider = Provider((ref) => HistoricalCharactersService());

class HistoricalCharacter {
  final String id;
  final String name;
  final String? title;
  final String? biography;
  final int? birthYear;
  final int? deathYear;
  final String? civilization;
  final String? occupation;
  final String? imageUrl;
  final String? famousFor;

  HistoricalCharacter({
    required this.id,
    required this.name,
    this.title,
    this.biography,
    this.birthYear,
    this.deathYear,
    this.civilization,
    this.occupation,
    this.imageUrl,
    this.famousFor,
  });

  factory HistoricalCharacter.fromMap(Map<String, dynamic> map) {
    return HistoricalCharacter(
      id: map['id'],
      name: map['name'],
      title: map['title'],
      biography: map['biography'],
      birthYear: map['birth_year'],
      deathYear: map['death_year'],
      civilization: map['civilization'],
      occupation: map['occupation'],
      imageUrl: map['image_url'],
      famousFor: map['famous_for'],
    );
  }
}

class HistoricalCharactersService {
  Future<List<HistoricalCharacter>> getCharactersByCivilization(String civilization) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'historical_characters',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'name ASC',
    );
    return results.map((e) => HistoricalCharacter.fromMap(e)).toList();
  }

  Future<List<HistoricalCharacter>> searchCharacters(String query) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'historical_characters',
      where: 'name LIKE ? OR biography LIKE ? OR famous_for LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
      orderBy: 'name ASC',
    );
    return results.map((e) => HistoricalCharacter.fromMap(e)).toList();
  }

  Future<HistoricalCharacter?> getCharacterById(String id) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'historical_characters',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return HistoricalCharacter.fromMap(results.first);
  }
}
