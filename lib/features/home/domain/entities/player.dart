import 'package:equatable/equatable.dart';

class Player extends Equatable {
  final String id;
  final String sessionId;
  final String userId;
  final String name;
  final double balance;
  final bool isBanker;
  final String status;

  const Player({
    required this.id,
    required this.sessionId,
    required this.userId,
    required this.name,
    required this.balance,
    required this.isBanker,
    this.status = 'ACTIVE',
  });

  @override
  List<Object?> get props => [
    id,
    sessionId,
    userId,
    name,
    balance,
    isBanker,
    status,
  ];
}
