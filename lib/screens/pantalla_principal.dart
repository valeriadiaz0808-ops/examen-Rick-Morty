import 'package:flutter/material.dart';

import '../models/personaje.dart';
import '../services/personaje_servicio.dart';
import '../widgets/imagen_personaje.dart';
import 'pantalla_detalle.dart';

class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() => _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  final _servicio = PersonajeServicio();
  late Future<List<Personaje>> _futuro;

  @override
  void initState() {
    super.initState();
    _futuro = _servicio.obtenerPrimeraPagina();
  }

  void _reintentar() {
    setState(() {
      _futuro = _servicio.obtenerPrimeraPagina();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick & Morty')),
      body: FutureBuilder<List<Personaje>>(
        future: _futuro,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: 12),
                  const Text('No se pudieron cargar los personajes'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _reintentar,
                    child: const Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          final personajes = snapshot.data ?? [];
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
        },
      ),
    );
  }
}
