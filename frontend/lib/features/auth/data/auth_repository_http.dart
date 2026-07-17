import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../models/usuario.dart';
import 'auth_repository.dart';

class AuthRepositoryHttp implements AuthRepository {
  AuthRepositoryHttp(Ref ref) : _client = ApiClient(ref);

  final ApiClient _client;

  @override
  Future<AuthResult?> login({
    required String email,
    required String password,
  }) async {
    try {
      final json = await _client.post(
        '/auth/login',
        body: {'email': email, 'password': password},
      ) as Map<String, dynamic>;

      return AuthResult(
        usuario: Usuario.fromJson(json['usuario'] as Map<String, dynamic>),
        token: json['token'] as String,
      );
    } on ApiException catch (error) {
      if (error.statusCode == 401) return null;
      rethrow;
    }
  }

  @override
  Future<List<Usuario>> getUsuarios() async {
    final list = await _client.get('/auth/usuarios') as List<dynamic>;
    return list
        .map((json) => Usuario.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
