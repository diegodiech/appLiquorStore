import '../../../models/usuario.dart';

/// Contrato de autenticación. La implementación real (API/BD) debe
/// reemplazar [AuthRepositoryMock] sin tocar el resto de la app.
abstract class AuthRepository {
  Future<Usuario?> login({required String email, required String password});

  /// Usuarios registrados, usados para resolver quién atendió una venta.
  Future<List<Usuario>> getUsuarios();
}
