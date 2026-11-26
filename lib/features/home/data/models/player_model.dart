import '../../domain/entities/player.dart';

class PlayerModel extends Player {
  const PlayerModel({
    required super.id,
    required super.sessionId,
    required super.userId,
    required super.name,
    required super.balance,
    required super.isBanker,
    super.status,
  });

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'],
      sessionId: json['session_id'],
      userId: json['user_id'] as String? ?? '',
      name: json['name'] ?? 'Unknown',
      balance: (json['balance'] as num).toDouble(),
      isBanker: json['is_banker'] ?? false,
      status: (json['status'] as String?)?.toUpperCase() ?? 'ACTIVE',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'user_id': userId,
      'name': name,
      'balance': balance,
      'is_banker': isBanker,
      'status': status,
    };
  }
}
