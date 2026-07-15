import '../../../core/enums/payment_method.dart';
import '../../../features/inventory/data/product_repository.dart';
import '../../../models/cart_item.dart';
import '../../../models/detalle_venta.dart';
import '../../../models/venta.dart';
import 'sale_repository.dart';

/// TODO(equipo-backend): reemplazar por una implementación que persista en
/// las tablas `ventas` y `detalle_ventas` dentro de una transacción.
class SaleRepositoryMock implements SaleRepository {
  SaleRepositoryMock(this._productRepository) {
    _seedHistoricalSales();
  }

  final ProductRepository _productRepository;
  final List<Venta> _ventas = [];
  int _ticketSequence = 1000;

  void _seedHistoricalSales() {
    final now = DateTime.now();
    // (idProducto, nombre, precioVenta, cantidad) — refleja el catálogo
    // sembrado en ProductRepositoryMock, para que el historial de ventas
    // muestre productos reales en vez de líneas vacías.
    final seed = [
      (
        dias: 6,
        metodo: PaymentMethod.efectivo,
        items: [
          ('p1', 'Cerveza Paceña 620ml', 10.0, 4),
          ('p5', 'Ron Abuelo Añejo 750ml', 65.0, 1),
        ],
      ),
      (
        dias: 5,
        metodo: PaymentMethod.qrTransferencia,
        items: [
          ('p3', 'Vino Casa Real Tinto 750ml', 45.0, 2),
          ('p2', 'Cerveza Huari 620ml', 9.5, 1),
          ('p6', 'Vodka Ruso Clásico 750ml', 55.0, 1),
        ],
      ),
      (
        dias: 4,
        metodo: PaymentMethod.efectivo,
        items: [
          ('p1', 'Cerveza Paceña 620ml', 10.0, 3),
          ('p2', 'Cerveza Huari 620ml', 9.5, 1),
        ],
      ),
      (
        dias: 3,
        metodo: PaymentMethod.qrTransferencia,
        items: [
          ('p4', 'Whisky Old Times 750ml', 85.0, 1),
          ('p5', 'Ron Abuelo Añejo 750ml', 65.0, 2),
          ('p1', 'Cerveza Paceña 620ml', 10.0, 2),
        ],
      ),
      (
        dias: 2,
        metodo: PaymentMethod.efectivo,
        items: [
          ('p1', 'Cerveza Paceña 620ml', 10.0, 5),
          ('p3', 'Vino Casa Real Tinto 750ml', 45.0, 2),
        ],
      ),
      (
        dias: 1,
        metodo: PaymentMethod.qrTransferencia,
        items: [
          ('p4', 'Whisky Old Times 750ml', 85.0, 1),
          ('p6', 'Vodka Ruso Clásico 750ml', 55.0, 1),
          ('p2', 'Cerveza Huari 620ml', 9.5, 3),
        ],
      ),
      (
        dias: 0,
        metodo: PaymentMethod.efectivo,
        items: [
          ('p1', 'Cerveza Paceña 620ml', 10.0, 2),
          ('p5', 'Ron Abuelo Añejo 750ml', 65.0, 1),
          ('p3', 'Vino Casa Real Tinto 750ml', 45.0, 1),
        ],
      ),
    ];

    for (final entry in seed) {
      _ticketSequence++;
      final idVenta = 'seed_${entry.dias}';
      final detalle = entry.items
          .map(
            (item) => DetalleVenta(
              idDetalle: '${idVenta}_${item.$1}',
              idVenta: idVenta,
              idProducto: item.$1,
              nombreProducto: item.$2,
              cantidad: item.$4,
              precioMomento: item.$3,
            ),
          )
          .toList();
      final total = detalle.fold<double>(0, (sum, d) => sum + d.subtotal);

      _ventas.add(
        Venta(
          idVenta: idVenta,
          fecha: now.subtract(Duration(days: entry.dias)),
          total: total,
          metodoPago: entry.metodo,
          codigoTicket: 'TCK-$_ticketSequence',
          idUsuario: 'u2',
          detalle: detalle,
        ),
      );
    }
  }

  @override
  Future<List<Venta>> getSales() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_ventas);
  }

  @override
  Future<Venta> registerSale({
    required List<CartItem> items,
    required PaymentMethod metodoPago,
    required String idUsuario,
    double? montoRecibido,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));

    final idVenta = 'v_${DateTime.now().microsecondsSinceEpoch}';
    _ticketSequence++;
    final codigoTicket = 'TCK-$_ticketSequence';

    final detalle = items
        .map((item) => DetalleVenta(
              idDetalle: '${idVenta}_${item.producto.idProducto}',
              idVenta: idVenta,
              idProducto: item.producto.idProducto,
              nombreProducto: item.producto.nombre,
              cantidad: item.cantidad,
              precioMomento: item.producto.precioVenta,
            ))
        .toList();

    final total = detalle.fold<double>(0, (sum, d) => sum + d.subtotal);

    final venta = Venta(
      idVenta: idVenta,
      fecha: DateTime.now(),
      total: total,
      metodoPago: metodoPago,
      codigoTicket: codigoTicket,
      idUsuario: idUsuario,
      detalle: detalle,
      montoRecibido: montoRecibido,
    );

    await _productRepository.descontarStock({
      for (final item in items) item.producto.idProducto: item.cantidad,
    });

    _ventas.add(venta);
    return venta;
  }
}
