import 'package:flutter/material.dart';

import '../models/personaje.dart';
import '../services/favoritos_service.dart';
import '../widgets/imagen_personaje.dart';

class PantallaDetalle extends StatelessWidget {
  const PantallaDetalle({
    super.key,
    required this.personaje,
    required this.favoritosService,
  });

  final Personaje personaje;
  final FavoritosService favoritosService;

  Future<void> _alternarFavorito(BuildContext context) async {
    try {
      await favoritosService.alternarFavorito(personaje.id);
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo actualizar el favorito.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = personaje;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.nombre),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Volver',
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          AnimatedBuilder(
            animation: favoritosService,
            builder: (context, _) {
              final esFavorito = favoritosService.esFavorito(p.id);

              return IconButton(
                icon: Icon(
                  esFavorito ? Icons.favorite : Icons.favorite_border,
                  color: esFavorito ? Colors.red : null,
                ),
                tooltip:
                    esFavorito ? 'Quitar de favoritos' : 'Agregar a favoritos',
                onPressed: () => _alternarFavorito(context),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: ImagenPersonaje(
              url: p.imagen,
              tamano: 220,
              radio: 20,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            p.nombre,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.circle,
                size: 12,
                color: p.colorEstado,
              ),
              const SizedBox(width: 6),
              Text(p.estadoTexto),
            ],
          ),
          const SizedBox(height: 20),
          _FilaInfo(
            icono: Icons.pets,
            etiqueta: 'Especie',
            valor: p.especie,
          ),
          _FilaInfo(
            icono: Icons.person,
            etiqueta: 'Género',
            valor: p.genero,
          ),
          _FilaInfo(
            icono: Icons.public,
            etiqueta: 'Origen',
            valor: p.origen,
          ),
          _FilaInfo(
            icono: Icons.place,
            etiqueta: 'Última ubicación',
            valor: p.ubicacion,
          ),
          _FilaInfo(
            icono: Icons.movie,
            etiqueta: 'Episodios',
            valor: '${p.cantidadEpisodios}',
          ),
          const SizedBox(height: 20),
          OutlinedButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
            label: const Text('Volver al catálogo'),
          ),
        ],
      ),
    );
  }
}

class _FilaInfo extends StatelessWidget {
  const _FilaInfo({
    required this.icono,
    required this.etiqueta,
    required this.valor,
  });

  final IconData icono;
  final String etiqueta;
  final String valor;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icono),
        title: Text(etiqueta),
        subtitle: Text(valor),
      ),
    );
  }
}
