import 'package:flutter/material.dart';

import '../models/personaje.dart';
import '../services/personaje_servicio.dart';
import '../services/favoritos_service.dart';
import '../widgets/imagen_personaje.dart';
import '../widgets/vista_error.dart';
import '../widgets/vista_vacio.dart';
import 'pantalla_detalle.dart';

class PantallaFavorito extends StatefulWidget {
  const PantallaFavorito({
    super.key,
    required this.favoritosService,
  });

  final FavoritosService favoritosService;

  @override
  State<PantallaFavorito> createState() => _PantallaFavoritoState();
}

class _PantallaFavoritoState extends State<PantallaFavorito> {
  final _api = PersonajeServicio();

  List<Personaje> _personajes = [];
  bool _cargando = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    widget.favoritosService.addListener(_cargar);
    _cargar();
  }

  @override
  void dispose() {
    widget.favoritosService.removeListener(_cargar);
    super.dispose();
  }

  Future<void> _cargar() async {
    final ids = widget.favoritosService.favoritos.toList();

    setState(() {
      _cargando = true;
      _error = false;
    });

    if (ids.isEmpty) {
      setState(() {
        _personajes = [];
        _cargando = false;
      });
      return;
    }

    try {
      final resultado = await _api.obtenerPorIds(ids);

      if (!mounted) return;

      setState(() {
        _personajes = resultado;
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _error = true;
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis favoritos'),
      ),
      body: _construirContenido(),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_error) {
      return VistaError(
        onReintentar: _cargar,
      );
    }

    if (_personajes.isEmpty) {
      return const VistaVacio(
        mensaje: 'Todavía no tienes personajes favoritos.',
        icono: Icons.favorite_border,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: _personajes.length,
      itemBuilder: (context, index) {
        final personaje = _personajes[index];

        return Card(
          child: ListTile(
            leading: ImagenPersonaje(
              url: personaje.imagen,
            ),
            title: Text(personaje.nombre),
            subtitle: Text(
              '${personaje.estadoTexto} · ${personaje.especie}',
            ),
            trailing: IconButton(
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              ),
              onPressed: () async {
                try {
                  await widget.favoritosService.alternarFavorito(personaje.id);
                } catch (_) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'No se pudo actualizar el favorito.',
                      ),
                    ),
                  );
                }
              },
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaDetalle(
                    personaje: personaje,
                    favoritosService: widget.favoritosService,
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
