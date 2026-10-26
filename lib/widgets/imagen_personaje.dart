import 'package:flutter/material.dart';

/// Imagen de red con indicador de carga y un icono si falla.
class ImagenPersonaje extends StatelessWidget {
  const ImagenPersonaje({
    super.key,
    required this.url,
    this.tamano = 70,
    this.radio = 12,
  });

  final String url;
  final double tamano;
  final double radio;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radio),
      child: Image.network(
        url,
        width: tamano,
        height: tamano,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progreso) {
          if (progreso == null) return child;
          return SizedBox(
            width: tamano,
            height: tamano,
            child: const Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: tamano,
            height: tamano,
            color: Colors.grey.shade800,
            child: const Icon(Icons.broken_image),
          );
        },
      ),
    );
  }
}