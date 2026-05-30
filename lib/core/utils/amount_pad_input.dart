/// Keypad amount entry with comma or period as the decimal separator.
class AmountPadInput {
  static const int maxWholeDigits = 8;
  static const int maxDecimalPlaces = 2;

  String raw = '';

  double get value => parse(raw);

  bool get isEmpty => raw.isEmpty;

  static double parse(String raw) {
    if (raw.isEmpty) return 0;
    final normalized = raw.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0;
  }

  void clear() => raw = '';

  void backspace() {
    if (raw.isEmpty) return;
    raw = raw.substring(0, raw.length - 1);
  }

  void onKey(String key) {
    if (key == 'C') {
      clear();
      return;
    }
    if (key == '<') {
      backspace();
      return;
    }
    if (key == ',' || key == '.') {
      _insertDecimalSeparator();
      return;
    }
    if (key.length == 1 && key.codeUnitAt(0) >= 48 && key.codeUnitAt(0) <= 57) {
      _insertDigit(key);
    }
  }

  void add(num increment) {
    final next = value + increment.toDouble();
    if (next > 99999999.99) return;
    raw = _formatRaw(next);
  }

  void _insertDecimalSeparator() {
    if (raw.contains(',') || raw.contains('.')) return;
    if (raw.isEmpty) {
      raw = '0,';
      return;
    }
    raw = '$raw,';
  }

  void _insertDigit(String digit) {
    final sepIndex = _separatorIndex;
    if (sepIndex >= 0) {
      final decimals = raw.substring(sepIndex + 1);
      if (decimals.length >= maxDecimalPlaces) return;
      raw += digit;
      return;
    }

    if (raw == '0') {
      raw = digit;
      return;
    }

    final whole = sepIndex < 0 ? raw : raw.substring(0, sepIndex);
    if (whole.length >= maxWholeDigits) return;
    raw += digit;
  }

  int get _separatorIndex {
    final comma = raw.indexOf(',');
    if (comma >= 0) return comma;
    return raw.indexOf('.');
  }

  static String _formatRaw(double value) {
    if (value == value.truncateToDouble()) {
      return value.truncate().toString();
    }
    var s = value.toStringAsFixed(2);
    if (s.contains('.')) {
      s = s.replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
    }
    return s.replaceAll('.', ',');
  }
}
