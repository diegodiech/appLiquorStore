import '../core/utils/json_parsing.dart';

class DetalleVenta {
  const DetalleVenta({
    required this.idDetalle,
    required this.idVenta,
    required this.idProducto,
    required this.nombreProducto,
    required this.cantidad,
    required this.precioMomento,
  });

  final String idDetalle;
  final String idVenta;
  final String idProducto;
  final String nombreProducto;
  final int cantidad;
  final double precioMomento;

  double get subtotal => cantidad * precioMomento;

  // La respuesta inmediata de POST /ventas no trae "id" por línea (no hace
  // falta ese viaje extra a BD para mostrar el ticket); se sintetiza uno
  // estable con el mismo patrón que ya usaba SaleRepositoryMock.
  factory DetalleVenta.fromJson(Map<String, dynamic> json) {
    final idVenta = json['venta_id'].toString();
    final idProducto = json['producto_id'].toString();
    return DetalleVenta(
      idDetalle: json['id']?.toString() ?? '${idVenta}_$idProducto',
      idVenta: idVenta,
      idProducto: idProducto,
      nombreProducto: json['nombre_producto'] as String,
      cantidad: json['cantidad'] as int,
      precioMomento: parseDecimal(json['precio_unitario_momento']),
    );
  }
}
