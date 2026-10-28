import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/personaje.dart';

class PersonajeServicio {
  static const String _url = 'https://rickandmortyapi.com/api/character';

  /// Devuelve los personajes de la página indicada y el total de páginas.
  Future<({List<Personaje> personajes, int totalPaginas})> obtenerPagina(
      int pagina) async {
    final respuesta = await http
        .get(Uri.parse('$_url?page=$pagina'))
        .timeout(const Duration(seconds: 15));

    if (respuesta.statusCode != 200) {
      throw Exception('Error del servidor (${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final info = datos['info'] as Map<String, dynamic>? ?? {};
    final resultados = datos['results'] as List? ?? [];

    return (
      personajes: resultados
          .map((e) => Personaje.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalPaginas: info['pages'] as int? ?? 1,
    );
  }

  Future<List<Personaje>> obtenerPorIds(List<int> ids) async {
    if (ids.isEmpty) return [];

    final respuesta = await http
        .get(
          Uri.parse('$_url/${ids.join(",")}'),
        )
        .timeout(const Duration(seconds: 15));

    if (respuesta.statusCode != 200) {
      throw Exception('No se pudieron cargar los favoritos');
    }

    final datos = jsonDecode(respuesta.body);

    if (datos is List) {
      return datos
          .map((item) => Personaje.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return [
      Personaje.fromJson(datos as Map<String, dynamic>),
    ];
  }
}
