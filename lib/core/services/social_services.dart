import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

// Multiplayer Challenges Service
final multiplayerChallengesServiceProvider = Provider((ref) => MultiplayerChallengesService());

class MultiplayerChallenge {
  final String id;
  final String title;
  final String? description;
  final String challengeType;
  final String difficulty;
  final List<String> participants;
  final int maxParticipants;
  final DateTime? startDate;
  final DateTime? endDate;
  final int rewardXp;
  final String status;

  MultiplayerChallenge({
    required this.id,
    required this.title,
    this.description,
    required this.challengeType,
    this.difficulty = 'medium',
    this.participants = const [],
    required this.maxParticipants,
    this.startDate,
    this.endDate,
    required this.rewardXp,
    this.status = 'active',
  });

  factory MultiplayerChallenge.fromMap(Map<String, dynamic> map) {
    return MultiplayerChallenge(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      challengeType: map['challenge_type'],
      difficulty: map['difficulty'] ?? 'medium',
      participants: map['participants'] != null
          ? (map['participants'] as String).split(',')
          : [],
      maxParticipants: map['max_participants'] ?? 10,
      startDate: map['start_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['start_date'])
          : null,
      endDate: map['end_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['end_date'])
          : null,
      rewardXp: map['reward_xp'] ?? 0,
      status: map['status'] ?? 'active',
    );
  }

  bool get isFull => participants.length >= maxParticipants;
  bool get isActive => status == 'active';
}

class MultiplayerChallengesService {
  final _uuid = const Uuid();

  Future<List<MultiplayerChallenge>> getActiveChallenges() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'multiplayer_challenges',
      where: 'status = ?',
      whereArgs: ['active'],
      orderBy: 'start_date DESC',
    );
    return results.map((e) => MultiplayerChallenge.fromMap(e)).toList();
  }

  Future<void> joinChallenge(String challengeId, String userId) async {
    final db = await AppDatabase().database;
    
    final challenge = await db.query(
      'multiplayer_challenges',
      where: 'id = ?',
      whereArgs: [challengeId],
      limit: 1,
    );

    if (challenge.isNotEmpty) {
      final participants = challenge.first['participants'] as String?;
      final newParticipants = participants != null
          ? '$participants,$userId'
          : userId;

      await db.update(
        'multiplayer_challenges',
        {'participants': newParticipants},
        where: 'id = ?',
        whereArgs: [challengeId],
      );

      // Create progress entry
      await db.insert('user_challenge_progress', {
        'id': _uuid.v4(),
        'challenge_id': challengeId,
        'user_id': userId,
        'progress': 0,
        'completed': 0,
      });
    }
  }

  Future<void> updateChallengeProgress(String challengeId, String userId, int progress) async {
    final db = await AppDatabase().database;
    await db.update(
      'user_challenge_progress',
      {'progress': progress},
      where: 'challenge_id = ? AND user_id = ?',
      whereArgs: [challengeId, userId],
    );
  }
}

// Social Expeditions Service
final socialExpeditionsServiceProvider = Provider((ref) => SocialExpeditionsService());

class SocialExpedition {
  final String id;
  final String title;
  final String? description;
  final String? routeData;
  final List<String> participants;
  final String leaderId;
  final DateTime? scheduledDate;
  final int? durationMinutes;
  final String? difficulty;
  final String status;

  SocialExpedition({
    required this.id,
    required this.title,
    this.description,
    this.routeData,
    this.participants = const [],
    required this.leaderId,
    this.scheduledDate,
    this.durationMinutes,
    this.difficulty,
    this.status = 'upcoming',
  });

  factory SocialExpedition.fromMap(Map<String, dynamic> map) {
    return SocialExpedition(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      routeData: map['route_data'],
      participants: map['participants'] != null
          ? (map['participants'] as String).split(',')
          : [],
      leaderId: map['leader_id'],
      scheduledDate: map['scheduled_date'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['scheduled_date'])
          : null,
      durationMinutes: map['duration_minutes'],
      difficulty: map['difficulty'],
      status: map['status'] ?? 'upcoming',
    );
  }
}

class SocialExpeditionsService {
  final _uuid = const Uuid();

  Future<List<SocialExpedition>> getUpcomingExpeditions() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'social_expeditions',
      where: 'status = ?',
      whereArgs: ['upcoming'],
      orderBy: 'scheduled_date ASC',
    );
    return results.map((e) => SocialExpedition.fromMap(e)).toList();
  }

  Future<SocialExpedition> createExpedition(SocialExpedition expedition) async {
    final db = await AppDatabase().database;
    await db.insert('social_expeditions', {
      'id': expedition.id,
      'title': expedition.title,
      'description': expedition.description,
      'route_data': expedition.routeData,
      'participants': expedition.participants.join(','),
      'leader_id': expedition.leaderId,
      'scheduled_date': expedition.scheduledDate?.millisecondsSinceEpoch,
      'duration_minutes': expedition.durationMinutes,
      'difficulty': expedition.difficulty,
      'status': expedition.status,
      'created_at': DateTime.now().millisecondsSinceEpoch,
    });
    return expedition;
  }

  Future<void> joinExpedition(String expeditionId, String userId) async {
    final db = await AppDatabase().database;
    
    final expedition = await db.query(
      'social_expeditions',
      where: 'id = ?',
      whereArgs: [expeditionId],
      limit: 1,
    );

    if (expedition.isNotEmpty) {
      final participants = expedition.first['participants'] as String?;
      final newParticipants = participants != null
          ? '$participants,$userId'
          : userId;

      await db.update(
        'social_expeditions',
        {'participants': newParticipants},
        where: 'id = ?',
        whereArgs: [expeditionId],
      );
    }
  }
}

