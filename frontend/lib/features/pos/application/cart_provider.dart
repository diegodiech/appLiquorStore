import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/cart_item.dart';
import '../../../models/producto.dart';

final cartProvider = NotifierProvider<CartController, List<CartItem>>(
  CartController.new,
);

class CartController extends Notifier<List<CartItem>> {
  @override
  List<CartItem> build() => [];

  void addProduct(Producto producto) {
    final index =
        state.indexWhere((item) => item.producto.idProducto == producto.idProducto);
    if (index == -1) {
      state = [...state, CartItem(producto: producto, cantidad: 1)];
      return;
    }
    _setQuantity(index, state[index].cantidad + 1);
  }

  void incrementQuantity(String idProducto) {
    final index = _indexOf(idProducto);
    if (index == -1) return;
    _setQuantity(index, state[index].cantidad + 1);
  }

  void decrementQuantity(String idProducto) {
    final index = _indexOf(idProducto);
    if (index == -1) return;
    final nuevaCantidad = state[index].cantidad - 1;
    if (nuevaCantidad <= 0) {
      removeItem(idProducto);
      return;
    }
    _setQuantity(index, nuevaCantidad);
  }

  void removeItem(String idProducto) {
    state = state.where((item) => item.producto.idProducto != idProducto).toList();
  }

  void clear() {
    state = [];
  }

  int _indexOf(String idProducto) {
    return state.indexWhere((item) => item.producto.idProducto == idProducto);
  }

  void _setQuantity(int index, int cantidad) {
    final updated = [...state];
    updated[index] = updated[index].copyWith(cantidad: cantidad);
    state = updated;
  }
}

final cartTotalProvider = Provider<double>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<double>(0, (sum, item) => sum + item.subtotal);
});

final cartItemCountProvider = Provider<int>((ref) {
  final items = ref.watch(cartProvider);
  return items.fold<int>(0, (sum, item) => sum + item.cantidad);
});
