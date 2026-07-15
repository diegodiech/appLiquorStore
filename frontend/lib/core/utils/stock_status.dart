import 'package:flutter/material.dart';

import '../../models/producto.dart';
import '../theme/app_colors.dart';

enum StockStatus { ok, low, critical }

/// Clasifica el nivel de stock de un producto en tres niveles visuales.
/// `critical`: en o por debajo del mínimo (dispara la alerta de reposición).
/// `low`: por encima del mínimo pero dentro de un margen de 1.5x, para
/// anticipar la reposición antes de que se vuelva crítico.
StockStatus stockStatusOf(Producto producto) {
  if (producto.necesitaReposicion) return StockStatus.critical;
  if (producto.stockActual <= producto.stockMinimo * 1.5) return StockStatus.low;
  return StockStatus.ok;
}

Color stockStatusColor(StockStatus status) {
  return switch (status) {
    StockStatus.ok => AppColors.success,
    StockStatus.low => AppColors.warning,
    StockStatus.critical => AppColors.danger,
  };
}

String stockStatusLabel(StockStatus status) {
  return switch (status) {
    StockStatus.ok => 'Stock saludable',
    StockStatus.low => 'Stock bajo',
    StockStatus.critical => 'Reponer ahora',
  };
}
