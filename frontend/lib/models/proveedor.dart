class Proveedor {
  const Proveedor({
    required this.idProveedor,
    required this.nombreEmpresa,
    required this.telefono,
  });

  final String idProveedor;
  final String nombreEmpresa;
  final String telefono;

  Proveedor copyWith({
    String? nombreEmpresa,
    String? telefono,
  }) {
    return Proveedor(
      idProveedor: idProveedor,
      nombreEmpresa: nombreEmpresa ?? this.nombreEmpresa,
      telefono: telefono ?? this.telefono,
    );
  }
}
