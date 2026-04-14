import '../data/mock_animals.dart';
import '../models/animal.dart';

class AnimalApi {
  const AnimalApi();

  // Simula una petición remota para mantener la estructura académica.
  Future<List<Animal>> fetchAnimals() async {
    return Future.value(mockAnimals);
  }
}
