import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class SearchFavoritesNotifier extends StateNotifier<Map<String, String>> {
  SearchFavoritesNotifier() : super({});

  static const _prefsKey = 'search_favorites';
  SharedPreferences? _prefs;
  bool _bootstrapped = false;

  Future<void> bootstrap() async {
    if (_bootstrapped) return;
    _bootstrapped = true;
    _prefs = await SharedPreferences.getInstance();
    final stored = _prefs?.getString(_prefsKey);
    if (stored != null) {
      try {
        final decoded = jsonDecode(stored) as Map<String, dynamic>;
        state = decoded.cast<String, String>();
      } catch (e) {
        state = {};
      }
    }
  }

  Future<void> addFavorite(String id, String address) async {
    final next = Map<String, String>.from(state);
    next[id] = address;
    state = next;
    await _prefs?.setString(_prefsKey, jsonEncode(state));
  }

  Future<void> removeFavorite(String id) async {
    final next = Map<String, String>.from(state);
    next.remove(id);
    state = next;
    await _prefs?.setString(_prefsKey, jsonEncode(state));
  }

  String? getAddress(String id) => state[id];
}

final searchFavoritesProvider = StateNotifierProvider<SearchFavoritesNotifier, Map<String, String>>(
  (ref) {
    final notifier = SearchFavoritesNotifier();
    notifier.bootstrap();
    return notifier;
  },
);
