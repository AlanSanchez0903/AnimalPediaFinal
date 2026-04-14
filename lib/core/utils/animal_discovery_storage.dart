import 'package:shared_preferences/shared_preferences.dart';

/// Servicio local para persistir y consultar el progreso de descubrimiento.
///
/// Se guarda únicamente el listado de ids de animales descubiertos.
class AnimalDiscoveryStorage {
  AnimalDiscoveryStorage._();

  static const String _discoveredAnimalsKey = 'discovered_animals_ids_v1';

  static Future<Set<String>> loadDiscoveredIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList(_discoveredAnimalsKey) ?? <String>[];
    return ids.toSet();
  }

  static Future<void> saveDiscoveredIds(Set<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_discoveredAnimalsKey, ids.toList()..sort());
  }

  static Future<void> markAsDiscovered(String animalId) async {
    final currentIds = await loadDiscoveredIds();
    if (currentIds.contains(animalId)) {
      return;
    }

    final updatedIds = <String>{...currentIds, animalId};
    await saveDiscoveredIds(updatedIds);
  }
}
