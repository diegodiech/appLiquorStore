import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../models/proveedor.dart';
import 'supplier_repository.dart';

class SupplierRepositoryHttp implements SupplierRepository {
  SupplierRepositoryHttp(Ref ref) : _client = ApiClient(ref);

  final ApiClient _client;

  @override
  Future<List<Proveedor>> getSuppliers() async {
    final list = await _client.get('/proveedores') as List<dynamic>;
    return list
        .map((json) => Proveedor.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> addSupplier(Proveedor proveedor) {
    return _client.post('/proveedores', body: proveedor.toJson());
  }

  @override
  Future<void> updateSupplier(Proveedor proveedor) {
    return _client.put('/proveedores/${proveedor.idProveedor}', body: proveedor.toJson());
  }

  @override
  Future<void> deleteSupplier(String idProveedor) {
    return _client.delete('/proveedores/$idProveedor');
  }
}
