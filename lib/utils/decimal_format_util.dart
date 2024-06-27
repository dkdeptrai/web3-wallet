import 'package:intl/intl.dart';

class DecimalFormatUtil {
  static String formatDouble(double number) {
    NumberFormat formatter = NumberFormat('#.##');
    return formatter.format(number);
  }
}
