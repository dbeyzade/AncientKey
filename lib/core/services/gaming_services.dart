import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';
import 'achievement_service.dart';

// Quest Service
final questServiceProvider = Provider((ref) => QuestService(ref));

class Quest {
  final String id;
  final String title;
  final String? description;
  final String questType;
  final List<QuestObjective> objectives;
  final Map<String, dynamic> rewards;
  final String difficulty;
  final int requiredLevel;
  final int? timeLimitMinutes;
  final List<String> prerequisiteQuests;

  Quest({
    required this.id,
    required this.title,
    this.description,
    required this.questType,
    required this.objectives,
    required this.rewards,
    this.difficulty = 'medium',
    this.requiredLevel = 1,
    this.timeLimitMinutes,
    this.prerequisiteQuests = const [],
  });

  factory Quest.fromMap(Map<String, dynamic> map) {
    return Quest(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      questType: map['quest_type'],
      objectives: _parseObjectives(map['objectives']),
      rewards: _parseRewards(map['rewards']),
      difficulty: map['difficulty'] ?? 'medium',
      requiredLevel: map['required_level'] ?? 1,
      timeLimitMinutes: map['time_limit_minutes'],
      prerequisiteQuests: map['prerequisite_quests'] != null 
          ? (map['prerequisite_quests'] as String).split(',')
          : [],
    );
  }

  static List<QuestObjective> _parseObjectives(String objectivesStr) {
    // In production, use JSON parsing
    return [];
  }

  static Map<String, dynamic> _parseRewards(String? rewardsStr) {
    // In production, use JSON parsing
    return {'xp': 100, 'items': []};
  }
}

class QuestObjective {
  final String id;
  final String description;
  final int targetCount;
  final int currentCount;
  final bool completed;

  QuestObjective({
    required this.id,
    required this.description,
    required this.targetCount,
    this.currentCount = 0,
    this.completed = false,
  });
}

class QuestService {
  final Ref ref;
  final _uuid = const Uuid();

  QuestService(this.ref);

  Future<List<Quest>> getAvailableQuests(int userLevel) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'quests',
      where: 'required_level <= ?',
      whereArgs: [userLevel],
      orderBy: 'difficulty ASC',
    );
    return results.map((e) => Quest.fromMap(e)).toList();
  }

  Future<void> startQuest(String questId) async {
    final db = await AppDatabase().database;
    await db.insert('user_quest_progress', {
      'id': _uuid.v4(),
      'quest_id': questId,
      'user_id': 'default',
      'objectives_completed': '[]',
      'progress_percentage': 0,
      'started_at': DateTime.now().millisecondsSinceEpoch,
    });
  }

  Future<void> updateQuestProgress(String questId, String objectiveId) async {
    // Update objective completion
    // Award XP if quest completed
    final achievementService = ref.read(achievementServiceProvider);
    await achievementService.addExperiencePoints(50);
  }

  Future<List<Quest>> getUserActiveQuests() async {
    final db = await AppDatabase().database;
    final progressResults = await db.query(
      'user_quest_progress',
      where: 'completed_at IS NULL',
    );
    
    final questIds = progressResults.map((e) => e['quest_id'] as String).toList();
    if (questIds.isEmpty) return [];

    final questResults = await db.query(
      'quests',
      where: 'id IN (${questIds.map((_) => '?').join(',')})',
      whereArgs: questIds,
    );
    
    return questResults.map((e) => Quest.fromMap(e)).toList();
  }
}

// Treasure Hunt Service
final treasureHuntServiceProvider = Provider((ref) => TreasureHuntService(ref));

class TreasureHunt {
  final String id;
  final String title;
  final String? description;
  final List<String> clues;
  final List<TreasureLocation> locations;
  final String difficulty;
  final int rewardXp;
  final List<String> rewardItems;
  final DateTime? activePeriodStart;
  final DateTime? activePeriodEnd;

  TreasureHunt({
    required this.id,
    required this.title,
    this.description,
    required this.clues,
    required this.locations,
    this.difficulty = 'medium',
    required this.rewardXp,
    this.rewardItems = const [],
    this.activePeriodStart,
    this.activePeriodEnd,
  });

  bool get isActive {
    final now = DateTime.now();
    if (activePeriodStart != null && now.isBefore(activePeriodStart!)) return false;
    if (activePeriodEnd != null && now.isAfter(activePeriodEnd!)) return false;
    return true;
  }
}

class TreasureLocation {
  final double latitude;
  final double longitude;
  final String hint;
  final bool discovered;

