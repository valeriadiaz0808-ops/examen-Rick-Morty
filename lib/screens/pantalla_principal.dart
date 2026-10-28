
import 'package:flutter/material.dart';

import '../models/personaje.dart';
import '../services/personaje_servicio.dart';
import '../services/favoritos_service.dart';

import '../widgets/controles_paginacion.dart';
import '../widgets/imagen_personaje.dart';
import '../widgets/vista_error.dart';
import '../widgets/vista_vacio.dart';

import 'pantalla_detalle.dart';
import 'pantalla_favorito.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({
    super.key,
    required this.favoritosService,
  });

  final FavoritosService favoritosService;

  @override
  State<PantallaPrincipal> createState() =>
      _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final _servicio = PersonajeServicio();
  final _controlador = TextEditingController();

  List<Personaje> _personajes = [];
  int _pagina = 1;
  int _totalPaginas = 1;
  String _consulta = '';
  bool _cargando = true;
  bool _hayError = false;

  @override
  void initState() {
    super.initState();
    _cargarPagina(1);
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Future<void> _cargarPagina(int pagina) async {
    setState(() {
      _pagina = pagina;
      _cargando = true;
      _hayError = false;
    });

    try {
      final resultado = await _servicio.obtenerPagina(pagina);

      if (!mounted) return;

      _controlador.clear();

      setState(() {
        _personajes = resultado.personajes;
        _totalPaginas = resultado.totalPaginas;
        _consulta = '';
        _cargando = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        _hayError = true;
        _cargando = false;
      });
    }
  }

  List<Personaje> get _filtrados {
    final q = _consulta.trim().toLowerCase();

    if (q.isEmpty) return _personajes;

    return _personajes
        .where((p) => p.nombre.toLowerCase().contains(q))
        .toList();
  }

  Future<void> _alternarFavorito(int id) async {
    try {
      await widget.favoritosService.alternarFavorito(id);
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo guardar el favorito.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rick & Morty'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            tooltip: 'Mis favoritos',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaFavorito(
                    favoritosService: widget.favoritosService,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: TextField(
                controller: _controlador,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre...',
                  helperText:
                      'La búsqueda se aplica solo a la página actual',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _consulta.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: 'Borrar búsqueda',
                          onPressed: () {
                            _controlador.clear();
                            setState(() => _consulta = '');
                          },
                        ),
                  border: const OutlineInputBorder(),
                ),
                onChanged: (valor) {
                  setState(() => _consulta = valor);
                },
              ),
            ),
            Expanded(child: _construirContenido()),
            if (!_hayError)
              ControlesPaginacion(
                paginaActual: _pagina,
                totalPaginas: _totalPaginas,
                cargando: _cargando,
                onAnterior: () => _cargarPagina(_pagina - 1),
                onSiguiente: () => _cargarPagina(_pagina + 1),
              ),
          ],
        ),
      ),
    );
  }

  Widget _construirContenido() {
    if (_cargando) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (_hayError) {
      return VistaError(
        onReintentar: () => _cargarPagina(_pagina),
      );
    }

    final personajes = _filtrados;

    if (personajes.isEmpty) {
      return const VistaVacio(
        mensaje:
            'No se encontraron personajes con ese nombre en esta página.',
      );
    }

    return AnimatedBuilder(
      animation: widget.favoritosService,
      builder: (context, _) {
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: personajes.length,
          itemBuilder: (context, index) {
            final p = personajes[index];

            final esFavorito =
                widget.favoritosService.esFavorito(p.id);

            return Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(10),
                leading: ImagenPersonaje(url: p.imagen),
                title: Text(p.nombre),
                subtitle: Row(
                  children: [
                    Icon(
                      Icons.circle,
                      size: 10,
                      color: p.colorEstado,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        '${p.estadoTexto} · ${p.especie}',
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: Icon(
                    esFavorito
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: esFavorito ? Colors.red : null,
                  ),
                  tooltip: esFavorito
                      ? 'Quitar de favoritos'
                      : 'Agregar a favoritos',
                  onPressed: () => _alternarFavorito(p.id),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                     
builder: (_) => PantallaDetalle(
  personaje: p,
  favoritosService: widget.favoritosService,
),

                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
