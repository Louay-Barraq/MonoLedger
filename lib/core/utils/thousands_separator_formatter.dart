import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class ThousandsSeparatorInputFormatter extends TextInputFormatter {
  // Not cached: the grouping separator follows the current language.
  static NumberFormat get _formatter => NumberFormat('#,###');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    // Remove any non-digit characters
    String cleanText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // Parse to int
    int? value = int.tryParse(cleanText);
    if (value == null) return oldValue;

    // Format the number
    String formattedText = _formatter.format(value);

    // Return the new value with the correct selection
    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(offset: formattedText.length),
    );
  }
}
