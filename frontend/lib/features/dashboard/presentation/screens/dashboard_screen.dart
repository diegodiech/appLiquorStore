import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/async_value_view.dart';
import '../../application/dashboard_provider.dart';
import '../widgets/restock_alert_list.dart';
import '../widgets/sales_chart_card.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final weeklySalesAsync = ref.watch(weeklySalesProvider);
    final lowStockAsync = ref.watch(lowStockProductsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard de reportes y alertas')),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(weeklySalesProvider);
          ref.invalidate(lowStockProductsProvider);
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            AsyncValueView(
              value: lowStockAsync,
              data: (productos) => RestockAlertList(productos: productos),
            ),
            const SizedBox(height: 16),
            AsyncValueView(
              value: weeklySalesAsync,
              data: (points) => SalesChartCard(points: points),
            ),
          ],
        ),
      ),
    );
  }
}
