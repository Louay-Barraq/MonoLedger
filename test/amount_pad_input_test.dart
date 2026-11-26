import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:monoledger/core/utils/amount_pad_input.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';

void main() {
  test('parses comma decimal separator', () {
    expect(AmountPadInput.parse('150,5'), 150.5);
    expect(AmountPadInput.parse('12,25'), 12.25);
  });

  test('onKey builds decimal entry', () {
    final input = AmountPadInput();
    input.onKey('1');
    input.onKey('5');
    input.onKey(',');
    input.onKey('5');
    expect(input.raw, '15,5');
    expect(input.value, 15.5);
  });

  test('formatPadAmount shows the trailing decimal separator while typing', () {
    final input = AmountPadInput();
    input.onKey('1');
    input.onKey(',');
    expect(CurrencyFormatter.formatPadAmount('\$', input.raw), '\$ 1.');
  });

  test('numbers follow the app language', () {
    addTearDown(() => Intl.defaultLocale = null);

    Intl.defaultLocale = 'de';
    expect(CurrencyFormatter.formatMoney('€', 1500.5), '€ 1.500,5');
    expect(CurrencyFormatter.formatPadAmount('€', '1500,'), '€ 1.500,');
    expect(CurrencyFormatter.decimalSeparator, ',');

    Intl.defaultLocale = 'fr';
    expect(CurrencyFormatter.formatMoney('€', 1850), '€ 1\u00A0850');

    Intl.defaultLocale = 'en';
    expect(CurrencyFormatter.formatMoney(r'$', 1500.5), r'$ 1,500.5');
    expect(CurrencyFormatter.formatPadAmount(r'$', '12,5'), r'$ 12.5');
  });

  test('formatMoney shows decimals when needed', () {
    expect(CurrencyFormatter.formatMoney('\$', 12.5), '\$ 12.5');
    expect(CurrencyFormatter.formatMoney('\$', 1500), '\$ 1,500');
  });
}
