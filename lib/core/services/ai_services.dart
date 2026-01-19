import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../database/app_database.dart';

// AI Image Recognition Service
final aiArtifactScanServiceProvider = Provider((ref) => AIArtifactScanService());

class AIArtifactScan {
  final String id;
  final String imagePath;
  final String? detectedArtifact;
  final double? confidence;
  final String? periodEstimate;
  final String? materialAnalysis;
  final String? similarArtifacts;
  final DateTime scanDate;
  final double? locationLat;
  final double? locationLng;
  final bool verified;

  AIArtifactScan({
    required this.id,
    required this.imagePath,
    this.detectedArtifact,
    this.confidence,
    this.periodEstimate,
    this.materialAnalysis,
    this.similarArtifacts,
    required this.scanDate,
    this.locationLat,
    this.locationLng,
    this.verified = false,
  });

  factory AIArtifactScan.fromMap(Map<String, dynamic> map) {
    return AIArtifactScan(
      id: map['id'],
      imagePath: map['image_path'],
      detectedArtifact: map['detected_artifact'],
      confidence: map['confidence'],
      periodEstimate: map['period_estimate'],
      materialAnalysis: map['material_analysis'],
      similarArtifacts: map['similar_artifacts'],
      scanDate: DateTime.fromMillisecondsSinceEpoch(map['scan_date']),
      locationLat: map['location_lat'],
      locationLng: map['location_lng'],
      verified: map['verified'] == 1,
    );
  }

  List<String> get similarArtifactsList => 
      similarArtifacts?.split('|').map((e) => e.trim()).toList() ?? [];
}

class AIArtifactScanService {
  final _uuid = const Uuid();

  Future<AIArtifactScan> scanArtifact(String imagePath, {double? lat, double? lng}) async {
    final db = await AppDatabase().database;
    
    // Simulated AI analysis (in real app, this would call ML model)
    final analysis = _simulateAIAnalysis(imagePath);
    
    final scan = AIArtifactScan(
      id: _uuid.v4(),
      imagePath: imagePath,
      detectedArtifact: analysis['artifact'],
      confidence: analysis['confidence'],
      periodEstimate: analysis['period'],
      materialAnalysis: analysis['material'],
      similarArtifacts: analysis['similar'],
      scanDate: DateTime.now(),
      locationLat: lat,
      locationLng: lng,
    );

    await db.insert('ai_artifact_scans', {
      'id': scan.id,
      'image_path': scan.imagePath,
      'detected_artifact': scan.detectedArtifact,
      'confidence': scan.confidence,
      'period_estimate': scan.periodEstimate,
      'material_analysis': scan.materialAnalysis,
      'similar_artifacts': scan.similarArtifacts,
      'scan_date': scan.scanDate.millisecondsSinceEpoch,
      'location_lat': scan.locationLat,
      'location_lng': scan.locationLng,
      'verified': scan.verified ? 1 : 0,
    });

    return scan;
  }

  Map<String, dynamic> _simulateAIAnalysis(String imagePath) {
    // This would be replaced with actual ML model inference
    return {
      'artifact': 'Ancient Greek Amphora',
      'confidence': 0.87,
      'period': 'Classical Period (480-323 BCE)',
      'material': 'Terracotta with red-figure decoration',
      'similar': 'British Museum GR1836.2-24.50|Louvre CA3482',
    };
  }

  Future<List<AIArtifactScan>> getUserScans() async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'ai_artifact_scans',
      orderBy: 'scan_date DESC',
    );
    return results.map((e) => AIArtifactScan.fromMap(e)).toList();
  }

  Future<void> verifyScan(String scanId) async {
    final db = await AppDatabase().database;
    await db.update(
      'ai_artifact_scans',
      {'verified': 1},
      where: 'id = ?',
      whereArgs: [scanId],
    );
  }
}

// AI Chatbot Service
final aiChatbotServiceProvider = Provider((ref) => AIChatbotService());

class AIConversation {
  final String id;
  final String topic;
  final List<ChatMessage> messages;
  final String? civilization;
  final DateTime startedAt;
  final DateTime? lastMessageAt;
  final int? rating;

  AIConversation({
    required this.id,
    required this.topic,
    required this.messages,
    this.civilization,
    required this.startedAt,
    this.lastMessageAt,
    this.rating,
  });

