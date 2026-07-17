import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/enums/payment_method.dart';
import '../../../core/network/api_client.dart';
import '../../../models/cart_item.dart';
import '../../../models/venta.dart';
import 'sale_repository.dart';

class SaleRepositoryHttp implements SaleRepository {
  SaleRepositoryHttp(Ref ref) : _client = ApiClient(ref);

  final ApiClient _client;

  @override
  Future<List<Venta>> getSales() async {
    final list = await _client.get('/ventas') as List<dynamic>;
    return list
        .map((json) => Venta.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<Venta> registerSale({
    required List<CartItem> items,
    required PaymentMethod metodoPago,
    required String idUsuario,
    double? montoRecibido,
  }) async {
    // usuario_id no se envía: el backend identifica al cajero por el JWT
    // (req.usuario.id en venta.controller.js), no por lo que mande el
    // cliente. El precio tampoco se envía: el backend lo toma del producto
    // en BD en ese momento (ver venta.service.js).
    final json = await _client.post(
      '/ventas',
      body: {
        'metodo_pago': metodoPago.wireValue,
        'monto_recibido': ?montoRecibido,
        'productos': items
            .map((item) => {
                  'producto_id': int.parse(item.producto.idProducto),
                  'cantidad': item.cantidad,
                })
            .toList(),
      },
    ) as Map<String, dynamic>;

    return Venta.fromJson(json);
  }
}
