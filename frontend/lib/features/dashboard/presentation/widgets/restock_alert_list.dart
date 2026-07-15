import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../models/producto.dart';

class RestockAlertList extends StatelessWidget {
  const RestockAlertList({super.key, required this.productos});

  final List<Producto> productos;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: AppColors.warning),
                const SizedBox(width: 8),
                Text(
                  'Alertas de reposición',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 12),
            if (productos.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Text('Todos los productos tienen stock suficiente.'),
              )
            else
              ...productos.map(
                (producto) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.liquor_outlined),
                  title: Text(producto.nombre),
                  subtitle: Text('Mínimo requerido: ${producto.stockMinimo}'),
                  trailing: Text(
                    'Stock: ${producto.stockActual}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.danger,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