  factory AIConversation.fromMap(Map<String, dynamic> map) {
    return AIConversation(
      id: map['id'],
      topic: map['topic'],
      messages: _parseMessages(map['messages']),
      civilization: map['civilization'],
      startedAt: DateTime.fromMillisecondsSinceEpoch(map['started_at']),
      lastMessageAt: map['last_message_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['last_message_at'])
          : null,
      rating: map['rating'],
    );
  }

  static List<ChatMessage> _parseMessages(String messagesJson) {
    // Simple parsing - in real app use JSON
    return [];
  }
}

class ChatMessage {
  final String sender; // 'user' or 'ai'
  final String message;
  final DateTime timestamp;

  ChatMessage({
    required this.sender,
    required this.message,
    required this.timestamp,
  });
}

class AIChatbotService {
  final _uuid = const Uuid();

  Future<String> sendMessage(String conversationId, String userMessage) async {
    // Simulated AI response (in real app, this would call OpenAI/Gemini API)
    final aiResponse = _generateAIResponse(userMessage);
    
    // Update conversation in database
    // In production, properly serialize messages as JSON
    
    return aiResponse;
  }

  String _generateAIResponse(String userMessage) {
    // This would be replaced with actual AI API call
    if (userMessage.toLowerCase().contains('roma')) {
      return 'Roma İmparatorluğu MÖ 27 - MS 476 yılları arasında hüküm sürmüştür. Augustus ilk imparator olarak tarihe geçmiştir.';
    }
    return 'Antik tarih hakkında daha fazla bilgi için belirli bir medeniyetten bahsedin!';
  }

  Future<AIConversation> startConversation(String topic, {String? civilization}) async {
    final db = await AppDatabase().database;
    final id = _uuid.v4();
    
    await db.insert('ai_conversations', {
      'id': id,
      'topic': topic,
      'messages': '[]',
      'civilization': civilization,
      'started_at': DateTime.now().millisecondsSinceEpoch,
    });

    return AIConversation(
      id: id,
      topic: topic,
      messages: [],
      civilization: civilization,
      startedAt: DateTime.now(),
    );
  }
}

// Voice Notes Service
final voiceNotesServiceProvider = Provider((ref) => VoiceNotesService());

class VoiceNote {
  final String id;
  final String mapId;
  final String audioPath;
  final String? transcription;
  final String? language;
  final int? duration;
  final DateTime recordedAt;
  final double? locationLat;
  final double? locationLng;
  final List<String> tags;

  VoiceNote({
    required this.id,
    required this.mapId,
    required this.audioPath,
    this.transcription,
    this.language,
    this.duration,
    required this.recordedAt,
    this.locationLat,
    this.locationLng,
    this.tags = const [],
  });

  factory VoiceNote.fromMap(Map<String, dynamic> map) {
    return VoiceNote(
      id: map['id'],
      mapId: map['map_id'],
      audioPath: map['audio_path'],
      transcription: map['transcription'],
      language: map['language'],
      duration: map['duration'],
      recordedAt: DateTime.fromMillisecondsSinceEpoch(map['recorded_at']),
      locationLat: map['location_lat'],
      locationLng: map['location_lng'],
      tags: map['tags'] != null ? (map['tags'] as String).split(',') : [],
    );
  }
}

class VoiceNotesService {
  final _uuid = const Uuid();

  Future<void> saveVoiceNote(VoiceNote note) async {
    final db = await AppDatabase().database;
    await db.insert('voice_notes', {
      'id': note.id,
      'map_id': note.mapId,
      'audio_path': note.audioPath,
      'transcription': note.transcription,
      'language': note.language,
      'duration': note.duration,
      'recorded_at': note.recordedAt.millisecondsSinceEpoch,
      'location_lat': note.locationLat,
      'location_lng': note.locationLng,
      'tags': note.tags.join(','),
    });
  }

  Future<List<VoiceNote>> getVoiceNotesForMap(String mapId) async {
    final db = await AppDatabase().database;
    final results = await db.query(
      'voice_notes',
      where: 'map_id = ?',
      whereArgs: [mapId],
      orderBy: 'recorded_at DESC',
    );
    return results.map((e) => VoiceNote.fromMap(e)).toList();
  }
}
