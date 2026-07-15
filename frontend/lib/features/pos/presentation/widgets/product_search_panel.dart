import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/app_search_field.dart';
import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/barcode_scan_button.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../models/producto.dart';
import '../../../inventory/application/product_list_provider.dart';

/// Lado izquierdo de la Terminal de Venta: búsqueda manual + escáner para
/// sumar productos al carrito.
class ProductSearchPanel extends ConsumerWidget {
  const ProductSearchPanel({super.key, required this.onProductSelected});

  final ValueChanged<Producto> onProductSelected;

  void _handleScan(WidgetRef ref, String codigoBarra) {
    final productos = ref.read(productListProvider).valueOrNull ?? const [];
    final match = productos
        .where((p) => p.codigoBarra == codigoBarra)
        .toList();
    if (match.isNotEmpty) onProductSelected(match.first);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProductsAsync = ref.watch(filteredProductListProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppSearchField(
                hintText: 'Buscar producto o código de barra',
                onChanged: (value) =>
                    ref.read(productSearchQueryProvider.notifier).state = value,
              ),
            ),
            const SizedBox(width: 8),
            BarcodeScanButton(onScanned: (code) => _handleScan(ref, code)),
          ],
        ),
        const SizedBox(height: 12),
        Expanded(
          child: AsyncValueView(
            value: filteredProductsAsync,
            data: (productos) {
              if (productos.isEmpty) {
                return const EmptyState(
                  icon: Icons.liquor_outlined,
                  title: 'No se encontraron productos',
                );
              }
              return ListView.separated(
                itemCount: productos.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  final producto = productos[index];
                  final sinStock = producto.stockActual <= 0;
                  return ListTile(
                    enabled: !sinStock,
                    title: Text(producto.nombre),
                    subtitle: Text(
                      sinStock
                          ? 'Sin stock disponible'
                          : 'Stock: ${producto.stockActual}',
                    ),
                    trailing: Text(AppFormatters.currency(producto.precioVenta)),
                    onTap: sinStock ? null : () => onProductSelected(producto),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
