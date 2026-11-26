import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/utils/join_code_parser.dart';

void main() {
  test('parse raw 6-character code', () {
    expect(JoinCodeParser.parse('abc123'), 'ABC123');
  });

  test('parse monoledger URI', () {
    expect(JoinCodeParser.parse('monoledger://join?code=XYZ789'), 'XYZ789');
  });

  test('encodeForQr builds URI', () {
    expect(
      JoinCodeParser.encodeForQr('abcd12'),
      'monoledger://join?code=ABCD12',
    );
  });

  test('returns null for invalid', () {
    expect(JoinCodeParser.parse('123'), isNull);
  });
}
