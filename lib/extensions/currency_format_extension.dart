import 'package:intl/intl.dart';

extension CurrencyFormatExt on double {
  String get toCurrencyFormat {
    final formatCurrency = NumberFormat.simpleCurrency();
    return formatCurrency.format(this);
  }

  String get formatDoubleWith2Decimals {
    return toStringAsFixed(2);
  }
}
