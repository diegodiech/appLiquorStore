import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/proveedor.dart';
import '../data/supplier_repository.dart';
import '../data/supplier_repository_mock.dart';

final supplierRepositoryProvider = Provider<SupplierRepository>((ref) {
  return SupplierRepositoryMock();
});

final supplierListProvider =
    AsyncNotifierProvider<SupplierListController, List<Proveedor>>(
  SupplierListController.new,
);

class SupplierListController extends AsyncNotifier<List<Proveedor>> {
  @override
  Future<List<Proveedor>> build() {
    return ref.watch(supplierRepositoryProvider).getSuppliers();
  }

  Future<void> addSupplier(Proveedor proveedor) async {
    await ref.read(supplierRepositoryProvider).addSupplier(proveedor);
    ref.invalidateSelf();
    await future;
  }

  Future<void> updateSupplier(Proveedor proveedor) async {
    await ref.read(supplierRepositoryProvider).updateSupplier(proveedor);
    ref.invalidateSelf();
    await future;
  }

  Future<void> deleteSupplier(String idProveedor) async {
    await ref.read(supplierRepositoryProvider).deleteSupplier(idProveedor);
    ref.invalidateSelf();
    await future;
  }
}
