import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/features/home/domain/entities/player.dart';
import 'package:monoledger/features/transactions/domain/entities/transaction.dart';

class LedgerDisplayItem {
  final TransactionType type;
  final String title;
  final String subtitle;
  final String timeLabel;
  final String amountLabel;
  final bool isPositive;

  const LedgerDisplayItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.timeLabel,
    required this.amountLabel,
    required this.isPositive,
  });
}

String _playerName(Map<String, String> names, String? id, String fallback) {
  if (id == null) return fallback;
  return names[id] ?? fallback;
}

String _formatRelativeTime(AppLocalizations l10n, DateTime createdAt) {
  final diff = DateTime.now().difference(createdAt);
  if (diff.inMinutes < 1) return l10n.ledgerJustNow;
  if (diff.inMinutes < 60) return l10n.ledgerMinutesAgo(diff.inMinutes);
  if (diff.inHours < 24) return l10n.ledgerHoursAgo(diff.inHours);
  return l10n.ledgerDaysAgo(diff.inDays);
}

LedgerDisplayItem ledgerDisplayItem({
  required LedgerTransaction tx,
  required String currency,
  required List<Player> players,
  required AppLocalizations l10n,
}) {
  final player = l10n.commonPlayer.toUpperCase();
  final names = {for (final p in players) p.id: p.name};
  final signedAmount = switch (tx.type) {
    TransactionType.payBank => CurrencyFormatter.formatSignedMoney(
      currency,
      tx.amount,
      positive: false,
    ),
    TransactionType.fromBank || TransactionType.collectGo =>
      CurrencyFormatter.formatSignedMoney(currency, tx.amount, positive: true),
    TransactionType.playerToPlayer => CurrencyFormatter.formatSignedMoney(
      currency,
      tx.amount,
      positive: false,
    ),
  };
  switch (tx.type) {
    case TransactionType.collectGo:
      return LedgerDisplayItem(
        type: tx.type,
        title: l10n.ledgerFromBank,
        subtitle:
            '${l10n.memoPassedGo} • ${_playerName(names, tx.toPlayerId, player)}',
        timeLabel: _formatRelativeTime(l10n, tx.createdAt),
        amountLabel: signedAmount,
        isPositive: true,
      );
    case TransactionType.fromBank:
      return LedgerDisplayItem(
        type: tx.type,
        title: l10n.ledgerFromBank,
        subtitle:
            '${l10n.memo(tx.memo, 'FROM BANK')} • ${_playerName(names, tx.toPlayerId, player)}',
        timeLabel: _formatRelativeTime(l10n, tx.createdAt),
        amountLabel: signedAmount,
        isPositive: true,
      );
    case TransactionType.payBank:
      return LedgerDisplayItem(
        type: tx.type,
        title: l10n.ledgerToBank,
        subtitle:
            '${l10n.memo(tx.memo, 'PAY BANK')} • ${_playerName(names, tx.fromPlayerId, player)}',
        timeLabel: _formatRelativeTime(l10n, tx.createdAt),
        amountLabel: signedAmount,
        isPositive: false,
      );
    case TransactionType.playerToPlayer:
      final from = _playerName(names, tx.fromPlayerId, '?');
      final to = _playerName(names, tx.toPlayerId, '?');
      return LedgerDisplayItem(
        type: tx.type,
        title: '$from → $to',
        subtitle: l10n.memo(tx.memo, 'TRANSFER'),
        timeLabel: _formatRelativeTime(l10n, tx.createdAt),
        amountLabel: signedAmount,
        isPositive: false,
      );
  }
}
