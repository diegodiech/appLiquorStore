import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/enums/payment_method.dart';
import '../../../../core/utils/formatters.dart';
import '../../application/cart_provider.dart';
import '../../application/checkout_provider.dart';

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  PaymentMethod _metodoPago = PaymentMethod.efectivo;
  final _montoRecibidoController = TextEditingController();

  @override
  void dispose() {
    _montoRecibidoController.dispose();
    super.dispose();
  }

  double? get _montoRecibido => double.tryParse(_montoRecibidoController.text);

  Future<void> _cerrarVenta(double total) async {
    final montoRecibido =
        _metodoPago == PaymentMethod.efectivo ? _montoRecibido : null;

    await ref.read(checkoutProvider.notifier).confirmSale(
          metodoPago: _metodoPago,
          montoRecibido: montoRecibido,
        );

    final checkoutState = ref.read(checkoutProvider);
    if (checkoutState.hasError) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cerrar la venta: ${checkoutState.error}')),
        );
      }
      return;
    }

    if (mounted) context.go('/cashier/ticket');
  }

  @override
  Widget build(BuildContext context) {
    final total = ref.watch(cartTotalProvider);
    final checkoutState = ref.watch(checkoutProvider);
    final isProcessing = checkoutState.isLoading;

    final montoRecibido = _montoRecibido;
    final cambio = (_metodoPago == PaymentMethod.efectivo &&
            montoRecibido != null &&
            montoRecibido >= total)
        ? montoRecibido - total
        : null;

    return Scaffold(
      appBar: AppBar(title: const Text('Confirmación de pago')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 480),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total a pagar', style: TextStyle(fontSize: 16)),
                      Text(
                        AppFormatters.currency(total),
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text('Método de pago', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SegmentedButton<PaymentMethod>(
                segments: const [
                  ButtonSegment(
                    value: PaymentMethod.efectivo,
                    label: Text('Efectivo'),
                    icon: Icon(Icons.payments_outlined),
                  ),
                  ButtonSegment(
                    value: PaymentMethod.qrTransferencia,
                    label: Text('QR / Transferencia'),
                    icon: Icon(Icons.qr_code),
                  ),
                ],
                selected: {_metodoPago},
                onSelectionChanged: (selection) =>
                    setState(() => _metodoPago = selection.first),
              ),
              if (_metodoPago == PaymentMethod.efectivo) ...[
                const SizedBox(height: 20),
                TextField(
                  controller: _montoRecibidoController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  decoration: const InputDecoration(
                    labelText: '¿Con cuánto paga el cliente? (opcional)',
                    prefixText: 'Bs. ',
                  ),
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 12),
                if (cambio != null)
                  Text(
                    'Cambio: ${AppFormatters.currency(cambio)}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
              ],
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: isProcessing ? null : () => _cerrarVenta(total),
                child: isProcessing
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                      )
                    : const Text('Cerrar venta'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
