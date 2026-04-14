import '../api/animal_api.dart';
import '../core/utils/animal_discovery_storage.dart';
import '../models/animal.dart';

class AnimalRepository {
  AnimalRepository({AnimalApi? api}) : _api = api ?? const AnimalApi();

  final AnimalApi _api;

  Future<List<Animal>> getAnimals() async {
    final animals = await _api.fetchAnimals();
    final discoveredIds = await AnimalDiscoveryStorage.loadDiscoveredIds();

    return animals
        .map(
          (animal) => animal.copyWith(descubierto: discoveredIds.contains(animal.id)),
        )
        .toList();
  }

  Future<void> markAsDiscovered(String animalId) {
    return AnimalDiscoveryStorage.markAsDiscovered(animalId);
  }
}
