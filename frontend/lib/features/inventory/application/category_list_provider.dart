import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/categoria.dart';
import '../data/category_repository.dart';
import '../data/category_repository_mock.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>((ref) {
  return CategoryRepositoryMock();
});

final categoryListProvider = FutureProvider<List<Categoria>>((ref) {
  return ref.watch(categoryRepositoryProvider).getCategories();
});
