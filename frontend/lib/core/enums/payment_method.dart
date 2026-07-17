enum PaymentMethod {
  efectivo,
  qrTransferencia;

  String get label => switch (this) {
        PaymentMethod.efectivo => 'Efectivo',
        PaymentMethod.qrTransferencia => 'QR Externo / Transferencia',
      };

  /// Valor que espera/devuelve el backend (columna `metodo_pago`, ENUM).
  String get wireValue => switch (this) {
        PaymentMethod.efectivo => 'Efectivo',
        PaymentMethod.qrTransferencia => 'QR',
      };

  static PaymentMethod fromWireValue(String value) => switch (value) {
        'Efectivo' => PaymentMethod.efectivo,
        'QR' => PaymentMethod.qrTransferencia,
        _ => throw ArgumentError('metodo_pago desconocido: $value'),
      };
}
