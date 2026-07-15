import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/producto.dart';
import '../../../shell/presentation/widgets/app_drawer.dart';
import '../../../shell/presentation/widgets/app_drawer_item.dart';
import '../../application/cart_provider.dart';
import '../widgets/cart_panel.dart';
import '../widgets/product_search_panel.dart';

class PosScreen extends ConsumerWidget {
  const PosScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terminal de venta')),
      drawer: AppDrawer(
        items: [
          AppDrawerItem(
            icon: Icons.point_of_sale_outlined,
            selectedIcon: Icons.point_of_sale,
            label: 'Terminal de venta',
            selected: true,
            onTap: () {},
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: LayoutBuilder(
          builder: (context, constraints) {
            void addToCart(Producto producto) =>
                ref.read(cartProvider.notifier).addProduct(producto);

            if (constraints.maxWidth >= 720) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    flex: 3,
                    child: ProductSearchPanel(onProductSelected: addToCart),
                  ),
                  const SizedBox(width: 16),
                  const VerticalDivider(width: 1),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: CartPanel(),
                  ),
                ],
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ProductSearchPanel(onProductSelected: addToCart),
                ),
                const Divider(),
                Expanded(
                  child: CartPanel(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
