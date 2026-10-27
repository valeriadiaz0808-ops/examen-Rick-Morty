import 'package:flutter/material.dart';

class ControlesPaginacion extends StatelessWidget {
  const ControlesPaginacion({
    super.key,
    required this.paginaActual,
    required this.totalPaginas,
    required this.cargando,
    required this.onAnterior,
    required this.onSiguiente,
  });

  final int paginaActual;
  final int totalPaginas;
  final bool cargando;
  final VoidCallback onAnterior;
  final VoidCallback onSiguiente;

  @override
  Widget build(BuildContext context) {
    final hayAnterior = paginaActual > 1 && !cargando;
    final haySiguiente = paginaActual < totalPaginas && !cargando;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          OutlinedButton.icon(
            onPressed: hayAnterior ? onAnterior : null,
            icon: const Icon(Icons.chevron_left),
            label: const Text('Anterior'),
          ),
          Text('Página $paginaActual de $totalPaginas'),
          OutlinedButton.icon(
            onPressed: haySiguiente ? onSiguiente : null,
            icon: const Icon(Icons.chevron_right),
            label: const Text('Siguiente'),
          ),
        ],
      ),
    );
  }
}