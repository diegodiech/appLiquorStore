import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/venta.dart';
import '../../inventory/application/product_list_provider.dart';
import '../data/sale_repository.dart';
import '../data/sale_repository_mock.dart';

final saleRepositoryProvider = Provider<SaleRepository>((ref) {
  return SaleRepositoryMock(ref.watch(productRepositoryProvider));
});

/// Historial de ventas, usado por el dashboard para construir el gráfico.
final saleListProvider = FutureProvider<List<Venta>>((ref) {
  return ref.watch(saleRepositoryProvider).getSales();
});
