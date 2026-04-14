import 'package:flutter/material.dart';

import '../models/animal.dart';

/// Pantalla de detalle visual para un animal específico.
///
/// Recibe un [AnimalModel] por parámetro y presenta toda la información
/// principal con un estilo oscuro elegante.
class AnimalDetailScreen extends StatelessWidget {
  const AnimalDetailScreen({super.key, required this.animal});

  static const String routeName = '/animal-detail';

  final AnimalModel animal;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Valores por defecto para mantener una experiencia cuidada
    // incluso cuando la API/local storage entregue campos vacíos.
    final displayName = _valueOrFallback(
      animal.nombre,
      fallback: 'Especie sin nombre registrado',
    );
    final displayScientificName = _valueOrFallback(
      animal.nombreCientifico,
      fallback: 'Nomenclature pending',
    );
    final displayDescription = _valueOrFallback(
      animal.descripcion,
      fallback:
          'Aún no tenemos una descripción completa para esta especie. Sigue explorando para ampliar la ficha.',
    );
    final displayHabitat = _valueOrFallback(
      animal.habitat,
      fallback: 'Hábitat no documentado',
    );
    final displayDiet = _valueOrFallback(
      animal.dieta,
      fallback: 'Dieta no disponible',
    );
    final displayBiome = _valueOrFallback(
      animal.bioma,
      fallback: 'Bioma no clasificado',
    );
    final displayRegion = _valueOrFallback(
      animal.pais,
      fallback: 'Región sin registro oficial',
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle del animal'),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _AnimalHeroImage(imageUrl: animal.imagenUrl),
                  const SizedBox(height: 18),
                  Text(
                    displayName,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    displayScientificName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white70,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _InfoCard(
                    icon: Icons.notes_rounded,
                    title: 'Descripción',
                    value: displayDescription,
                    isMultiLine: true,
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.terrain_rounded,
                    title: 'Hábitat',
                    value: displayHabitat,
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.restaurant_menu_rounded,
                    title: 'Dieta',
                    value: displayDiet,
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.public_rounded,
                    title: 'Bioma',
                    value: displayBiome,
                  ),
                  const SizedBox(height: 10),
                  _InfoCard(
                    icon: Icons.place_rounded,
                    title: 'País o región',
                    value: displayRegion,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _valueOrFallback(String value, {required String fallback}) {
    if (value.trim().isEmpty) {
      return fallback;
    }

    return value.trim();
  }
}

class _AnimalHeroImage extends StatelessWidget {
  const _AnimalHeroImage({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl.trim().isNotEmpty;

    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A1A), Color(0xFF111111)],
        ),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.45),
            blurRadius: 22,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: hasImage
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const _ImageFallback(),
            )
          : const _ImageFallback(),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF222222), Color(0xFF141414)],
        ),
      ),
      child: const Center(
        child: Icon(
          Icons.pets_rounded,
          color: Colors.white54,
          size: 72,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    this.isMultiLine = false,
  });

  final IconData icon;
  final String title;
  final String value;
  final bool isMultiLine;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white.withOpacity(0.09)),
      ),
      child: Row(
        crossAxisAlignment: isMultiLine ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(
            height: 36,
            width: 36,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF8BB8FF), size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white70,
                    height: 1.38,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
