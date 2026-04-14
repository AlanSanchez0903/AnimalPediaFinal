import 'dart:convert';

import 'package:http/http.dart' as http;

class AnimalImageApi {
  AnimalImageApi({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  final String baseUrl;
  final http.Client _client;

  Future<Map<String, String>> fetchAnimalImageUrls() async {
    final uri = Uri.parse('$baseUrl/animals/images');
    final response = await _client.get(uri, headers: const {'Accept': 'application/json'});

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AnimalImageApiException(
        'Error consultando imgAPI2: ${response.statusCode} ${response.reasonPhrase ?? ''}'.trim(),
      );
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded.map(
        (key, value) => MapEntry(key, value?.toString() ?? ''),
      );
    }

    if (decoded is List) {
      final map = <String, String>{};
      for (final item in decoded) {
        if (item is Map<String, dynamic>) {
          final id = item['id']?.toString() ?? '';
          final url = item['imagenUrl']?.toString() ?? item['url']?.toString() ?? '';
          if (id.isNotEmpty && url.isNotEmpty) {
            map[id] = url;
          }
        }
      }
      return map;
    }

    throw const AnimalImageApiException(
      'Respuesta inválida de imgAPI2: se esperaba un mapa id->url o una lista.',
    );
  }
}

class AnimalImageApiException implements Exception {
  const AnimalImageApiException(this.message);

  final String message;

  @override
  String toString() => 'AnimalImageApiException: $message';
}
