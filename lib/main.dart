import 'package:flutter/material.dart';

import 'services/favoritos_service.dart';
import 'screens/pantalla_principal.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<MiApp> {
  final FavoritosService _favoritosService = FavoritosService();

  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _iniciarFavoritos();
  }

  Future<void> _iniciarFavoritos() async {
    try {
      // Usuario local temporal mientras no exista login.
      await _favoritosService.cargarFavoritos('usuario_local');
    } catch (e) {
      debugPrint('Error al cargar favoritos: $e');
    } finally {
      if (mounted) {
        setState(() {
          _cargando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _favoritosService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rick & Morty',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.green,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: _cargando
          ? const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : PantallaPrincipal(
              favoritosService: _favoritosService,
            ),
    );
  }
}
