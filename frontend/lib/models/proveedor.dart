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

  factory Proveedor.fromJson(Map<String, dynamic> json) {
    return Proveedor(
      idProveedor: json['id'].toString(),
      nombreEmpresa: json['nombre_empresa'] as String,
      telefono: json['telefono'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre_empresa': nombreEmpresa,
      'telefono': telefono,
    };
  }
}
