import '../api/animal_api.dart';
import '../api/animal_image_api.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/animal_discovery_storage.dart';
import '../models/animal.dart';

class AnimalRepository {
  AnimalRepository({AnimalApi? animalApi, AnimalImageApi? imageApi})
      : _animalApi = animalApi ?? AnimalApi(baseUrl: AppConstants.desApiBaseUrl),
        _imageApi = imageApi ?? AnimalImageApi(baseUrl: AppConstants.imgApiBaseUrl);

  final AnimalApi _animalApi;
  final AnimalImageApi _imageApi;

  Future<List<Animal>> getAnimals() async {
    final animals = await _animalApi.fetchAnimals();
    final imageUrlsById = await _imageApi.fetchAnimalImageUrls();
    final discoveredIds = await AnimalDiscoveryStorage.loadDiscoveredIds();

    return animals
        .map(
          (animal) => animal.copyWith(
            imagenUrl: imageUrlsById[animal.id] ?? '',
            descubierto: discoveredIds.contains(animal.id),
          ),
        )
        .toList();
  }

  Future<void> markAsDiscovered(String animalId) {
    return AnimalDiscoveryStorage.markAsDiscovered(animalId);
  }
}
