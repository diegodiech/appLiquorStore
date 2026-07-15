import '../../../models/proveedor.dart';

abstract class SupplierRepository {
  Future<List<Proveedor>> getSuppliers();
  Future<void> addSupplier(Proveedor proveedor);
  Future<void> updateSupplier(Proveedor proveedor);
  Future<void> deleteSupplier(String idProveedor);
}
