import 'dart:convert';

import 'package:http/http.dart' as http;

class AnimalApi {
  AnimalApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<DesApiAnimalDto>> fetchAnimals() async {
    final uri = Uri.parse('$baseUrl/animals');
    final response = await _client.get(uri, headers: const {'Accept': 'application/json'});

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AnimalApiException(
        'Error consultando desAPI1: ${response.statusCode} ${response.reasonPhrase ?? ''}'.trim(),
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const AnimalApiException('Respuesta inválida de desAPI1: se esperaba una lista de animales.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(DesApiAnimalDto.fromJson)
        .toList(growable: false);
  }
}

class DesApiAnimalDto {
  const DesApiAnimalDto({
    required this.id,
    required this.nombre,
    required this.nombreCientifico,
    required this.descripcion,
    required this.habitat,
    required this.dieta,
    required this.latitud,
    required this.longitud,
    required this.bioma,
    required this.pais,
  });

  final String id;
  final String nombre;
  final String nombreCientifico;
  final String descripcion;
  final String habitat;
  final String dieta;
  final double latitud;
  final double longitud;
  final String bioma;
  final String pais;

  factory DesApiAnimalDto.fromJson(Map<String, dynamic> json) {
    return DesApiAnimalDto(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      nombreCientifico: json['nombreCientifico']?.toString() ?? '',
      descripcion: json['descripcion']?.toString() ?? '',
      habitat: json['habitat']?.toString() ?? '',
      dieta: json['dieta']?.toString() ?? '',
      latitud: _toDouble(json['latitud']),
      longitud: _toDouble(json['longitud']),
      bioma: json['bioma']?.toString() ?? '',
      pais: json['pais']?.toString() ?? '',
    );
  }

  static double _toDouble(Object? value) {
    if (value is num) {
      return value.toDouble();
    }
    if (value is String) {
      return double.tryParse(value) ?? 0;
    }
    return 0;
  }
}

class AnimalApiException implements Exception {
  const AnimalApiException(this.message);

  final String message;

  @override
  String toString() => 'AnimalApiException: $message';
}
