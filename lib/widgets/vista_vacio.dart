import 'package:flutter/material.dart';

class VistaVacio extends StatelessWidget {
  const VistaVacio({
    super.key,
    this.mensaje = 'No se encontraron personajes.',
    this.icono = Icons.search_off,
  });

  final String mensaje;
  final IconData icono;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icono,
              size: 55,
              color: Colors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              mensaje,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
