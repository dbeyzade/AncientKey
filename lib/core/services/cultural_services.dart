import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../database/app_database.dart';

// Ancient Music Service
final ancientMusicServiceProvider = Provider((ref) => AncientMusicService());

class AncientMusic {
  final String id;
  final String title;
  final String civilization;
  final String? period;
  final String? instrument;
  final String? description;
  final String audioUrl;
  final int? duration;
  final bool downloaded;

  AncientMusic({
    required this.id,
    required this.title,
    required this.civilization,
    this.period,
    this.instrument,
    this.description,
    required this.audioUrl,
    this.duration,
    this.downloaded = false,
  });

  factory AncientMusic.fromMap(Map<String, dynamic> map) {
    return AncientMusic(
      id: map['id'],
      title: map['title'],
      civilization: map['civilization'],
      period: map['period'],
      instrument: map['instrument'],
      description: map['description'],
      audioUrl: map['audio_url'],
      duration: map['duration'],
      downloaded: map['downloaded'] == 1,
    );
  }
}

class AncientMusicService {
  Future<List<AncientMusic>> getMusicByCivilization(String civilization) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'ancient_music',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'title ASC',
    );
    return results.map((e) => AncientMusic.fromMap(e)).toList();
  }

  Future<List<AncientMusic>> getAllMusic() async {
    final db = await AppDatabase().database;
    final results = await db.query('ancient_music', orderBy: 'civilization ASC, title ASC');
    return results.map((e) => AncientMusic.fromMap(e)).toList();
  }
}

// Historical Recipes Service
final historicalRecipesServiceProvider = Provider((ref) => HistoricalRecipesService());

class HistoricalRecipe {
  final String id;
  final String name;
  final String civilization;
  final String? period;
  final String ingredients;
  final String instructions;
  final String? servingSize;
  final String? occasion;
  final String? historicalNotes;
  final String? imageUrl;
  final String difficulty;

  HistoricalRecipe({
    required this.id,
    required this.name,
    required this.civilization,
    this.period,
    required this.ingredients,
    required this.instructions,
    this.servingSize,
    this.occasion,
    this.historicalNotes,
    this.imageUrl,
    this.difficulty = 'medium',
  });

  factory HistoricalRecipe.fromMap(Map<String, dynamic> map) {
    return HistoricalRecipe(
      id: map['id'],
      name: map['name'],
      civilization: map['civilization'],
      period: map['period'],
      ingredients: map['ingredients'],
      instructions: map['instructions'],
      servingSize: map['serving_size'],
      occasion: map['occasion'],
      historicalNotes: map['historical_notes'],
      imageUrl: map['image_url'],
      difficulty: map['difficulty'] ?? 'medium',
    );
  }

  List<String> get ingredientsList => 
      ingredients.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();

  List<String> get instructionsList => 
      instructions.split('\n').map((e) => e.trim()).where((e) => e.isNotEmpty).toList();
}

class HistoricalRecipesService {
  Future<List<HistoricalRecipe>> getRecipesByCivilization(String civilization) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'historical_recipes',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'name ASC',
    );
    return results.map((e) => HistoricalRecipe.fromMap(e)).toList();
  }

  Future<List<HistoricalRecipe>> getRecipesByDifficulty(String difficulty) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'historical_recipes',
      where: 'difficulty = ?',
      whereArgs: [difficulty],
      orderBy: 'name ASC',
    );
    return results.map((e) => HistoricalRecipe.fromMap(e)).toList();
  }

  Future<List<HistoricalRecipe>> getAllRecipes() async {
    final db = await AppDatabase().database;
    final results = await db.query('historical_recipes', orderBy: 'civilization ASC, name ASC');
    return results.map((e) => HistoricalRecipe.fromMap(e)).toList();
  }
}

// Dynasty Service
final dynastyServiceProvider = Provider((ref) => DynastyService());

class Dynasty {
  final String id;
  final String name;
  final String civilization;
  final String? founder;
  final String? timePeriod;
  final String? capitalCity;
  final String? notableRulers;
  final String? achievements;
  final String? downfall;
  final String? familyTreeData;

  Dynasty({
    required this.id,
    required this.name,
    required this.civilization,
    this.founder,
    this.timePeriod,
    this.capitalCity,
    this.notableRulers,
    this.achievements,
    this.downfall,
    this.familyTreeData,
  });

  factory Dynasty.fromMap(Map<String, dynamic> map) {
    return Dynasty(
      id: map['id'],
      name: map['name'],
      civilization: map['civilization'],
      founder: map['founder'],
      timePeriod: map['time_period'],
      capitalCity: map['capital_city'],
      notableRulers: map['notable_rulers'],
      achievements: map['achievements'],
      downfall: map['downfall'],
      familyTreeData: map['family_tree_data'],
    );
  }

  List<String> get rulersList => 
      notableRulers?.split('|').map((e) => e.trim()).toList() ?? [];

  List<String> get achievementsList => 
      achievements?.split('|').map((e) => e.trim()).toList() ?? [];
}

class DynastyService {
  Future<List<Dynasty>> getDynastiesByCivilization(String civilization) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'dynasties',
      where: 'civilization = ?',
      whereArgs: [civilization],
      orderBy: 'name ASC',
    );
    return results.map((e) => Dynasty.fromMap(e)).toList();
  }

  Future<Dynasty?> getDynastyById(String id) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'dynasties',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return Dynasty.fromMap(results.first);
  }

  Future<List<Dynasty>> getAllDynasties() async {
    final db = await AppDatabase().database;
    final results = await db.query('dynasties', orderBy: 'civilization ASC, name ASC');
    return results.map((e) => Dynasty.fromMap(e)).toList();
  }
}
