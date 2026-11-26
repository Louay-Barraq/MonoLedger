import 'package:flutter_test/flutter_test.dart';
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

  test('formatPadAmount shows trailing comma while typing', () {
    final input = AmountPadInput();
    input.onKey('1');
    input.onKey(',');
    expect(CurrencyFormatter.formatPadAmount('\$', input.raw), '\$ 1,');
  });

  test('formatMoney shows decimals when needed', () {
    expect(CurrencyFormatter.formatMoney('\$', 12.5), '\$ 12.5');
    expect(CurrencyFormatter.formatMoney('\$', 1500), '\$ 1,500');
  });
}
