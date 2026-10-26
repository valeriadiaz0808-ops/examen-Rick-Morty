import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/personaje.dart';

class PersonajeServicio {
  static const String _url = 'https://rickandmortyapi.com/api/character';

  /// Devuelve los personajes de la primera página (20).
  Future<List<Personaje>> obtenerPrimeraPagina() async {
    final respuesta =
        await http.get(Uri.parse(_url)).timeout(const Duration(seconds: 15));

    if (respuesta.statusCode != 200) {
      throw Exception('Error del servidor (${respuesta.statusCode})');
    }

    final datos = jsonDecode(respuesta.body) as Map<String, dynamic>;
    final resultados = datos['results'] as List;
    return resultados
        .map((e) => Personaje.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}