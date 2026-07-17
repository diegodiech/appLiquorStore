import '../core/enums/payment_method.dart';
import '../core/utils/json_parsing.dart';
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

  factory Venta.fromJson(Map<String, dynamic> json) {
    return Venta(
      idVenta: json['id'].toString(),
      fecha: DateTime.parse(json['fecha'] as String),
      total: parseDecimal(json['total']),
      metodoPago: PaymentMethod.fromWireValue(json['metodo_pago'] as String),
      codigoTicket: json['codigo_ticket'] as String,
      idUsuario: json['usuario_id']?.toString() ?? '',
      detalle: (json['detalle'] as List<dynamic>)
          .map((d) => DetalleVenta.fromJson(d as Map<String, dynamic>))
          .toList(),
      montoRecibido:
          json['monto_recibido'] == null ? null : parseDecimal(json['monto_recibido']),
    );
  }
}
