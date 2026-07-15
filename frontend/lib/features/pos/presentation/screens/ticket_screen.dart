import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/widgets/async_value_view.dart';
import '../../../../core/widgets/receipt_card.dart';
import '../../application/checkout_provider.dart';

class TicketScreen extends ConsumerWidget {
  const TicketScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkoutState = ref.watch(checkoutProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket digital'),
        automaticallyImplyLeading: false,
      ),
      body: AsyncValueView(
        value: checkoutState,
        data: (venta) {
          if (venta == null) {
            return const Center(child: Text('No hay una venta reciente que mostrar.'));
          }
          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ReceiptCard(venta: venta),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        ref.read(checkoutProvider.notifier).reset();
                        context.go('/cashier');
                      },
                      child: const Text('Nueva venta'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
