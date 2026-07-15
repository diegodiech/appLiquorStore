import '../core/enums/user_role.dart';

class Usuario {
  const Usuario({
    required this.idUsuario,
    required this.nombre,
    required this.email,
    required this.password,
    required this.rol,
  });

  final String idUsuario;
  final String nombre;
  final String email;
  final String password;
  final UserRole rol;
}
