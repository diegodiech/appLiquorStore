import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/categoria.dart';
import '../data/category_repository.dart';
import '../data/category_repository_http.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryHttp(ref);
});

final categoryListProvider = FutureProvider<List<Categoria>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});
