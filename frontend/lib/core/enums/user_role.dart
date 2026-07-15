enum UserRole {
  administrador,
  cajero;

  String get label => switch (this) {
        UserRole.administrador => 'Administrador',
        UserRole.cajero => 'Cajero',
      };
}
