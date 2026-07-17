// DECIMAL de MySQL llega como String en el JSON (mysql2 evita imprecisión de
// punto flotante); acepta también num por si alguna vez cambia esa config.
double parseDecimal(dynamic value) {
  if (value is num) return value.toDouble();
  return double.parse(value.toString());
}
