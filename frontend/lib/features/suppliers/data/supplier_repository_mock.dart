import '../../../models/proveedor.dart';
import 'supplier_repository.dart';

/// TODO(equipo-backend): reemplazar por una implementación que persista en
/// la tabla `proveedores`.
class SupplierRepositoryMock implements SupplierRepository {
  final List<Proveedor> _proveedores = [
    const Proveedor(
      idProveedor: 'prov1',
      nombreEmpresa: 'CBN',
      telefono: '78012345',
    ),
    const Proveedor(
      idProveedor: 'prov2',
      nombreEmpresa: 'Embol',
      telefono: '77098765',
    ),
    const Proveedor(
      idProveedor: 'prov3',
      nombreEmpresa: 'Bodegas y Viñedos San Isidro',
      telefono: '70055443',
    ),
  ];

  @override
  Future<List<Proveedor>> getSuppliers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_proveedores);
  }

  @override
  Future<void> addSupplier(Proveedor proveedor) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _proveedores.add(proveedor);
  }

  @override
  Future<void> updateSupplier(Proveedor proveedor) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index =
        _proveedores.indexWhere((p) => p.idProveedor == proveedor.idProveedor);
    if (index != -1) _proveedores[index] = proveedor;
  }

  @override
  Future<void> deleteSupplier(String idProveedor) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _proveedores.removeWhere((p) => p.idProveedor == idProveedor);
  }
}
