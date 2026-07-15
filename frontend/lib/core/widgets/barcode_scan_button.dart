import 'package:flutter/material.dart';

/// Botón de escaneo de código de barras.
///
/// Placeholder de UI: el equipo de backend/hardware conectará aquí la
/// cámara real (p. ej. mobile_scanner) y llamará a [onScanned] con el
/// código leído. Por ahora simula la lectura para permitir probar el flujo.
class BarcodeScanButton extends StatelessWidget {
  const BarcodeScanButton({super.key, required this.onScanned});

  final ValueChanged<String> onScanned;

  Future<void> _simulateScan(BuildContext context) async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Escanear código de barras'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'La cámara se conectará aquí. Por ahora, ingresa el código '
              'manualmente para simular la lectura.',
            ),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Código de barra'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(controller.text.trim()),
            child: const Text('Usar código'),
          ),
        ],
      ),
    );

    if (code != null && code.isNotEmpty) onScanned(code);
  }

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: () => _simulateScan(context),
      icon: const Icon(Icons.qr_code_scanner),
      label: const Text('Escanear'),
    );
  }
}
