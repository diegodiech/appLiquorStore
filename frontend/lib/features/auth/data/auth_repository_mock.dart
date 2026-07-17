import '../../../core/enums/user_role.dart';
import '../../../models/usuario.dart';
import 'auth_repository.dart';

/// Implementación en memoria usada mientras no existe backend real.
/// TODO(equipo-backend): reemplazar por una implementación que consulte la
/// tabla `usuarios` en la base de datos.
class AuthRepositoryMock implements AuthRepository {
  final List<Usuario> _usuarios = const [
    Usuario(
      idUsuario: 'u1',
      nombre: 'Ana Rodríguez',
      email: 'admin@licoreria.com',
      password: 'admin123',
      rol: UserRole.administrador,
    ),
    Usuario(
      idUsuario: 'u2',
      nombre: 'Luis Pérez',
      email: 'cajero@licoreria.com',
      password: 'cajero123',
      rol: UserRole.cajero,
    ),
  ];

  @override
  Future<AuthResult?> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    for (final usuario in _usuarios) {
      if (usuario.email.toLowerCase() == email.toLowerCase() &&
          usuario.password == password) {
        return AuthResult(usuario: usuario, token: null);
      }
    }
    return null;
  }

  @override
  Future<List<Usuario>> getUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _usuarios;
  }
}
