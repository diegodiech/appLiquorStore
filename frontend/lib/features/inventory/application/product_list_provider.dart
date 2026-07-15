import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/producto.dart';
import '../data/product_repository.dart';
import '../data/product_repository_mock.dart';

final productRepositoryProvider = Provider<ProductRepository>((ref) {
  return ProductRepositoryMock();
});

final productListProvider =
    AsyncNotifierProvider<ProductListController, List<Producto>>(
  ProductListController.new,
);

class ProductListController extends AsyncNotifier<List<Producto>> {
  @override
  Future<List<Producto>> build() {
    return ref.watch(productRepositoryProvider).getProducts();
  }

  Future<void> addProduct(Producto producto) async {
    await ref.read(productRepositoryProvider).addProduct(producto);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateProduct(Producto producto) async {
    await ref.read(productRepositoryProvider).updateProduct(producto);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteProduct(String idProducto) async {
    await ref.read(productRepositoryProvider).deleteProduct(idProducto);
    ref.invalidateSelf();
    await future;
  }
}

/// Filtra por nombre o código de barra. Usado por la búsqueda de inventario
/// y del punto de venta.
final productSearchQueryProvider = StateProvider<String>((ref) => '');

final filteredProductListProvider = Provider<AsyncValue<List<Producto>>>((ref) {
  final query = ref.watch(productSearchQueryProvider).trim().toLowerCase();
  final productsAsync = ref.watch(productListProvider);

  return productsAsync.whenData((productos) {
    if (query.isEmpty) return productos;
    return productos.where((p) {
      return p.nombre.toLowerCase().contains(query) ||
          p.codigoBarra.contains(query);
    }).toList();
  });
});
