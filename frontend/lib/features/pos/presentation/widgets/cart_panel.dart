import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/cart_provider.dart';
import 'cart_item_tile.dart';

/// Lado derecho de la Terminal de Venta: carrito con el desglose de
/// productos, modificadores de cantidad y el total en tiempo real.
class CartPanel extends ConsumerWidget {
  const CartPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(cartProvider);
    final total = ref.watch(cartTotalProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Carrito de compras', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        Expanded(
          child: items.isEmpty
              ? const EmptyState(
                  icon: Icons.shopping_cart_outlined,
                  title: 'El carrito está vacío',
                  subtitle: 'Busca o escanea un producto para agregarlo.',
                )
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return CartItemTile(
                      item: item,
                      onIncrement: () => ref
                          .read(cartProvider.notifier)
                          .incrementQuantity(item.producto.idProducto),
                      onDecrement: () => ref
                          .read(cartProvider.notifier)
                          .decrementQuantity(item.producto.idProducto),
                      onRemove: () => ref
                          .read(cartProvider.notifier)
                          .removeItem(item.producto.idProducto),
                    );
                  },
                ),
        ),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(
              AppFormatters.currency(total),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: items.isEmpty ? null : () => context.push('/cashier/payment'),
          child: const Text('Proceder al pago'),
        ),
      ],
    );
  }
}
