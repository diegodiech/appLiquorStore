import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../models/producto.dart';
import 'product_repository.dart';

class ProductRepositoryHttp implements ProductRepository {
  ProductRepositoryHttp(Ref ref) : _client = ApiClient(ref);

  final ApiClient _client;

  @override
  Future<List<Producto>> getProducts() async {
    final list = await _client.get('/productos') as List<dynamic>;
    return list
        .map((json) => Producto.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addProduct(Producto producto) {
    return _client.post('/productos', body: producto.toJson());
  }

  @override
  Future<void> updateProduct(Producto producto) {
    return _client.put('/productos/${producto.idProducto}', body: producto.toJson());
  }

  @override
  Future<void> deleteProduct(String idProducto) {
    return _client.delete('/productos/$idProducto');
  }

  @override
  Future<void> descontarStock(Map<String, int> cantidadesPorProducto) async {
    // El backend descuenta el stock como parte de POST /ventas (transacción
    // en venta.service.js); no existe un endpoint separado para esto y no
    // hace falta: SaleRepositoryHttp ya envía la venta completa.
  }
}
