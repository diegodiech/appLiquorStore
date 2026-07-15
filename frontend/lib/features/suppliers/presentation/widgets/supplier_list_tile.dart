import 'package:flutter/material.dart';

import '../../../../models/proveedor.dart';

class SupplierListTile extends StatelessWidget {
  const SupplierListTile({
    super.key,
    required this.proveedor,
    required this.onEdit,
    required this.onDelete,
  });

  final Proveedor proveedor;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(child: Icon(Icons.local_shipping_outlined)),
        title: Text(proveedor.nombreEmpresa),
        subtitle: Text(proveedor.telefono),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: onEdit,
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
