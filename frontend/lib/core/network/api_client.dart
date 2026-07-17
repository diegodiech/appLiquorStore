import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

import '../../features/auth/application/auth_provider.dart';
import '../config/api_config.dart';

class ApiException implements Exception {
  ApiException(this.statusCode, this.mensaje);

  final int statusCode;
  final String mensaje;

  @override
  String toString() => mensaje;
}

/// Cliente HTTP compartido por todas las implementaciones *RepositoryHttp:
/// arma la URL base, adjunta el JWT de la sesión y traduce el `{ mensaje }`
/// de error que devuelven todos los controllers del backend.
class ApiClient {
  ApiClient(this._ref);

  final Ref _ref;

  Map<String, String> get _headers {
    final token = _ref.read(authControllerProvider).token;
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  Future<dynamic> get(String path) => _send('GET', path);
  Future<dynamic> post(String path, {Object? body}) => _send('POST', path, body: body);
  Future<dynamic> put(String path, {Object? body}) => _send('PUT', path, body: body);
  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path, {Object? body}) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final encodedBody = body == null ? null : jsonEncode(body);
    final headers = _headers;

    final http.Response response = switch (method) {
      'GET' => await http.get(uri, headers: headers),
      'POST' => await http.post(uri, headers: headers, body: encodedBody),
      'PUT' => await http.put(uri, headers: headers, body: encodedBody),
      'DELETE' => await http.delete(uri, headers: headers),
      _ => throw ArgumentError('Método no soportado: $method'),
    };

    if (response.statusCode >= 200 && response.statusCode < 300) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    }

    throw ApiException(response.statusCode, _extraerMensaje(response.body));
  }

  String _extraerMensaje(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['mensaje'] is String) {
        return decoded['mensaje'] as String;
      }
    } catch (_) {
      // Respuesta sin cuerpo JSON: se usa el mensaje genérico de abajo.
    }
    return 'Ocurrió un error al comunicarse con el servidor.';
  }
}
