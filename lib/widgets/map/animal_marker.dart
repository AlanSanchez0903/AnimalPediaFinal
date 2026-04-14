import 'package:flutter/material.dart';

/// Marcador reutilizable para el mapa de Animalpedia.
///
/// - Si [isDiscovered] es false, se muestra modo misterioso.
/// - Si [isDiscovered] es true, se muestra modo descubierto.
class AnimalMarker extends StatelessWidget {
  const AnimalMarker({
    super.key,
    required this.isDiscovered,
    required this.onTap,
  });

  final bool isDiscovered;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final backgroundColor = isDiscovered ? const Color(0xFF37BFA7) : const Color(0xFF6C63FF);
    final icon = isDiscovered ? Icons.pets_rounded : Icons.help_outline_rounded;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.92), width: 2),
          boxShadow: const [
            BoxShadow(
              color: Colors.black54,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }
}
