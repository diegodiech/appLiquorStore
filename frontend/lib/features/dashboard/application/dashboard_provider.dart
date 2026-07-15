import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/producto.dart';
import '../../inventory/application/product_list_provider.dart';
import '../../pos/application/sale_list_provider.dart';
import '../domain/daily_sales_point.dart';

/// Productos cuyo stock_actual es menor o igual al stock_minimo.
final lowStockProductsProvider = Provider<AsyncValue<List<Producto>>>((ref) {
  final productsAsync = ref.watch(productListProvider);
  return productsAsync.whenData(
    (productos) => productos.where((p) => p.necesitaReposicion).toList(),
  );
});

/// Total de ventas de los últimos 7 días, uno por día, en orden cronológico.
final weeklySalesProvider = Provider<AsyncValue<List<DailySalesPoint>>>((ref) {
  final salesAsync = ref.watch(saleListProvider);
  return salesAsync.whenData((ventas) {
    final today = DateTime.now();
    final days = List.generate(
      7,
      (i) => DateTime(today.year, today.month, today.day)
          .subtract(Duration(days: 6 - i)),
    );

    return days.map((day) {
      final total = ventas
          .where((v) =>
              v.fecha.year == day.year &&
              v.fecha.month == day.month &&
              v.fecha.day == day.day)
          .fold<double>(0, (sum, v) => sum + v.total);
      return DailySalesPoint(date: day, total: total);
    }).toList();
  });
});
