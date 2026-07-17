import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../models/categoria.dart';
import '../../../../models/producto.dart';
import '../../../../models/proveedor.dart';
import '../../../../core/widgets/barcode_scan_button.dart';
import '../../../suppliers/application/supplier_list_provider.dart';
import '../../application/category_list_provider.dart';
import '../../application/product_list_provider.dart';

class ProductFormScreen extends ConsumerStatefulWidget {
  const ProductFormScreen({super.key, this.producto});

  /// Producto a editar. Nulo cuando se registra uno nuevo.
  final Producto? producto;

  @override
  ConsumerState<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends ConsumerState<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final _nombreController =
      TextEditingController(text: widget.producto?.nombre ?? '');
  late final _codigoBarraController =
      TextEditingController(text: widget.producto?.codigoBarra ?? '');
  late final _precioCompraController = TextEditingController(
      text: widget.producto?.precioCompra.toStringAsFixed(2) ?? '');
  late final _precioVentaController = TextEditingController(
      text: widget.producto?.precioVenta.toStringAsFixed(2) ?? '');
  late final _stockActualController =
      TextEditingController(text: widget.producto?.stockActual.toString() ?? '0');
  late final _stockMinimoController =
      TextEditingController(text: widget.producto?.stockMinimo.toString() ?? '');

  String? _idCategoria;
  String? _idProveedor;
  bool _isSaving = false;

  bool get _isEditing => widget.producto != null;

  @override
  void initState() {
    super.initState();
    _idCategoria = widget.producto?.idCategoria;
    _idProveedor = widget.producto?.idProveedor;
  }

  @override
  void dispose() {
    _nombreController.dispose();
    _codigoBarraController.dispose();
    _precioCompraController.dispose();
    _precioVentaController.dispose();
    _stockActualController.dispose();
    _stockMinimoController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_idCategoria == null || _idProveedor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Selecciona categoría y proveedor')),
      );
      return;
    }

    setState(() => _isSaving = true);

    final producto = Producto(
      idProducto: widget.producto?.idProducto ??
          'p_${DateTime.now().microsecondsSinceEpoch}',
      nombre: _nombreController.text.trim(),
      codigoBarra: _codigoBarraController.text.trim(),
      precioCompra: double.parse(_precioCompraController.text),
      precioVenta: double.parse(_precioVentaController.text),
      stockActual: int.parse(_stockActualController.text),
      stockMinimo: int.parse(_stockMinimoController.text),
      idCategoria: _idCategoria!,
      idProveedor: _idProveedor!,
    );

    final controller = ref.read(productListProvider.notifier);
    try {
      if (_isEditing) {
        await controller.updateProduct(producto);
      } else {
        await controller.addProduct(producto);
      }
    } catch (error) {
      if (mounted) {
        setState(() => _isSaving = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No se pudo guardar el producto: $error')),
        );
      }
      return;
    }

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoryListProvider);
    final suppliersAsync = ref.watch(supplierListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar producto' : 'Registrar producto'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
                validator: _requiredValidator,
              ),
              const SizedBox(height: 12),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _codigoBarraController,
                      decoration:
                          const InputDecoration(labelText: 'Código de barra'),
                      validator: _requiredValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: BarcodeScanButton(
                      onScanned: (code) =>
                          setState(() => _codigoBarraController.text = code),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _precioCompraController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Precio de compra'),
                      validator: _decimalValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _precioVentaController,
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      decoration:
                          const InputDecoration(labelText: 'Precio de venta'),
                      validator: _decimalValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _stockActualController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Stock actual'),
                      validator: _intValidator,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _stockMinimoController,
                      keyboardType: TextInputType.number,
                      decoration:
                          const InputDecoration(labelText: 'Stock mínimo'),
                      validator: _intValidator,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              categoriesAsync.when(
                data: (categorias) => _CategoryDropdown(
                  categorias: categorias,
                  value: _idCategoria,
                  onChanged: (value) => setState(() => _idCategoria = value),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('Error al cargar categorías: $error'),
              ),
              const SizedBox(height: 12),
              suppliersAsync.when(
                data: (proveedores) => _SupplierDropdown(
                  proveedores: proveedores,
                  value: _idProveedor,
                  onChanged: (value) => setState(() => _idProveedor = value),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, _) => Text('Error al cargar proveedores: $error'),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isSaving ? null : _submit,
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Guardar producto'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? _requiredValidator(String? value) {
    return (value == null || value.trim().isEmpty) ? 'Campo requerido' : null;
  }

  String? _decimalValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo requerido';
    return double.tryParse(value) == null ? 'Ingresa un número válido' : null;
  }

  String? _intValidator(String? value) {
    if (value == null || value.trim().isEmpty) return 'Campo requerido';
    return int.tryParse(value) == null ? 'Ingresa un número entero' : null;
  }
}

class _CategoryDropdown extends StatelessWidget {
  const _CategoryDropdown({
    required this.categorias,
    required this.value,
    required this.onChanged,
  });

  final List<Categoria> categorias;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Categoría'),
      items: categorias
          .map((c) => DropdownMenuItem(
                value: c.idCategoria,
                child: Text(c.nombreCategoria),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Selecciona una categoría' : null,
    );
  }
}

class _SupplierDropdown extends StatelessWidget {
  const _SupplierDropdown({
    required this.proveedores,
    required this.value,
    required this.onChanged,
  });

  final List<Proveedor> proveedores;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: const InputDecoration(labelText: 'Proveedor'),
      items: proveedores
          .map((p) => DropdownMenuItem(
                value: p.idProveedor,
                child: Text(p.nombreEmpresa),
              ))
          .toList(),
      onChanged: onChanged,
      validator: (value) => value == null ? 'Selecciona un proveedor' : null,
    );
  }
}
