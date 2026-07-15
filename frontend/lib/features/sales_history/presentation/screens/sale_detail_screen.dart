import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/receipt_card.dart';
import '../../../../models/venta.dart';
import '../../../auth/application/auth_provider.dart';

class SaleDetailScreen extends ConsumerWidget {
  const SaleDetailScreen({super.key, required this.venta});

  final Venta venta;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usuarios = ref.watch(usuariosProvider).valueOrNull ?? const [];
    final cajeroMatch = usuarios.where((u) => u.idUsuario == venta.idUsuario);
    final cajeroNombre = cajeroMatch.isEmpty ? null : cajeroMatch.first.nombre;

    return Scaffold(
      appBar: AppBar(title: Text('Venta ${venta.codigoTicket}')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: ReceiptCard(
              venta: venta,
              title: 'Detalle de venta',
              showSuccessIcon: false,
              cajeroNombre: cajeroNombre,
            ),
          ),
        ),
      ),
    );
  }
}
