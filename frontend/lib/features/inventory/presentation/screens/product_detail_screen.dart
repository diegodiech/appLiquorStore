import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/utils/category_style.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/utils/stock_status.dart';
import '../../../../core/widgets/app_chip.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../models/producto.dart';
import '../../../suppliers/application/supplier_list_provider.dart';
import '../../application/category_list_provider.dart';
import '../../application/product_list_provider.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.producto});

  final Producto producto;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categorias = ref.watch(categoryListProvider).valueOrNull ?? const [];
    final proveedores = ref.watch(supplierListProvider).valueOrNull ?? const [];

    final categoriaNombre = categorias
        .where((c) => c.idCategoria == producto.idCategoria)
        .map((c) => c.nombreCategoria)
        .firstOrNull ??
        'Sin categoría';
    final proveedor = proveedores.where((p) => p.idProveedor == producto.idProveedor).firstOrNull;

    final style = categoryStyleFor(categoriaNombre);
    final status = stockStatusOf(producto);
    final statusColor = stockStatusColor(status);

    final margen = producto.precioVenta - producto.precioCompra;
    final margenPorcentaje =
        producto.precioCompra > 0 ? (margen / producto.precioCompra) * 100 : 0;

    final stockRatio = producto.stockMinimo > 0
        ? (producto.stockActual / (producto.stockMinimo * 2)).clamp(0.0, 1.0)
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(producto.nombre),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            tooltip: 'Editar',
            onPressed: () => context.push(
              '/admin/inventory/edit/${producto.idProducto}',
              extra: producto,
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: style.color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(style.icon, color: style.color, size: 36),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      producto.nombre,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 6,
                      runSpacing: 6,
                      children: [
                        AppChip(label: categoriaNombre, color: style.color),
                        AppChip(
                          label: stockStatusLabel(status),
                          color: statusColor,
                          icon: status == StockStatus.critical ? Icons.warning_amber_rounded : null,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              children: [
                const Icon(Icons.qr_code, size: 18, color: AppColors.textSecondary),
                const SizedBox(width: 8),
                Text(
                  producto.codigoBarra,
                  style: const TextStyle(fontFeatures: [FontFeature.tabularFigures()]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Precio de compra',
                  value: AppFormatters.currency(producto.precioCompra),
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StatCard(
                  label: 'Precio de venta',
                  value: AppFormatters.currency(producto.precioVenta),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _StatCard(
            label: 'Margen por unidad',
            value:
                '${AppFormatters.currency(margen)}  ·  ${margenPorcentaje.toStringAsFixed(1)}%',
            color: AppColors.success,
            fullWidth: true,
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Nivel de stock', style: TextStyle(fontWeight: FontWeight.bold)),
                      AppChip(label: stockStatusLabel(status), color: statusColor),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: LinearProgressIndicator(
                      value: stockRatio,
                      minHeight: 10,
                      backgroundColor: statusColor.withValues(alpha: 0.12),
                      valueColor: AlwaysStoppedAnimation(statusColor),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Stock actual: ${producto.stockActual}'),
                      Text('Mínimo: ${producto.stockMinimo}'),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const CircleAvatar(child: Icon(Icons.local_shipping_outlined)),
              title: Text(proveedor?.nombreEmpresa ?? 'Proveedor no encontrado'),
              subtitle: Text(proveedor?.telefono ?? '—'),
            ),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.danger,
              side: const BorderSide(color: AppColors.danger),
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => _delete(context, ref),
            icon: const Icon(Icons.delete_outline),
            label: const Text('Eliminar producto'),
          ),
        ],
      ),
    );
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Eliminar producto',
      message: '¿Eliminar "${producto.nombre}" del inventario?',
    );
    if (confirmed) {
      await ref.read(productListProvider.notifier).deleteProduct(producto.idProducto);
      if (context.mounted) context.pop();
    }
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
    this.fullWidth = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool fullWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: fullWidth ? double.infinity : null,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ],
      ),
    );
  }
}
