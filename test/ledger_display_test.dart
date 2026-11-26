import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/features/dashboard/presentation/utils/ledger_display.dart';
import 'package:monoledger/features/home/domain/entities/player.dart';
import 'package:monoledger/features/transactions/domain/entities/transaction.dart';

void main() {
  const players = [
    Player(
      id: 'p1',
      sessionId: 's1',
      userId: 'u1',
      name: 'Pat',
      balance: 0,
      isBanker: false,
    ),
  ];

  LedgerTransaction tx(
    TransactionType type, {
    String? from,
    String? to,
    String? memo,
  }) => LedgerTransaction(
    id: 't',
    sessionId: 's1',
    type: type,
    fromPlayerId: from,
    toPlayerId: to,
    amount: 100,
    memo: memo,
    createdAt: DateTime(2026),
  );

  test('bank payments name the player who paid', () {
    final item = ledgerDisplayItem(
      tx: tx(TransactionType.payBank, from: 'p1', memo: 'PAY BANK'),
      currency: r'$',
      players: players,
      l10n: lookupAppLocalizations(const Locale('en')),
    );
    expect(item.subtitle, 'PAY BANK • Pat');
    expect(item.isPositive, isFalse);
  });

  test('bank payouts name the player who received', () {
    final item = ledgerDisplayItem(
      tx: tx(TransactionType.fromBank, to: 'p1', memo: 'REVERSAL'),
      currency: r'$',
      players: players,
      l10n: lookupAppLocalizations(const Locale('en')),
    );
    expect(item.subtitle, 'REVERSAL • Pat');
    expect(item.isPositive, isTrue);
  });
}
