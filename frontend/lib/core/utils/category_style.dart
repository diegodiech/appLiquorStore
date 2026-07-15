import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Color e ícono asociados a cada categoría de licor, usados para dar
/// identidad visual a las tarjetas de producto sin depender de imágenes.
class CategoryStyle {
  const CategoryStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

CategoryStyle categoryStyleFor(String nombreCategoria) {
  switch (nombreCategoria.toLowerCase()) {
    case 'cervezas':
      return const CategoryStyle(color: Color(0xFFC98A2C), icon: Icons.sports_bar_outlined);
    case 'vinos':
      return const CategoryStyle(color: Color(0xFF8E1B3C), icon: Icons.wine_bar_outlined);
    case 'whisky':
      return const CategoryStyle(color: Color(0xFF8B5A2B), icon: Icons.liquor_outlined);
    case 'rones':
      return const CategoryStyle(color: Color(0xFFB5651D), icon: Icons.local_bar_outlined);
    case 'vodka':
      return const CategoryStyle(color: Color(0xFF3E6680), icon: Icons.ac_unit_outlined);
    default:
      return const CategoryStyle(color: AppColors.primary, icon: Icons.liquor_outlined);
  }
}
