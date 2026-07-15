import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/confirm_dialog.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../application/supplier_list_provider.dart';
import '../widgets/supplier_form_dialog.dart';
import '../widgets/supplier_list_tile.dart';

class SuppliersScreen extends ConsumerWidget {
  const SuppliersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final suppliersAsync = ref.watch(supplierListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Proveedores')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => showSupplierFormDialog(context),
        icon: const Icon(Icons.add),
        label: const Text('Registrar proveedor'),
      ),
      body: AsyncValueView(
        value: suppliersAsync,
        onRetry: () => ref.invalidate(supplierListProvider),
        data: (proveedores) {
          if (proveedores.isEmpty) {
            return const EmptyState(
              icon: Icons.local_shipping_outlined,
              title: 'Aún no hay proveedores registrados',
              subtitle: 'Usa el botón "Registrar proveedor" para agregar uno.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: proveedores.length,
            itemBuilder: (context, index) {
              final proveedor = proveedores[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: SupplierListTile(
                  proveedor: proveedor,
                  onEdit: () =>
                      showSupplierFormDialog(context, proveedor: proveedor),
                  onDelete: () async {
                    final confirmed = await showConfirmDialog(
                      context,
                      title: 'Eliminar proveedor',
                      message:
                          '¿Eliminar a "${proveedor.nombreEmpresa}"? Esta acción no se puede deshacer.',
                    );
                    if (confirmed) {
                      await ref
                          .read(supplierListProvider.notifier)
                          .deleteSupplier(proveedor.idProveedor);
                    }
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
