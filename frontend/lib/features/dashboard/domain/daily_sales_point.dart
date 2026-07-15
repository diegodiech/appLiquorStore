/// Punto agregado de ventas por día, usado solo para graficar el dashboard.
/// No corresponde a una tabla de la base de datos.
class DailySalesPoint {
  const DailySalesPoint({required this.date, required this.total});

  final DateTime date;
  final double total;
}
