import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/animal.dart';

class AnimalApi {
  AnimalApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<List<Animal>> fetchAnimals() async {
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
        .map(AnimalModel.fromDesApiJson)
        .toList(growable: false);
  }
}

class AnimalApiException implements Exception {
  const AnimalApiException(this.message);

  final String message;

  @override
  String toString() => 'AnimalApiException: $message';
}
