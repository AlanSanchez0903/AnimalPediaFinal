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
    List<DesApiAnimalDto> animalDtos = <DesApiAnimalDto>[];
    try {
      animalDtos = await _animalApi.fetchAnimals();
    } catch (_) {
      return <Animal>[];
    }

    Map<String, String> imageUrlsById = <String, String>{};
    try {
      final imageDtos = await _imageApi.fetchAnimalImages();
      imageUrlsById = <String, String>{
        for (final image in imageDtos) image.id: image.imagenUrl,
      };
    } catch (_) {
      imageUrlsById = <String, String>{};
    }

    Set<String> discoveredIds = <String>{};
    try {
      discoveredIds = await AnimalDiscoveryStorage.loadDiscoveredIdsForCurrentUser();
    } catch (_) {
      discoveredIds = <String>{};
    }

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
