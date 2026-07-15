import '../../../models/categoria.dart';
import 'category_repository.dart';

/// TODO(equipo-backend): reemplazar por consultas a la tabla `categorias`.
class CategoryRepositoryMock implements CategoryRepository {
  static const seedCategories = [
    Categoria(idCategoria: 'cat1', nombreCategoria: 'Cervezas'),
    Categoria(idCategoria: 'cat2', nombreCategoria: 'Vinos'),
    Categoria(idCategoria: 'cat3', nombreCategoria: 'Whisky'),
    Categoria(idCategoria: 'cat4', nombreCategoria: 'Rones'),
    Categoria(idCategoria: 'cat5', nombreCategoria: 'Vodka'),
  ];

  @override
  Future<List<Categoria>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return seedCategories;
  }
}