// Live Events Service
final liveEventsServiceProvider = Provider((ref) => LiveEventsService());

class LiveEvent {
  final String id;
  final String title;
  final String? description;
  final String eventType;
  final String? presenter;
  final String? streamUrl;
  final DateTime scheduledTime;
  final int? durationMinutes;
  final List<String> attendees;
  final String? recordingUrl;
  final String status;

  LiveEvent({
    required this.id,
    required this.title,
    this.description,
    required this.eventType,
    this.presenter,
    this.streamUrl,
    required this.scheduledTime,
    this.durationMinutes,
    this.attendees = const [],
    this.recordingUrl,
    this.status = 'scheduled',
  });

  factory LiveEvent.fromMap(Map<String, dynamic> map) {
    return LiveEvent(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      eventType: map['event_type'],
      presenter: map['presenter'],
      streamUrl: map['stream_url'],
      scheduledTime: DateTime.fromMillisecondsSinceEpoch(map['scheduled_time']),
      durationMinutes: map['duration_minutes'],
      attendees: map['attendees'] != null
          ? (map['attendees'] as String).split(',')
          : [],
      recordingUrl: map['recording_url'],
      status: map['status'] ?? 'scheduled',
    );
  }

  bool get isLive => status == 'live';
  bool get isUpcoming => status == 'scheduled' && scheduledTime.isAfter(DateTime.now());
}

class LiveEventsService {
  final _uuid = const Uuid();

  Future<List<LiveEvent>> getUpcomingEvents() async {
    final db = await AppDatabase().database;
    final now = DateTime.now().millisecondsSinceEpoch;
    
    final results = await db.query(
      'live_events',
      where: 'scheduled_time > ? AND status = ?',
      whereArgs: [now, 'scheduled'],
      orderBy: 'scheduled_time ASC',
    );
    return results.map((e) => LiveEvent.fromMap(e)).toList();
  }

  Future<List<LiveEvent>> getLiveEvents() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'live_events',
      where: 'status = ?',
      whereArgs: ['live'],
      orderBy: 'scheduled_time DESC',
    );
    return results.map((e) => LiveEvent.fromMap(e)).toList();
  }

  Future<void> registerForEvent(String eventId, String userId) async {
    final db = await AppDatabase().database;
    
    final event = await db.query(
      'live_events',
      where: 'id = ?',
      whereArgs: [eventId],
      limit: 1,
    );

    if (event.isNotEmpty) {
      final attendees = event.first['attendees'] as String?;
      final newAttendees = attendees != null
          ? '$attendees,$userId'
          : userId;

      await db.update(
        'live_events',
        {'attendees': newAttendees},
        where: 'id = ?',
        whereArgs: [eventId],
      );
    }
  }
}

// Friend System Service
final friendSystemServiceProvider = Provider((ref) => FriendSystemService());

class UserFriend {
  final String id;
  final String userId;
  final String friendId;
  final DateTime friendshipDate;
  final String status;
  final int sharedDiscoveries;
  final int combinedXp;

  UserFriend({
    required this.id,
    required this.userId,
    required this.friendId,
    required this.friendshipDate,
    this.status = 'active',
    this.sharedDiscoveries = 0,
    this.combinedXp = 0,
  });

  factory UserFriend.fromMap(Map<String, dynamic> map) {
    return UserFriend(
      id: map['id'],
      userId: map['user_id'],
      friendId: map['friend_id'],
      friendshipDate: DateTime.fromMillisecondsSinceEpoch(map['friendship_date']),
      status: map['status'] ?? 'active',
      sharedDiscoveries: map['shared_discoveries'] ?? 0,
      combinedXp: map['combined_xp'] ?? 0,
    );
  }
}

class FriendSystemService {
  final _uuid = const Uuid();

  Future<void> addFriend(String userId, String friendId) async {
    final db = await AppDatabase().database;
    await db.insert('user_friends', {
      'id': _uuid.v4(),
      'user_id': userId,
      'friend_id': friendId,
      'friendship_date': DateTime.now().millisecondsSinceEpoch,
      'status': 'active',
      'shared_discoveries': 0,
      'combined_xp': 0,
    });
  }

  Future<List<UserFriend>> getUserFriends(String userId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'user_friends',
      where: 'user_id = ? AND status = ?',
      whereArgs: [userId, 'active'],
      orderBy: 'friendship_date DESC',
    );
    return results.map((e) => UserFriend.fromMap(e)).toList();
  }

  Future<void> removeFriend(String friendshipId) async {
    final db = await AppDatabase().database;
    await db.update(
      'user_friends',
      {'status': 'inactive'},
      where: 'id = ?',
      whereArgs: [friendshipId],
    );
  }
}
