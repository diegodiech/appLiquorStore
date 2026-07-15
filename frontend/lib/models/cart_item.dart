import 'producto.dart';

/// Línea del carrito de venta. No corresponde a una tabla de la base de
/// datos: es estado transitorio de UI hasta que se confirma la venta y se
/// convierte en [DetalleVenta].
class CartItem {
  const CartItem({
    required this.producto,
    required this.cantidad,
  });

  final Producto producto;
  final int cantidad;

  double get subtotal => producto.precioVenta * cantidad;

  CartItem copyWith({int? cantidad}) {
    return CartItem(
      producto: producto,
      cantidad: cantidad ?? this.cantidad,
    );
  }
}
