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

String _formatRelativeTime(DateTime createdAt) {
  final diff = DateTime.now().difference(createdAt);
  if (diff.inMinutes < 1) return 'Just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}

LedgerDisplayItem ledgerDisplayItem({
  required LedgerTransaction tx,
  required String currency,
  required List<Player> players,
}) {
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
        title: 'From The Bank',
        subtitle: 'PASSED GO • ${_playerName(names, tx.toPlayerId, 'PLAYER')}',
        timeLabel: _formatRelativeTime(tx.createdAt),
        amountLabel: signedAmount,
        isPositive: true,
      );
    case TransactionType.fromBank:
      return LedgerDisplayItem(
        type: tx.type,
        title: 'From The Bank',
        subtitle:
            '${(tx.memo ?? 'FROM BANK').toUpperCase()} • ${_playerName(names, tx.toPlayerId, 'PLAYER')}',
        timeLabel: _formatRelativeTime(tx.createdAt),
        amountLabel: signedAmount,
        isPositive: true,
      );
    case TransactionType.payBank:
      return LedgerDisplayItem(
        type: tx.type,
        title: 'To The Bank',
        subtitle:
            '${(tx.memo ?? 'PAY BANK').toUpperCase()} • ${_playerName(names, tx.fromPlayerId, 'PLAYER')}',
        timeLabel: _formatRelativeTime(tx.createdAt),
        amountLabel: signedAmount,
        isPositive: false,
      );
    case TransactionType.playerToPlayer:
      final from = _playerName(names, tx.fromPlayerId, '?');
      final to = _playerName(names, tx.toPlayerId, '?');
      return LedgerDisplayItem(
        type: tx.type,
        title: '$from → $to',
        subtitle: (tx.memo ?? 'TRANSFER').toUpperCase(),
        timeLabel: _formatRelativeTime(tx.createdAt),
        amountLabel: signedAmount,
        isPositive: false,
      );
  }
}
