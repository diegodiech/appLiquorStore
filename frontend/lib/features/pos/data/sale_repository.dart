import '../../../core/enums/payment_method.dart';
import '../../../models/cart_item.dart';
import '../../../models/venta.dart';

abstract class SaleRepository {
  Future<List<Venta>> getSales();

  /// Registra la venta, descuenta el stock de cada producto involucrado y
  /// devuelve el [Venta] resultante (incluye el código de ticket único).
  Future<Venta> registerSale({
    required List<CartItem> items,
    required PaymentMethod metodoPago,
    required String idUsuario,
    double? montoRecibido,
  });
}
