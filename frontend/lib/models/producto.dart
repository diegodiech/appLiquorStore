import '../core/utils/json_parsing.dart';

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

  // categoria_id/proveedor_id pueden ser null en la BD (FK ON DELETE SET
  // NULL, o simplemente sin asignar); se mapean a '' porque los widgets que
  // buscan por id ya devuelven "Sin categoría"/"Proveedor no encontrado"
  // cuando no encuentran coincidencia.
  factory Producto.fromJson(Map<String, dynamic> json) {
    return Producto(
      idProducto: json['id'].toString(),
      nombre: json['nombre'] as String,
      codigoBarra: json['codigo_barra'] as String? ?? '',
      precioCompra: parseDecimal(json['precio_compra']),
      precioVenta: parseDecimal(json['precio_venta']),
      stockActual: json['stock_actual'] as int,
      stockMinimo: json['stock_minimo'] as int,
      idCategoria: json['categoria_id']?.toString() ?? '',
      idProveedor: json['proveedor_id']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigo_barra': codigoBarra,
      'nombre': nombre,
      'precio_compra': precioCompra,
      'precio_venta': precioVenta,
      'stock_actual': stockActual,
      'stock_minimo': stockMinimo,
      'categoria_id': idCategoria.isEmpty ? null : int.parse(idCategoria),
      'proveedor_id': idProveedor.isEmpty ? null : int.parse(idProveedor),
    };
  }
}
