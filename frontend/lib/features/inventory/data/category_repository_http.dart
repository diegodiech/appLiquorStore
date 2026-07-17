import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/network/api_client.dart';
import '../../../models/categoria.dart';
import 'category_repository.dart';

class CategoryRepositoryHttp implements CategoryRepository {
  CategoryRepositoryHttp(Ref ref) : _client = ApiClient(ref);

  final ApiClient _client;

  @override
  Future<List<Categoria>> getCategories() async {
    final list = await _client.get('/categorias') as List<dynamic>;
    return list
        .map((json) => Categoria.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
