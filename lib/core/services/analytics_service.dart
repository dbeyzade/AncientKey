import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserAnalytics {
  final String eventName;
  final DateTime timestamp;
  final Map<String, dynamic> data;

  UserAnalytics({
    required this.eventName,
    required this.timestamp,
    required this.data,
  });

  Map<String, dynamic> toJson() => {
    'eventName': eventName,
    'timestamp': timestamp.toIso8601String(),
    'data': data,
  };

  factory UserAnalytics.fromJson(Map<String, dynamic> json) => UserAnalytics(
    eventName: json['eventName'],
    timestamp: DateTime.parse(json['timestamp']),
    data: json['data'],
  );
}

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();

  factory AnalyticsService() {
    return _instance;
  }

  AnalyticsService._internal();

  late SharedPreferences _prefs;
  final List<UserAnalytics> _localEvents = [];

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
    await _loadLocalEvents();
  }

  /// Kullanıcı davranışını kaydet
  Future<void> trackEvent(
    String eventName, {
    Map<String, dynamic>? data,
  }) async {
    final analytics = UserAnalytics(
      eventName: eventName,
      timestamp: DateTime.now(),
      data: data ?? {},
    );

    _localEvents.add(analytics);
    await _saveLocalEvents();

    print('📊 Analytics: $eventName - ${DateTime.now()}');
  }

  /// Ekran görüntülenmesini kaydet
  Future<void> trackScreenView(String screenName) async {
    await trackEvent('screen_view', data: {
      'screen_name': screenName,
    });
  }

  /// Özellik kullanımını kaydet
  Future<void> trackFeatureUsage(String featureName) async {
    await trackEvent('feature_used', data: {
      'feature_name': featureName,
    });
  }

  /// Arama işlemini kaydet
  Future<void> trackSearch(String query) async {
    await trackEvent('search', data: {
      'query': query,
    });
  }

  /// Harita etkileşimini kaydet
  Future<void> trackMapInteraction(String mapId, String action) async {
    await trackEvent('map_interaction', data: {
      'map_id': mapId,
      'action': action,
    });
  }

  /// Başarım kilidini açma işlemini kaydet
  Future<void> trackAchievementUnlocked(String achievementId) async {
    await trackEvent('achievement_unlocked', data: {
      'achievement_id': achievementId,
    });
  }

  /// Puan kazanma işlemini kaydet
  Future<void> trackPointsEarned(int points, String source) async {
    await trackEvent('points_earned', data: {
      'points': points,
      'source': source,
    });
  }

  /// Sosyal paylaşımı kaydet
  Future<void> trackSocialShare(String contentType) async {
    await trackEvent('social_share', data: {
      'content_type': contentType,
    });
  }

  /// Oturum süresi bilgisini kaydet
  Future<void> trackSessionTime(Duration duration) async {
    await trackEvent('session_end', data: {
      'duration_seconds': duration.inSeconds,
    });
  }

  /// Hatayı kaydet
  Future<void> trackError(String errorCode, String errorMessage) async {
    await trackEvent('error', data: {
      'error_code': errorCode,
      'error_message': errorMessage,
    });
  }

  /// Tüm olayları al
  List<UserAnalytics> getAllEvents() => List.from(_localEvents);

  /// Son N olayı al
  List<UserAnalytics> getLastNEvents(int n) {
    return _localEvents.length > n
        ? _localEvents.sublist(_localEvents.length - n)
        : _localEvents;
  }

  /// Belirli türdeki olayları filtrele
  List<UserAnalytics> getEventsByType(String eventName) {
    return _localEvents.where((e) => e.eventName == eventName).toList();
  }

  /// İstatistikleri al
  Map<String, int> getEventStatistics() {
    final stats = <String, int>{};
    for (var event in _localEvents) {
      stats[event.eventName] = (stats[event.eventName] ?? 0) + 1;
    }
    return stats;
  }

  /// Verileri local'de kaydet
  Future<void> _saveLocalEvents() async {
    final jsonList = _localEvents.map((e) => e.toJson()).toList();
    await _prefs.setString('analytics_events', jsonEncode(jsonList));
  }

  /// Local verilerini yükle
  Future<void> _loadLocalEvents() async {
    final jsonString = _prefs.getString('analytics_events');
    if (jsonString != null) {
      try {
        final jsonList = jsonDecode(jsonString) as List;
        _localEvents.clear();
        _localEvents.addAll(
          jsonList.map((e) => UserAnalytics.fromJson(e as Map<String, dynamic>)),
        );
      } catch (e) {
        print('Error loading analytics: $e');
      }
    }
  }

  /// Verileri temizle
  Future<void> clearAllEvents() async {
    _localEvents.clear();
    await _prefs.remove('analytics_events');
  }

  /// Verileri dışa aktar
  String exportAnalyticsAsJson() {
    return jsonEncode(_localEvents.map((e) => e.toJson()).toList());
  }
}

final analyticsService = AnalyticsService();
