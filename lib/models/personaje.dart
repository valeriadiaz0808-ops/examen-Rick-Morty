import 'package:flutter/material.dart';

class Personaje {
  final int id;
  final String nombre;
  final String estado;
  final String especie;
  final String genero;
  final String origen;
  final String ubicacion;
  final String imagen;
  final int cantidadEpisodios;

  const Personaje({
    required this.id,
    required this.nombre,
    required this.estado,
    required this.especie,
    required this.genero,
    required this.origen,
    required this.ubicacion,
    required this.imagen,
    required this.cantidadEpisodios,
  });

  factory Personaje.fromJson(Map<String, dynamic> json) {
    return Personaje(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? 'Desconocido',
      estado: json['status'] ?? 'unknown',
      especie: json['species'] ?? 'unknown',
      genero: json['gender'] ?? 'unknown',
      origen: json['origin']?['name'] ?? 'unknown',
      ubicacion: json['location']?['name'] ?? 'unknown',
      imagen: json['image'] ?? '',
      cantidadEpisodios: (json['episode'] as List?)?.length ?? 0,
    );
  }

  String get estadoTexto {
    switch (estado.toLowerCase()) {
      case 'alive':
        return 'Vivo';
      case 'dead':
        return 'Muerto';
      default:
        return 'Desconocido';
    }
  }

  Color get colorEstado {
    switch (estado.toLowerCase()) {
      case 'alive':
        return Colors.green;
      case 'dead':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}