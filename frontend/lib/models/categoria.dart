class Categoria {
  const Categoria({
    required this.idCategoria,
    required this.nombreCategoria,
  });

  final String idCategoria;
  final String nombreCategoria;

  factory Categoria.fromJson(Map<String, dynamic> json) {
    return Categoria(
      idCategoria: json['id'].toString(),
      nombreCategoria: json['nombre_categoria'] as String,
    );
  }
}
