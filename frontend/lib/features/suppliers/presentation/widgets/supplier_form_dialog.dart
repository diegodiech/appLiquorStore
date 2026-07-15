import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/proveedor.dart';
import '../../application/supplier_list_provider.dart';

/// Abre el diálogo de alta/edición de proveedor. [proveedor] nulo = alta.
Future<void> showSupplierFormDialog(
  BuildContext context, {
  Proveedor? proveedor,
}) {
  return showDialog(
    context: context,
    builder: (context) => SupplierFormDialog(proveedor: proveedor),
  );
}

class SupplierFormDialog extends ConsumerStatefulWidget {
  const SupplierFormDialog({super.key, this.proveedor});

  final Proveedor? proveedor;

  @override
  ConsumerState<SupplierFormDialog> createState() =>
      _SupplierFormDialogState();
}

class _SupplierFormDialogState extends ConsumerState<SupplierFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _nombreController =
      TextEditingController(text: widget.proveedor?.nombreEmpresa ?? '');
  late final _telefonoController =
      TextEditingController(text: widget.proveedor?.telefono ?? '');
  bool _isSaving = false;

  bool get _isEditing => widget.proveedor != null;

  @override
  void dispose() {
    _nombreController.dispose();
    _telefonoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);

    final controller = ref.read(supplierListProvider.notifier);
    final proveedor = Proveedor(
      idProveedor: widget.proveedor?.idProveedor ??
          'prov_${DateTime.now().microsecondsSinceEpoch}',
      nombreEmpresa: _nombreController.text.trim(),
      telefono: _telefonoController.text.trim(),
    );

    if (_isEditing) {
      await controller.updateSupplier(proveedor);
    } else {
      await controller.addSupplier(proveedor);
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Editar proveedor' : 'Registrar proveedor'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: _nombreController,
              decoration: const InputDecoration(labelText: 'Empresa'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Campo requerido'
                  : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Teléfono'),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? 'Campo requerido'
                  : null,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: _isSaving ? null : () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isSaving ? null : _submit,
          child: _isSaving
              ? const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Guardar'),
        ),
      ],
    );
  }
}
