import '../../../models/usuario.dart';

/// Resultado de un login exitoso. [token] es nulo en implementaciones que no
/// manejan JWT (p. ej. [AuthRepositoryMock]).
class AuthResult {
  const AuthResult({required this.usuario, this.token});

  final Usuario usuario;
  final String? token;
}

/// Contrato de autenticación. La implementación real (API/BD) debe
/// reemplazar [AuthRepositoryMock] sin tocar el resto de la app.
abstract class AuthRepository {
  Future<AuthResult?> login({required String email, required String password});

  /// Usuarios registrados, usados para resolver quién atendió una venta.
  Future<List<Usuario>> getUsuarios();
}
