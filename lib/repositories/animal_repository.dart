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
    final animalDtos = await _animalApi.fetchAnimals();
    final imageDtos = await _imageApi.fetchAnimalImages();
    final discoveredIds = await AnimalDiscoveryStorage.loadDiscoveredIds();

    final imageUrlsById = <String, String>{
      for (final image in imageDtos) image.id: image.imagenUrl,
    };

    return animalDtos
        .map(
          (dto) => AnimalModel(
            id: dto.id,
            nombre: dto.nombre,
            nombreCientifico: dto.nombreCientifico,
            descripcion: dto.descripcion,
            habitat: dto.habitat,
            dieta: dto.dieta,
            latitud: dto.latitud,
            longitud: dto.longitud,
            imagenUrl: imageUrlsById[dto.id] ?? '',
            descubierto: discoveredIds.contains(dto.id),
            bioma: dto.bioma,
            pais: dto.pais,
          ),
        )
        .toList(growable: false);
  }

  Future<void> markAsDiscovered(String animalId) {
    return AnimalDiscoveryStorage.markAsDiscovered(animalId);
  }
}
