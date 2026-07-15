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
}
