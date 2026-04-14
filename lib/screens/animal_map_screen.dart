import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../models/animal.dart';
import '../repositories/animal_repository.dart';
import 'animal_detail_screen.dart';
import '../widgets/map/animal_marker.dart';

/// Pantalla principal del mapa (versión 2D estable para enfoque estudiantil).
class AnimalMapScreen extends StatefulWidget {
  const AnimalMapScreen({super.key});

  static const String routeName = '/animal-map';

  @override
  State<AnimalMapScreen> createState() => _AnimalMapScreenState();
}

class _AnimalMapScreenState extends State<AnimalMapScreen> {
  final AnimalRepository _repository = AnimalRepository();

  List<Animal> _animals = <Animal>[];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMapData();
  }

  Future<void> _loadMapData() async {
    final animals = await _repository.getAnimals();

    if (!mounted) {
      return;
    }

    setState(() {
      _animals = animals;
      _isLoading = false;
    });
  }

  Future<void> _onAnimalTap(Animal animal) async {
    Animal selectedAnimal = animal;

    if (!animal.descubierto) {
      await _repository.markAsDiscovered(animal.id);

      if (mounted) {
        setState(() {
          _animals = _animals
              .map(
                (item) => item.id == animal.id ? item.copyWith(descubierto: true) : item,
              )
              .toList();
        });

        selectedAnimal = selectedAnimal.copyWith(descubierto: true);
      }
    }

    if (!mounted) {
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnimalDetailScreen(animal: selectedAnimal),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final discoveredCount = _animals.where((animal) => animal.descubierto).length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa Animalpedia'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : LayoutBuilder(
              builder: (context, constraints) {
                final horizontalMargin = constraints.maxWidth < 380 ? 8.0 : 12.0;

                return Column(
                  children: [
                    _MapProgressHeader(
                      discoveredCount: discoveredCount,
                      totalCount: _animals.length,
                      horizontalMargin: horizontalMargin,
                    ),
                    Expanded(
                      child: FlutterMap(
                        options: const MapOptions(
                          initialCenter: LatLng(18, 0),
                          initialZoom: 2.0,
                          minZoom: 1.5,
                          maxZoom: 6.0,
                        ),
                        children: [
                          TileLayer(
                            // Tema oscuro sobrio sin API key.
                            urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                            subdomains: const ['a', 'b', 'c', 'd'],
                            userAgentPackageName: 'com.example.animalpedia',
                          ),
                          MarkerLayer(
                            markers: _animals
                                .map(
                                  (animal) => Marker(
                                    point: LatLng(animal.latitud, animal.longitud),
                                    width: 42,
                                    height: 42,
                                    child: AnimalMarker(
                                      isDiscovered: animal.descubierto,
                                      onTap: () => _onAnimalTap(animal),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }
}

class _MapProgressHeader extends StatelessWidget {
  const _MapProgressHeader({
    required this.discoveredCount,
    required this.totalCount,
    required this.horizontalMargin,
  });

  final int discoveredCount;
  final int totalCount;
  final double horizontalMargin;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(horizontalMargin, 12, horizontalMargin, 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.06),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Progreso de descubrimiento',
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            '$discoveredCount / $totalCount animales descubiertos',
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}
