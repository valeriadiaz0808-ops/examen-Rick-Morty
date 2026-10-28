import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritosService extends ChangeNotifier {
  final Set<int> _favoritos = {};
  String? _usuarioActual;

  Set<int> get favoritos => Set.unmodifiable(_favoritos);

  bool esFavorito(int personajeId) {
    return _favoritos.contains(personajeId);
  }

  Future<void> cargarFavoritos(String usuarioId) async {
    final prefs = await SharedPreferences.getInstance();

    _usuarioActual = usuarioId;
    _favoritos.clear();

    final guardados = prefs.getStringList('favoritos_$usuarioId') ?? [];

    for (final id in guardados) {
      final numero = int.tryParse(id);
      if (numero != null) {
        _favoritos.add(numero);
      }
    }

    notifyListeners();
  }

  Future<void> alternarFavorito(int personajeId) async {
    final usuarioId = _usuarioActual;

    if (usuarioId == null) {
      throw StateError('No hay un usuario seleccionado');
    }

    final prefs = await SharedPreferences.getInstance();
    final nuevos = Set<int>.from(_favoritos);

    if (nuevos.contains(personajeId)) {
      nuevos.remove(personajeId);
    } else {
      nuevos.add(personajeId);
    }

    final guardado = await prefs.setStringList(
      'favoritos_$usuarioId',
      nuevos.map((id) => id.toString()).toList(),
    );

    if (!guardado) {
      throw StateError('No se pudieron guardar los favoritos');
    }

    _favoritos
      ..clear()
      ..addAll(nuevos);

    notifyListeners();
  }

  void cerrarSesion() {
    _usuarioActual = null;
    _favoritos.clear();
    notifyListeners();
  }
}
