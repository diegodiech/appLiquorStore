import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/venta.dart';
import '../data/sale_repository.dart';
import '../data/sale_repository_http.dart';

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepositoryHttp(ref);
});

/// Historial de ventas, usado por el dashboard para construir el gráfico.
final saleListProvider = FutureProvider<List<Venta>>((ref) {
  return ref.watch(saleRepositoryProvider).getSales();
});
