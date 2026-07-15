import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/payment_method.dart';
import '../../../models/venta.dart';
import '../../auth/application/auth_provider.dart';
import '../../inventory/application/product_list_provider.dart';
import 'cart_provider.dart';
import 'sale_list_provider.dart';

/// Mantiene el resultado de la última venta confirmada para mostrarlo en el
/// Ticket Digital (Screen 6). `null` indica que aún no se ha cerrado ninguna
/// venta en la sesión actual del cajero.
final checkoutProvider =
    AsyncNotifierProvider<CheckoutController, Venta?>(CheckoutController.new);

class CheckoutController extends AsyncNotifier<Venta?> {
  @override
  Venta? build() => null;

  Future<void> confirmSale({
    required PaymentMethod metodoPago,
    double? montoRecibido,
  }) async {
    final items = ref.read(cartProvider);
    if (items.isEmpty) return;

    final usuario = ref.read(authControllerProvider).currentUser;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final venta = await ref.read(saleRepositoryProvider).registerSale(
            items: items,
            metodoPago: metodoPago,
            idUsuario: usuario?.idUsuario ?? 'desconocido',
            montoRecibido: montoRecibido,
          );

      ref.read(cartProvider.notifier).clear();
      ref.invalidate(productListProvider);
      ref.invalidate(saleListProvider);
      return venta;
    });
  }

  /// Limpia el ticket mostrado para iniciar una nueva venta.
  void reset() {
    state = const AsyncData(null);
  }
}
