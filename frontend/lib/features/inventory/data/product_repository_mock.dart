import '../../../models/producto.dart';
import 'product_repository.dart';

/// TODO(equipo-backend): reemplazar por una implementación que persista en
/// la tabla `productos` y descuente stock dentro de una transacción real.
class ProductRepositoryMock implements ProductRepository {
  final List<Producto> _productos = [
    const Producto(
      idProducto: 'p1',
      nombre: 'Cerveza Paceña 620ml',
      codigoBarra: '7790895001234',
      precioCompra: 6.5,
      precioVenta: 10.0,
      stockActual: 48,
      stockMinimo: 12,
      idCategoria: 'cat1',
      idProveedor: 'prov1',
    ),
    const Producto(
      idProducto: 'p2',
      nombre: 'Cerveza Huari 620ml',
      codigoBarra: '7790895005678',
      precioCompra: 6.0,
      precioVenta: 9.5,
      stockActual: 8,
      stockMinimo: 12,
      idCategoria: 'cat1',
      idProveedor: 'prov1',
    ),
    const Producto(
      idProducto: 'p3',
      nombre: 'Vino Casa Real Tinto 750ml',
      codigoBarra: '7791234009988',
      precioCompra: 28.0,
      precioVenta: 45.0,
      stockActual: 20,
      stockMinimo: 5,
      idCategoria: 'cat2',
      idProveedor: 'prov3',
    ),
    const Producto(
      idProducto: 'p4',
      nombre: 'Whisky Old Times 750ml',
      codigoBarra: '7791234001122',
      precioCompra: 55.0,
      precioVenta: 85.0,
      stockActual: 4,
      stockMinimo: 5,
      idCategoria: 'cat3',
      idProveedor: 'prov2',
    ),
    const Producto(
      idProducto: 'p5',
      nombre: 'Ron Abuelo Añejo 750ml',
      codigoBarra: '7791234003344',
      precioCompra: 40.0,
      precioVenta: 65.0,
      stockActual: 15,
      stockMinimo: 6,
      idCategoria: 'cat4',
      idProveedor: 'prov2',
    ),
    const Producto(
      idProducto: 'p6',
      nombre: 'Vodka Ruso Clásico 750ml',
      codigoBarra: '7791234005566',
      precioCompra: 35.0,
      precioVenta: 55.0,
      stockActual: 3,
      stockMinimo: 8,
      idCategoria: 'cat5',
      idProveedor: 'prov3',
    ),
  ];

  @override
  Future<List<Producto>> getProducts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_productos);
  }

  @override
  Future<void> addProduct(Producto producto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _productos.add(producto);
  }

  @override
  Future<void> updateProduct(Producto producto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index =
        _productos.indexWhere((p) => p.idProducto == producto.idProducto);
    if (index != -1) _productos[index] = producto;
  }

  @override
  Future<void> deleteProduct(String idProducto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _productos.removeWhere((p) => p.idProducto == idProducto);
  }

  @override
  Future<void> descontarStock(Map<String, int> cantidadesPorProducto) async {
    await Future.delayed(const Duration(milliseconds: 200));
    for (final entry in cantidadesPorProducto.entries) {
      final index =
          _productos.indexWhere((p) => p.idProducto == entry.key);
      if (index == -1) continue;
      final producto = _productos[index];
      _productos[index] = producto.copyWith(
        stockActual: producto.stockActual - entry.value,
      );
    }
  }
}
