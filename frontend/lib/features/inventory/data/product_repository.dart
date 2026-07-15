import '../../../models/producto.dart';

abstract class ProductRepository {
  Future<List<Producto>> getProducts();
  Future<void> addProduct(Producto producto);
  Future<void> updateProduct(Producto producto);
  Future<void> deleteProduct(String idProducto);

  /// Descuenta stock tras confirmar una venta. Lanza [StateError] si algún
  /// producto no tiene stock suficiente.
  Future<void> descontarStock(Map<String, int> cantidadesPorProducto);
}
