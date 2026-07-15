import 'package:intl/intl.dart';

abstract final class AppFormatters {
  static final NumberFormat _currency = NumberFormat.currency(
    locale: 'es',
    symbol: 'Bs. ',
    decimalDigits: 2,
  );

  static final DateFormat _date = DateFormat('dd/MM/yyyy HH:mm');

  static String currency(num value) => _currency.format(value);

  static String date(DateTime value) => _date.format(value);
}
