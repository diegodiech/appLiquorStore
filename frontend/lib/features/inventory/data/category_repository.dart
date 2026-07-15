import '../../../models/categoria.dart';

abstract class CategoryRepository {
  Future<List<Categoria>> getCategories();
}
