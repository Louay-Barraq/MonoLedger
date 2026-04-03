import 'package:intl/intl.dart';

class CurrencyFormatter {
  /// Formats an integer amount with commas (e.g., 1500 to 1,500)
  static String formatAmount(int amount) {
    final formatter = NumberFormat('#,##0', 'en_US');
    return formatter.format(amount);
  }
}
