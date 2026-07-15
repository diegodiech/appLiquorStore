import 'package:flutter/material.dart';

import '../../models/venta.dart';
import '../utils/formatters.dart';
import '../utils/payment_method_style.dart';
import 'app_chip.dart';

/// Tarjeta de comprobante de venta: usada tanto en el Ticket Digital (justo
/// tras cerrar una venta) como en el Historial de ventas del administrador.
class ReceiptCard extends StatelessWidget {
  const ReceiptCard({
    super.key,
    required this.venta,
    this.title = 'Venta registrada',
    this.showSuccessIcon = true,
    this.cajeroNombre,
  });

  final Venta venta;
  final String title;
  final bool showSuccessIcon;
  final String? cajeroNombre;

  @override
  Widget build(BuildContext context) {
    final paymentStyle = paymentMethodStyleFor(venta.metodoPago);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (showSuccessIcon) ...[
              const Icon(Icons.check_circle, color: Colors.green, size: 48),
              const SizedBox(height: 8),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
            ],
            Text(
              'Ticket N.° ${venta.codigoTicket}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              AppFormatters.date(venta.fecha),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            if (cajeroNombre != null) ...[
              const SizedBox(height: 4),
              Text(
                'Atendido por: $cajeroNombre',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.grey),
              ),
            ],
            const Divider(height: 32),
            if (venta.detalle.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text('Sin detalle de productos disponible.'),
              )
            else
              ...venta.detalle.map(
                (detalle) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text('${detalle.cantidad}x ${detalle.nombreProducto}'),
                      ),
                      Text(AppFormatters.currency(detalle.subtotal)),
                    ],
                  ),
                ),
              ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(
                  AppFormatters.currency(venta.total),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 12),
            AppChip(
              label: venta.metodoPago.label,
              color: paymentStyle.color,
              icon: paymentStyle.icon,
            ),
            if (venta.montoRecibido != null) ...[
              const SizedBox(height: 12),
              Text('Paga con: ${AppFormatters.currency(venta.montoRecibido!)}'),
              Text('Cambio: ${AppFormatters.currency(venta.cambio)}'),
            ],
          ],
        ),
      ),
    );
  }
}
