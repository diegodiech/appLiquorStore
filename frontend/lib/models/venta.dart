import '../core/enums/payment_method.dart';
import 'detalle_venta.dart';

class Venta {
  const Venta({
    required this.idVenta,
    required this.fecha,
    required this.total,
    required this.metodoPago,
    required this.codigoTicket,
    required this.idUsuario,
    required this.detalle,
    this.montoRecibido,
  });

  final String idVenta;
  final DateTime fecha;
  final double total;
  final PaymentMethod metodoPago;
  final String codigoTicket;
  final String idUsuario;
  final List<DetalleVenta> detalle;
  final double? montoRecibido;

  double get cambio =>
      montoRecibido == null ? 0 : (montoRecibido! - total).clamp(0, double.infinity);
}
