import 'package:flutter/material.dart';

import '../../models/animal.dart';

/// Bottom sheet con información del animal tocado en el mapa.
class AnimalDetailSheet extends StatelessWidget {
  const AnimalDetailSheet({
    super.key,
    required this.animal,
    required this.isDiscovered,
  });

  final Animal animal;
  final bool isDiscovered;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 46,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(
                  isDiscovered ? Icons.pets_rounded : Icons.help_outline_rounded,
                  color: isDiscovered ? const Color(0xFF37BFA7) : const Color(0xFFB7B3FF),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    animal.nombre,
                    style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              animal.nombreCientifico,
              style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white70, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 14),
            Text(animal.descripcion, style: theme.textTheme.bodyMedium),
            const SizedBox(height: 12),
            _MetaLine(label: 'País', value: animal.pais),
            _MetaLine(label: 'Bioma', value: animal.bioma),
            _MetaLine(label: 'Hábitat', value: animal.habitat),
            _MetaLine(label: 'Dieta', value: animal.dieta),
            const SizedBox(height: 14),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: (isDiscovered ? const Color(0xFF37BFA7) : const Color(0xFF6C63FF)).withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: (isDiscovered ? const Color(0xFF37BFA7) : const Color(0xFF6C63FF)).withOpacity(0.45),
                ),
              ),
              child: Text(
                isDiscovered
                    ? 'Descubierto ✅ Se guardó en tu progreso local.'
                    : 'Marcado como pendiente.',
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetaLine extends StatelessWidget {
  const _MetaLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: RichText(
        text: TextSpan(
          style: theme.textTheme.bodyMedium,
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.white),
            ),
            TextSpan(text: value, style: const TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}
