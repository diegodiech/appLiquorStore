import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../models/categoria.dart';
import '../../../../models/producto.dart';
import '../../application/category_list_provider.dart';
import '../../application/product_list_provider.dart';
import '../widgets/product_card.dart';

class InventoryScreen extends ConsumerWidget {
  const InventoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(filteredProductListProvider);
    final categories = ref.watch(categoryListProvider).valueOrNull ?? const <Categoria>[];
    final categoryNameById = {
      for (final categoria in categories) categoria.idCategoria: categoria.nombreCategoria,
    };

    return Scaffold(
      appBar: AppBar(title: const Text('Control de inventario')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/admin/inventory/new'),
        icon: const Icon(Icons.add),
        label: const Text('Registrar producto'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppSearchField(
              hintText: 'Buscar por nombre o código de barra',
              onChanged: (value) =>
                  ref.read(productSearchQueryProvider.notifier).state = value,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: AsyncValueView(
                value: filteredProductsAsync,
                onRetry: () => ref.invalidate(productListProvider),
                data: (productos) {
                  if (productos.isEmpty) {
                    return const EmptyState(
                      icon: Icons.inventory_2_outlined,
                      title: 'No se encontraron productos',
                    );
                  }
                  return ListView.separated(
                    itemCount: productos.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final producto = productos[index];
                      return ProductCard(
                        producto: producto,
                        categoryName: categoryNameById[producto.idCategoria] ?? 'Sin categoría',
                        onTap: () => _goToDetail(context, producto),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _goToDetail(BuildContext context, Producto producto) {
    context.push('/admin/inventory/detail/${producto.idProducto}', extra: producto);
  }
}
