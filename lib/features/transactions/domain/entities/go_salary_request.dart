import 'package:equatable/equatable.dart';

enum GoRequestStatus { pending, approved, rejected }

class GoSalaryRequest extends Equatable {
  final String id;
  final String sessionId;
  final String requesterPlayerId;
  final double amount;
  final GoRequestStatus status;
  final DateTime createdAt;
  final DateTime? resolvedAt;
  final String? resolvedByPlayerId;

  const GoSalaryRequest({
    required this.id,
    required this.sessionId,
    required this.requesterPlayerId,
    required this.amount,
    required this.status,
    required this.createdAt,
    this.resolvedAt,
    this.resolvedByPlayerId,
  });

  bool get isPending => status == GoRequestStatus.pending;

  @override
  List<Object?> get props => [
        id,
        sessionId,
        requesterPlayerId,
        amount,
        status,
        createdAt,
        resolvedAt,
        resolvedByPlayerId,
      ];
}
