import 'package:intl/intl.dart';

class DateTimeFormatUtil {
  static String formatDateTime(DateTime dateTime) {
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(dateTime);
  }
}
