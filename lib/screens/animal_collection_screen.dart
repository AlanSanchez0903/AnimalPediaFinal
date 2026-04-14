import 'package:flutter/material.dart';

import '../models/animal.dart';
import '../repositories/animal_repository.dart';
import '../widgets/animal_card.dart';
import 'animal_detail_screen.dart';

enum CollectionTab { discovered, undiscovered }

class CollectionScreen extends StatefulWidget {
  const CollectionScreen({super.key, this.initialTab = CollectionTab.discovered});

  static const String routeName = '/collection';

  final CollectionTab initialTab;

  @override
  State<CollectionScreen> createState() => _CollectionScreenState();
}

/// Compatibilidad con navegación existente.
class AnimalCollectionScreen extends StatelessWidget {
  const AnimalCollectionScreen({
    super.key,
    this.showOnlyDiscovered = false,
    this.showOnlyUndiscovered = false,
  });

  static const String routeName = CollectionScreen.routeName;

  final bool showOnlyDiscovered;
  final bool showOnlyUndiscovered;

  @override
  Widget build(BuildContext context) {
    final initialTab = showOnlyUndiscovered ? CollectionTab.undiscovered : CollectionTab.discovered;

    return CollectionScreen(initialTab: initialTab);
  }
}

class _CollectionScreenState extends State<CollectionScreen> {
  final AnimalRepository _repository = AnimalRepository();

  List<Animal> _animals = <Animal>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnimals();
  }

  Future<void> _loadAnimals() async {
    final animals = await _repository.getAnimals();

    if (!mounted) {
      return;
    }

    setState(() {
      _animals = animals;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: widget.initialTab == CollectionTab.discovered ? 0 : 1,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Colección Animalpedia'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Descubiertos'),
              Tab(text: 'Por descubrir'),
            ],
          ),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _CollectionGrid(
                    animals: _animals.where((animal) => animal.descubierto).toList(),
                    isDiscoveredSection: true,
                    onTapAnimal: _handleDiscoveredAnimalTap,
                  ),
                  _CollectionGrid(
                    animals: _animals.where((animal) => !animal.descubierto).toList(),
                    isDiscoveredSection: false,
                    onTapAnimal: _handleUndiscoveredAnimalTap,
                  ),
                ],
              ),
      ),
    );
  }

  void _handleDiscoveredAnimalTap(Animal animal) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnimalDetailScreen(animal: animal),
      ),
    );
  }

  void _handleUndiscoveredAnimalTap(Animal _) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Descúbrelo primero en el mapa.')),
    );
  }
}

class _CollectionGrid extends StatelessWidget {
  const _CollectionGrid({
    required this.animals,
    required this.isDiscoveredSection,
    required this.onTapAnimal,
  });

  final List<Animal> animals;
  final bool isDiscoveredSection;
  final ValueChanged<Animal> onTapAnimal;

  @override
  Widget build(BuildContext context) {
    if (animals.isEmpty) {
      return _EmptyCollectionState(isDiscoveredSection: isDiscoveredSection);
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final crossAxisCount = width >= 1080
            ? 4
            : width >= 780
                ? 3
                : width >= 560
                    ? 2
                    : 1;

        return GridView.builder(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          itemCount: animals.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            mainAxisExtent: 230,
          ),
          itemBuilder: (context, index) {
            final animal = animals[index];
            return AnimalCard(
              animal: animal,
              isDiscovered: isDiscoveredSection,
              onTap: () => onTapAnimal(animal),
            );
          },
        );
      },
    );
  }
}

class _EmptyCollectionState extends StatelessWidget {
  const _EmptyCollectionState({required this.isDiscoveredSection});

  final bool isDiscoveredSection;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          isDiscoveredSection
              ? 'Aún no tienes animales descubiertos.\nExplora el mapa para comenzar tu pokédex.'
              : '¡Excelente! Ya no quedan animales por descubrir.',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.white70),
        ),
      ),
    );
  }
}
