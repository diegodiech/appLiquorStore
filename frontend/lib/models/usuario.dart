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

  // El backend nunca devuelve la contraseña ni su hash: la validación de
  // credenciales ocurre en el servidor (AuthRepositoryHttp), no en el
  // cliente. Este campo queda vacío en cualquier Usuario que venga de la API.
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      idUsuario: json['id'].toString(),
      nombre: json['nombre'] as String,
      email: json['email'] as String,
      password: '',
      rol: UserRole.values.byName(json['rol'] as String),
    );
  }
}
