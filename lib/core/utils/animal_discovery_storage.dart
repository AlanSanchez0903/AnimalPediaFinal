import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'session_storage.dart';

/// Servicio local para persistir y consultar el progreso de descubrimiento.
///
/// Se guarda un mapa por usuario con el listado de ids descubiertos:
/// {
///   "usuario1": ["an_001", "an_003"],
///   "usuario2": ["an_002"]
/// }
class AnimalDiscoveryStorage {
  AnimalDiscoveryStorage._();

  static const String _discoveryByUserKey = 'discovered_animals_by_user_v2';

  static Future<Set<String>> loadDiscoveredIds() async {
    return loadDiscoveredIdsForCurrentUser();
  }

  static Future<Set<String>> loadDiscoveredIdsForCurrentUser() async {
    final username = await SessionStorage.getCurrentAuthenticatedUser();
    return loadDiscoveredIdsByUsername(username);
  }

  static Future<Set<String>> loadDiscoveredIdsByUsername(String? username) async {
    final normalizedUser = _normalizeUsername(username);
    if (normalizedUser == null) {
      return <String>{};
    }

    final discoveredByUser = await _loadDiscoveryMap();
    return discoveredByUser[normalizedUser] ?? <String>{};
  }

  static Future<void> saveDiscoveredIds(Set<String> ids) async {
    final username = await SessionStorage.getCurrentAuthenticatedUser();
    await saveDiscoveredIdsByUsername(ids, username);
  }

  static Future<void> saveDiscoveredIdsByUsername(Set<String> ids, String? username) async {
    final normalizedUser = _normalizeUsername(username);
    if (normalizedUser == null) {
      return;
    }

    final discoveredByUser = await _loadDiscoveryMap();
    discoveredByUser[normalizedUser] = ids;
    await _saveDiscoveryMap(discoveredByUser);
  }

  static Future<void> markAsDiscovered(String animalId) async {
    final username = await SessionStorage.getCurrentAuthenticatedUser();
    final currentIds = await loadDiscoveredIdsByUsername(username);
    if (currentIds.contains(animalId)) {
      return;
    }

    final updatedIds = <String>{...currentIds, animalId};
    await saveDiscoveredIdsByUsername(updatedIds, username);
  }

  static Future<Map<String, Set<String>>> _loadDiscoveryMap() async {
    final prefs = await SharedPreferences.getInstance();
    final rawJson = prefs.getString(_discoveryByUserKey);
    if (rawJson == null || rawJson.trim().isEmpty) {
      return <String, Set<String>>{};
    }

    final decoded = jsonDecode(rawJson);
    if (decoded is! Map<String, dynamic>) {
      return <String, Set<String>>{};
    }

    return <String, Set<String>>{
      for (final entry in decoded.entries)
        entry.key: ((entry.value as List<dynamic>? ?? <dynamic>[])
            .whereType<String>()
            .toSet()),
    };
  }

  static Future<void> _saveDiscoveryMap(Map<String, Set<String>> discoveredByUser) async {
    final prefs = await SharedPreferences.getInstance();
    final serializable = <String, List<String>>{
      for (final entry in discoveredByUser.entries)
        entry.key: entry.value.toList()..sort(),
    };

    await prefs.setString(_discoveryByUserKey, jsonEncode(serializable));
  }

  static String? _normalizeUsername(String? username) {
    final normalizedUser = (username ?? '').trim().toLowerCase();
    if (normalizedUser.isEmpty) {
      return null;
    }

    return normalizedUser;
  }
}
