import '../../domain/entities/transaction.dart';

class TransactionModel extends LedgerTransaction {
  const TransactionModel({
    required super.id,
    required super.sessionId,
    required super.type,
    super.fromPlayerId,
    super.toPlayerId,
    super.fromPlayerName,
    super.toPlayerName,
    required super.amount,
    super.memo,
    required super.createdAt,
  });

  static TransactionType _parseType(String type) {
    switch (type) {
      case 'player_to_player':
        return TransactionType.playerToPlayer;
      case 'pay_bank':
        return TransactionType.payBank;
      case 'from_bank':
        return TransactionType.fromBank;
      case 'collect_go':
        return TransactionType.collectGo;
      default:
        return TransactionType.playerToPlayer;
    }
  }

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      type: _parseType(json['type'] as String),
      fromPlayerId: json['from_player_id'] as String?,
      toPlayerId: json['to_player_id'] as String?,
      fromPlayerName: json['from_player_name'] as String?,
      toPlayerName: json['to_player_name'] as String?,
      amount: (json['amount'] as num).toDouble(),
      memo: json['memo'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }
}
