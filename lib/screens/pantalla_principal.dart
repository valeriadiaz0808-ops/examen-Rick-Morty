import 'package:flutter/material.dart';

import '../models/personaje.dart';
import '../services/personaje_servicio.dart';
import '../widgets/controles_paginacion.dart';
import '../widgets/imagen_personaje.dart';
import 'pantalla_detalle.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
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
    return _personajes.where((p) => p.nombre.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick & Morty')),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: TextField(
                controller: _controlador,
                decoration: InputDecoration(
                  hintText: 'Buscar por nombre...',
                  helperText: 'La búsqueda se aplica solo a la página actual',
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
                onChanged: (valor) => setState(() => _consulta = valor),
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
      return const Center(child: CircularProgressIndicator());
    }

    if (_hayError) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48),
            const SizedBox(height: 12),
            const Text('No se pudieron cargar los personajes'),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () => _cargarPagina(_pagina),
              child: const Text('Reintentar'),
            ),
          ],
        ),
      );
    }

    final personajes = _filtrados;

    if (personajes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.search_off, size: 48),
              SizedBox(height: 12),
              Text(
                'No se encontraron personajes con ese nombre en esta página.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: personajes.length,
      itemBuilder: (context, index) {
        final p = personajes[index];
        return Card(
          child: ListTile(
            contentPadding: const EdgeInsets.all(10),
            leading: ImagenPersonaje(url: p.imagen),
            title: Text(p.nombre),
            subtitle: Row(
              children: [
                Icon(Icons.circle, size: 10, color: p.colorEstado),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    '${p.estadoTexto} · ${p.especie}',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PantallaDetalle(personaje: p),
                ),
              );
            },
          ),
        );
      },
    );
  }
}