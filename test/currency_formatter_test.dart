import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';

void main() {
  test('formatMoney separates symbol and amount with a space', () {
    expect(CurrencyFormatter.formatMoney('\$', 1500), '\$ 1,500');
    expect(CurrencyFormatter.formatMoney('€', 200), '€ 200');
  });

  test('formatMoney supports fractional amounts', () {
    expect(CurrencyFormatter.formatMoney('\$', 12.5), '\$ 12.5');
  });

  test('formatSignedMoney includes sign and space', () {
    expect(
      CurrencyFormatter.formatSignedMoney('\$', 200, positive: true),
      '+\$ 200',
    );
    expect(
      CurrencyFormatter.formatSignedMoney('\$', 50, positive: false),
      '-\$ 50',
    );
  });
}