  TreasureLocation({
    required this.latitude,
    required this.longitude,
    required this.hint,
    this.discovered = false,
  });
}

class TreasureHuntService {
  final Ref ref;

  TreasureHuntService(this.ref);

  Future<List<TreasureHunt>> getActiveTreasureHunts() async {
    final db = await AppDatabase().database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final results = await db.query(
      'treasure_hunts',
      where: 'active_period_start <= ? AND active_period_end >= ?',
      whereArgs: [now, now],
      orderBy: 'difficulty ASC',
    );
    
    // In production, properly parse results
    return [];
  }

  Future<bool> checkTreasureLocation(String huntId, double lat, double lng) async {
    // Check if user is near a treasure location
    // Award XP if treasure found
    final achievementService = ref.read(achievementServiceProvider);
    await achievementService.addExperiencePoints(75);
    return true;
  }
}

// Mini Games Service
final miniGamesServiceProvider = Provider((ref) => MiniGamesService());

class MiniGame {
  final String id;
  final String gameName;
  final String gameType;
  final String? description;
  final String difficulty;
  final int highScore;
  final int timesPlayed;
  final DateTime? lastPlayed;

  MiniGame({
    required this.id,
    required this.gameName,
    required this.gameType,
    this.description,
    this.difficulty = 'easy',
    this.highScore = 0,
    this.timesPlayed = 0,
    this.lastPlayed,
  });

  factory MiniGame.fromMap(Map<String, dynamic> map) {
    return MiniGame(
      id: map['id'],
      gameName: map['game_name'],
      gameType: map['game_type'],
      description: map['description'],
      difficulty: map['difficulty'] ?? 'easy',
      highScore: map['high_score'] ?? 0,
      timesPlayed: map['times_played'] ?? 0,
      lastPlayed: map['last_played'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_played'])
          : null,
    );
  }
}

class MiniGamesService {
  Future<List<MiniGame>> getAllMiniGames() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'mini_games',
      orderBy: 'game_name ASC',
    );
    return results.map((e) => MiniGame.fromMap(e)).toList();
  }

  Future<void> updateHighScore(String gameId, int newScore) async {
    final db = await AppDatabase().database;
    
    final existing = await db.query(
      'mini_games',
      where: 'id = ?',
      whereArgs: [gameId],
      limit: 1,
    );

    if (existing.isNotEmpty) {
      final currentHighScore = existing.first['high_score'] as int;
      if (newScore > currentHighScore) {
        await db.update(
          'mini_games',
          {
            'high_score': newScore,
            'times_played': (existing.first['times_played'] as int) + 1,
            'last_played': DateTime.now().millisecondsSinceEpoch,
          },
          where: 'id = ?',
          whereArgs: [gameId],
        );
      }
    }
  }
}

// Leaderboard Service
final leaderboardServiceProvider = Provider((ref) => LeaderboardService());

class LeaderboardEntry {
  final String id;
  final String category;
  final String userId;
  final String username;
  final int score;
  final int rank;
  final String? avatarUrl;
  final int achievementsCount;

  LeaderboardEntry({
    required this.id,
    required this.category,
    required this.userId,
    required this.username,
    required this.score,
    required this.rank,
    this.avatarUrl,
    required this.achievementsCount,
  });

  factory LeaderboardEntry.fromMap(Map<String, dynamic> map) {
    return LeaderboardEntry(
      id: map['id'],
      category: map['category'],
      userId: map['user_id'],
      username: map['username'],
      score: map['score'],
      rank: map['rank'],
      avatarUrl: map['avatar_url'],
      achievementsCount: map['achievements_count'] ?? 0,
    );
  }
}

class LeaderboardService {
  Future<List<LeaderboardEntry>> getLeaderboard(String category, {int limit = 100}) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'leaderboards',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'rank ASC',
      limit: limit,
    );
    return results.map((e) => LeaderboardEntry.fromMap(e)).toList();
  }

  Future<LeaderboardEntry?> getUserRank(String category, String userId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'leaderboards',
      where: 'category = ? AND user_id = ?',
      whereArgs: [category, userId],
      limit: 1,
    );
    if (results.isEmpty) return null;
    return LeaderboardEntry.fromMap(results.first);
  }

  Future<List<String>> getLeaderboardCategories() async {
    final db = await AppDatabase().database;
    final results = await db.rawQuery(
      'SELECT DISTINCT category FROM leaderboards ORDER BY category',
    );
    return results.map((e) => e['category'] as String).toList();
  }
}
