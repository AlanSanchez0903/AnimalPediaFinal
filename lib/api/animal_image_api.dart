import 'dart:convert';

import 'package:http/http.dart' as http;

class AnimalImageApi {
  AnimalImageApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<ImgApiAnimalImageDto>> fetchAnimalImages() async {
    final uri = Uri.parse('$baseUrl/images');
    final response = await _client.get(uri, headers: const {'Accept': 'application/json'});

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AnimalImageApiException(
        'Error consultando imgAPI2: ${response.statusCode} ${response.reasonPhrase ?? ''}'.trim(),
      );
    }

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const AnimalImageApiException('Respuesta inválida de imgAPI2: se esperaba una lista de imágenes.');
    }

    return decoded
        .whereType<Map<String, dynamic>>()
        .map(ImgApiAnimalImageDto.fromJson)
        .toList(growable: false);
  }
}

class ImgApiAnimalImageDto {
  const ImgApiAnimalImageDto({
    required this.id,
    required this.nombre,
    required this.imagenUrl,
  });

  final String id;
  final String nombre;
  final String imagenUrl;

  factory ImgApiAnimalImageDto.fromJson(Map<String, dynamic> json) {
    return ImgApiAnimalImageDto(
      id: json['id']?.toString() ?? '',
      nombre: json['nombre']?.toString() ?? '',
      imagenUrl: json['imagenUrl']?.toString() ?? '',
    );
  }
}

class AnimalImageApiException implements Exception {
  const AnimalImageApiException(this.message);

  final String message;

  @override
  String toString() => 'AnimalImageApiException: $message';
}
