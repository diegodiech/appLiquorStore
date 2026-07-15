enum PaymentMethod {
  efectivo,
  qrTransferencia;

  String get label => switch (this) {
        PaymentMethod.efectivo => 'Efectivo',
        PaymentMethod.qrTransferencia => 'QR Externo / Transferencia',
      };
}
