import 'package:flutter/material.dart';

class VistaError extends StatelessWidget {
  const VistaError({
    super.key,
    required this.onReintentar,
    this.mensaje = 'No se pudieron cargar los personajes. Revisa tu conexión.',
  });

  final VoidCallback onReintentar;
  final String mensaje;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 55),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}
