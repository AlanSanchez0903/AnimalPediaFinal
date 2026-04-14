import 'package:flutter/material.dart';

import '../models/animal.dart';

class AnimalCard extends StatelessWidget {
  const AnimalCard({
    super.key,
    required this.animal,
    required this.isDiscovered,
    this.onTap,
  });

  final Animal animal;
  final bool isDiscovered;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: isDiscovered
                ? const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF191919), Color(0xFF0F0F0F)],
                  )
                : const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF111111), Color(0xFF090909)],
                  ),
            border: Border.all(
              color: isDiscovered ? Colors.white.withOpacity(0.10) : Colors.white.withOpacity(0.06),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.34),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: isDiscovered ? _DiscoveredContent(animal: animal, theme: theme) : _LockedContent(theme: theme),
          ),
        ),
      ),
    );
  }
}

class _DiscoveredContent extends StatelessWidget {
  const _DiscoveredContent({required this.animal, required this.theme});

  final Animal animal;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            animal.imagenUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              color: Colors.white.withOpacity(0.06),
              child: const Icon(Icons.broken_image_rounded, color: Colors.white54),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          animal.nombre,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          '${animal.pais} · ${animal.bioma}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}

class _LockedContent extends StatelessWidget {
  const _LockedContent({required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.white.withOpacity(0.04),
            ),
            child: const Icon(
              Icons.help_outline_rounded,
              color: Colors.white54,
              size: 50,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Animal desconocido',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(color: Colors.white70, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          'Descúbrelo en el mapa para revelar su ficha.',
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
        ),
      ],
    );
  }
}
