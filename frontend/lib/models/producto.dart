class Producto {
  const Producto({
    required this.idProducto,
    required this.nombre,
    required this.codigoBarra,
    required this.precioCompra,
    required this.precioVenta,
    required this.stockActual,
    required this.stockMinimo,
    required this.idCategoria,
    required this.idProveedor,
  });

  final String idProducto;
  final String nombre;
  final String codigoBarra;
  final double precioCompra;
  final double precioVenta;
  final int stockActual;
  final int stockMinimo;
  final String idCategoria;
  final String idProveedor;

  bool get necesitaReposicion => stockActual <= stockMinimo;

  Producto copyWith({
    String? nombre,
    String? codigoBarra,
    double? precioCompra,
    double? precioVenta,
    int? stockActual,
    int? stockMinimo,
    String? idCategoria,
    String? idProveedor,
  }) {
    return Producto(
      idProducto: idProducto,
      nombre: nombre ?? this.nombre,
      codigoBarra: codigoBarra ?? this.codigoBarra,
      precioCompra: precioCompra ?? this.precioCompra,
      precioVenta: precioVenta ?? this.precioVenta,
      stockActual: stockActual ?? this.stockActual,
      stockMinimo: stockMinimo ?? this.stockMinimo,
      idCategoria: idCategoria ?? this.idCategoria,
      idProveedor: idProveedor ?? this.idProveedor,
    );
  }
}
