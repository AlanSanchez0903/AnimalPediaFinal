import 'package:shared_preferences/shared_preferences.dart';

import 'session_storage.dart';

/// Servicio local para persistir y consultar el progreso de descubrimiento.
///
/// Se guarda únicamente el listado de ids de animales descubiertos.
class AnimalDiscoveryStorage {
  AnimalDiscoveryStorage._();

  static const String _discoveredAnimalsKeyPrefix = 'discovered_animals_ids_v1';

  static Future<Set<String>> loadDiscoveredIds() async {
    return loadDiscoveredIdsForCurrentUser();
  }

  static Future<Set<String>> loadDiscoveredIdsForCurrentUser() async {
    final username = await SessionStorage.getRegisteredUsername();
    return loadDiscoveredIdsByUsername(username);
  }

  static Future<Set<String>> loadDiscoveredIdsByUsername(String? username) async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_buildDiscoveredKey(username)) ?? <String>[];
    return ids.toSet();
  }

  static Future<void> saveDiscoveredIds(Set<String> ids) async {
    final username = await SessionStorage.getRegisteredUsername();
    await saveDiscoveredIdsByUsername(ids, username);
  }

  static Future<void> saveDiscoveredIdsByUsername(Set<String> ids, String? username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_buildDiscoveredKey(username), ids.toList()..sort());
  }

  static Future<void> markAsDiscovered(String animalId) async {
    final username = await SessionStorage.getRegisteredUsername();
    final currentIds = await loadDiscoveredIdsByUsername(username);
    if (currentIds.contains(animalId)) {
      return;
    }

    final updatedIds = <String>{...currentIds, animalId};
    await saveDiscoveredIdsByUsername(updatedIds, username);
  }

  static String _buildDiscoveredKey(String? username) {
    final normalizedUser = (username ?? '').trim().toLowerCase();
    if (normalizedUser.isEmpty) {
      return '${_discoveredAnimalsKeyPrefix}_guest';
    }

    return '${_discoveredAnimalsKeyPrefix}_$normalizedUser';
  }
}
