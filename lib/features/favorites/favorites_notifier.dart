import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/services/achievement_service.dart';
import '../../core/database/app_database.dart';

class FavoritesNotifier extends StateNotifier<Set<String>> {
  FavoritesNotifier() : super(const {});

  static const _prefsKey = 'favorite_map_ids';
  SharedPreferences? _prefs;
  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs?.getStringList(_prefsKey) ?? [];
    state = {...stored};
  }

  bool isFavorite(String id) => state.contains(id);

  Future<void> toggle(String id) async {
    final next = Set<String>.from(state);
    if (!next.add(id)) {
      next.remove(id);
    }
    state = next;
    await _prefs?.setStringList(_prefsKey, state.toList());
    
    // Check favorite achievement
    if (state.length >= 10) {
      final achievementService = AchievementService(AppDatabase());
      await achievementService.unlockAchievement('favorite_collector');
    }
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    final notifier = FavoritesNotifier();
    notifier.bootstrap();
    return notifier;
  },
);
