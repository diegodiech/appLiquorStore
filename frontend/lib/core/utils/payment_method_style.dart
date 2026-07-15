import 'package:flutter/material.dart';

import '../enums/payment_method.dart';

class PaymentMethodStyle {
  const PaymentMethodStyle({required this.color, required this.icon});

  final Color color;
  final IconData icon;
}

PaymentMethodStyle paymentMethodStyleFor(PaymentMethod metodo) {
  return switch (metodo) {
    PaymentMethod.efectivo =>
      const PaymentMethodStyle(color: Color(0xFF16A34A), icon: Icons.payments_outlined),
    PaymentMethod.qrTransferencia =>
      const PaymentMethodStyle(color: Color(0xFF2563EB), icon: Icons.qr_code),
  };
}
