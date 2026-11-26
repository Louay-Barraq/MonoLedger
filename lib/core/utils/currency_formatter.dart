import 'package:intl/intl.dart';
import 'package:monoledger/core/utils/amount_pad_input.dart';

class CurrencyFormatter {
  /// Follows the app language (set in main.dart); English when unset.
  static String get _locale => Intl.defaultLocale ?? 'en_US';

  /// "." in English, "," in French, Spanish and German.
  static String get decimalSeparator =>
      NumberFormat.decimalPattern(_locale).symbols.DECIMAL_SEP;

  /// Formats a numeric amount with grouping; shows decimals when needed.
  static String formatAmount(num amount) {
    final value = amount.toDouble();
    if (value.isNaN || value.isInfinite) return '0';
    final isWhole = (value - value.truncateToDouble()).abs() < 1e-9;
    if (isWhole) {
      return _group('#,##0', value.truncate());
    }
    return _group('#,##0.##', value);
  }

  /// French groups with a narrow no-break space that the display fonts lack
  /// (it renders as nothing), so use the ordinary no-break space.
  static String _group(String pattern, num value) => NumberFormat(
    pattern,
    _locale,
  ).format(value).replaceAll('\u202F', '\u00A0');

  /// Currency symbol and amount with a space (e.g. "$ 1,500" or "$ 12.5").
  static String formatMoney(String symbol, num amount) {
    return '$symbol ${formatAmount(amount)}';
  }

  /// Signed amount for ledger entries (e.g. "+$ 200", "-$ 50.25").
  static String formatSignedMoney(
    String symbol,
    num amount, {
    required bool positive,
  }) {
    final sign = positive ? '+' : '-';
    return '$sign$symbol ${formatAmount(amount.abs())}';
  }

  /// Live display for payment pad entry, using the language's decimal separator.
  static String formatPadAmount(String symbol, String raw) {
    if (raw.isEmpty) return '$symbol 0';

    final sepIndex = raw.indexOf(',');
    if (sepIndex < 0 && !raw.contains('.')) {
      final whole = int.tryParse(raw) ?? 0;
      return formatMoney(symbol, whole);
    }

    final commaIndex = sepIndex >= 0 ? sepIndex : raw.indexOf('.');
    final before = raw.substring(0, commaIndex);
    final after = commaIndex < raw.length - 1
        ? raw.substring(commaIndex + 1)
        : '';
    final intPart = int.tryParse(before.isEmpty ? '0' : before) ?? 0;
    final formattedInt = _group('#,##0', intPart);

    if (after.isEmpty && (raw.endsWith(',') || raw.endsWith('.'))) {
      return '$symbol $formattedInt$decimalSeparator';
    }
    if (after.isNotEmpty) {
      return '$symbol $formattedInt$decimalSeparator$after';
    }
    return formatMoney(symbol, AmountPadInput.parse(raw));
  }
}
