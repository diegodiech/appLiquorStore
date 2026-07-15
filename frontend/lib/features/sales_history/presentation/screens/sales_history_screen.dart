import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../models/venta.dart';
import '../../../pos/application/sale_list_provider.dart';
import '../widgets/sale_list_tile.dart';

class SalesHistoryScreen extends ConsumerWidget {
  const SalesHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final salesAsync = ref.watch(saleListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Historial de ventas')),
      body: AsyncValueView(
        value: salesAsync,
        onRetry: () => ref.invalidate(saleListProvider),
        data: (ventas) {
          if (ventas.isEmpty) {
            return const EmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'Aún no se han registrado ventas',
            );
          }
          final ordenadas = [...ventas]..sort((a, b) => b.fecha.compareTo(a.fecha));
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: ordenadas.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final venta = ordenadas[index];
              return SaleListTile(
                venta: venta,
                onTap: () => _goToDetail(context, venta),
              );
            },
          );
        },
      ),
    );
  }

  void _goToDetail(BuildContext context, Venta venta) {
    context.push('/admin/sales/detail/${venta.idVenta}', extra: venta);
  }
}
