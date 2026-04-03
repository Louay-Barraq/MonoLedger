import 'package:equatable/equatable.dart';
import 'player.dart';

class Session extends Equatable {
  final String id;
  final String status;
  final String hostId;
  final String? joinCode;
  final DateTime createdAt;

  final List<Player> players;
  final Map<String, dynamic> config;

  const Session({
    required this.id,
    required this.status,
    required this.hostId,
    this.joinCode,
    required this.createdAt,
    this.players = const [],
    this.config = const {},
  });

  @override
  List<Object?> get props => [id, status, hostId, joinCode, createdAt, players, config];

  String get currency => config['currency']?.toString() ?? '\$';
  int get startingBalance => (config['starting_balance'] as num?)?.toInt() ?? 1500;
  int get goAmount => (config['go_amount'] as num?)?.toInt() ?? 200;
}
