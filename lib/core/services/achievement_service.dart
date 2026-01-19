import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart' show Sqflite;
import '../database/app_database.dart';

class Achievement {
  final String id;
  final String name;
  final String description;
  final String icon;
  final bool unlocked;
  final DateTime? unlockedAt;

  Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.unlocked,
    this.unlockedAt,
  });

  factory Achievement.fromMap(Map<String, dynamic> map) {
    return Achievement(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      icon: map['icon'],
      unlocked: map['unlocked'] == 1,
      unlockedAt: map['unlocked_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['unlocked_at'])
          : null,
    );
  }
}

class UserProgress {
  final int level;
  final int experiencePoints;
  final int placesVisited;
  final int mapsExplored;

  UserProgress({
    required this.level,
    required this.experiencePoints,
    required this.placesVisited,
    required this.mapsExplored,
  });

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    return UserProgress(
      level: map['level'],
      experiencePoints: map['experience_points'],
      placesVisited: map['places_visited'],
      mapsExplored: map['maps_explored'],
    );
  }

  int get experienceForNextLevel => level * 100;
  double get progressToNextLevel => experiencePoints / experienceForNextLevel;
}

class AchievementService {
  final AppDatabase _db;

  AchievementService(this._db);

  Future<List<Achievement>> getAllAchievements() async {
    final db = await _db.database;
    final result = await db.query('achievements', orderBy: 'unlocked DESC');
    return result.map((map) => Achievement.fromMap(map)).toList();
  }

  Future<List<Achievement>> getUnlockedAchievements() async {
    final db = await _db.database;
    final result = await db.query(
      'achievements',
      where: 'unlocked = ?',
      whereArgs: [1],
      orderBy: 'unlocked_at DESC',
    );
    return result.map((map) => Achievement.fromMap(map)).toList();
  }

  Future<void> unlockAchievement(String achievementId) async {
    final db = await _db.database;
    
    // Check if already unlocked
    final existing = await db.query(
      'achievements',
      where: 'id = ? AND unlocked = ?',
      whereArgs: [achievementId, 1],
    );

    if (existing.isEmpty) {
      await db.update(
        'achievements',
        {
          'unlocked': 1,
          'unlocked_at': DateTime.now().millisecondsSinceEpoch,
        },
        where: 'id = ?',
        whereArgs: [achievementId],
      );

      // Award experience points
      await addExperiencePoints(50);
    }
  }

  Future<UserProgress> getUserProgress() async {
    final db = await _db.database;
    final result = await db.query(
      'user_progress',
      where: 'id = ?',
      whereArgs: ['default'],
    );
    
    if (result.isEmpty) {
      return UserProgress(
        level: 1,
        experiencePoints: 0,
        placesVisited: 0,
        mapsExplored: 0,
      );
    }
    
    return UserProgress.fromMap(result.first);
  }

  Future<void> addExperiencePoints(int points) async {
    final db = await _db.database;
    final progress = await getUserProgress();
    
    final newExperience = progress.experiencePoints + points;
    var newLevel = progress.level;
    var remainingExperience = newExperience;

    // Calculate new level
    while (remainingExperience >= (newLevel * 100)) {
      remainingExperience -= (newLevel * 100);
      newLevel++;
    }

    await db.update(
      'user_progress',
      {
        'level': newLevel,
        'experience_points': remainingExperience,
      },
      where: 'id = ?',
      whereArgs: ['default'],
    );

    // Check level achievements
    await _checkLevelAchievements(newLevel);
  }

  Future<void> _checkLevelAchievements(int level) async {
    if (level >= 5) await unlockAchievement('level_5');
    if (level >= 10) await unlockAchievement('level_10');
    if (level >= 20) await unlockAchievement('level_20');
    if (level >= 50) await unlockAchievement('level_50');
  }

  Future<void> updateMapsExplored(int count) async {
    final db = await _db.database;
    await db.update(
      'user_progress',
      {'maps_explored': count},
      where: 'id = ?',
      whereArgs: ['default'],
    );
  }

  Future<void> checkAndUnlockAchievements() async {
    final progress = await getUserProgress();
    
    // Visit-based achievements - use unique maps count
    final db = await _db.database;
    final uniqueVisits = await db.rawQuery('SELECT COUNT(DISTINCT map_id) as count FROM visited_places');
    final visitCount = Sqflite.firstIntValue(uniqueVisits) ?? 0;
    
    if (visitCount >= 1) {
      await unlockAchievement('first_visit');
    }
    if (visitCount >= 5) {
      await unlockAchievement('explorer_5');
    }
    if (visitCount >= 10) {
      await unlockAchievement('explorer_10');
    }
    if (visitCount >= 25) {
      await unlockAchievement('explorer_25');
    }
    if (visitCount >= 50) {
      await unlockAchievement('explorer_50');
    }
    if (visitCount >= 100) {
      await unlockAchievement('explorer_100');
    }
    
    // Check notes and photos
    final notesCount = await db.rawQuery('SELECT COUNT(*) as count FROM user_notes');
    final notesTotal = Sqflite.firstIntValue(notesCount) ?? 0;
    if (notesTotal >= 1) {
      await unlockAchievement('writer');
    }
    if (notesTotal >= 10) {
      await unlockAchievement('storyteller');
    }
    
    final photosCount = await db.rawQuery('SELECT COUNT(*) as count FROM user_photos');
    final photosTotal = Sqflite.firstIntValue(photosCount) ?? 0;
    if (photosTotal >= 1) {
      await unlockAchievement('photographer');
    }
    if (photosTotal >= 10) {
      await unlockAchievement('photo_collector');
    }
    
    // Check comments
    final commentsCount = await db.rawQuery('SELECT COUNT(*) as count FROM user_comments');
    final commentsTotal = Sqflite.firstIntValue(commentsCount) ?? 0;
    if (commentsTotal >= 1) {
      await unlockAchievement('social_butterfly');
    }
    
    // Check time-based achievements
    final now = DateTime.now();
    final hour = now.hour;
    
    if (hour >= 0 && hour < 6) {
      await unlockAchievement('night_explorer');
    }
    if (hour >= 5 && hour < 7) {
      await unlockAchievement('early_bird');
    }
    if (now.weekday == DateTime.saturday || now.weekday == DateTime.sunday) {
      await unlockAchievement('weekend_warrior');
    }
  }

  Future<int> getUnlockedAchievementsCount() async {
    final db = await _db.database;
    final result = await db.rawQuery(
      'SELECT COUNT(*) as count FROM achievements WHERE unlocked = 1'
    );
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<int> getTotalAchievementsCount() async {
    final db = await _db.database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM achievements');
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> unlockAllAchievements() async {
    final db = await _db.database;
    await db.update(
      'achievements',
      {
        'unlocked': 1,
        'unlocked_at': DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  Future<void> lockAllAchievements() async {
    final db = await _db.database;
    await db.update(
      'achievements',
      {
        'unlocked': 0,
        'unlocked_at': null,
      },
    );
  }
}

final achievementServiceProvider = Provider<AchievementService>((ref) {
  return AchievementService(AppDatabase());
});
