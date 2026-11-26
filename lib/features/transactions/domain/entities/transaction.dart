import 'package:equatable/equatable.dart';

enum TransactionType { playerToPlayer, payBank, fromBank, collectGo }

class LedgerTransaction extends Equatable {
  final String id;
  final String sessionId;
  final TransactionType type;
  final String? fromPlayerId;
  final String? toPlayerId;
  final String? fromPlayerName;
  final String? toPlayerName;
  final double amount;
  final String? memo;
  final DateTime createdAt;

  /// Set when this entry undoes another transaction.
  final String? reversesTxId;

  const LedgerTransaction({
    required this.id,
    required this.sessionId,
    required this.type,
    this.fromPlayerId,
    this.toPlayerId,
    this.fromPlayerName,
    this.toPlayerName,
    required this.amount,
    this.memo,
    required this.createdAt,
    this.reversesTxId,
  });

  @override
  List<Object?> get props => [
    id,
    sessionId,
    type,
    fromPlayerId,
    toPlayerId,
    amount,
    memo,
    createdAt,
    reversesTxId,
  ];
}
