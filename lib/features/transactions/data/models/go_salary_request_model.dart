import '../../domain/entities/go_salary_request.dart';

class GoSalaryRequestModel extends GoSalaryRequest {
  const GoSalaryRequestModel({
    required super.id,
    required super.sessionId,
    required super.requesterPlayerId,
    required super.amount,
    required super.status,
    required super.createdAt,
    super.resolvedAt,
    super.resolvedByPlayerId,
  });

  factory GoSalaryRequestModel.fromJson(Map<String, dynamic> json) {
    return GoSalaryRequestModel(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      requesterPlayerId: json['requester_player_id'] as String,
      amount: (json['amount'] as num).toDouble(),
      status: _parseStatus(json['status'] as String?),
      createdAt: DateTime.parse(json['created_at'] as String),
      resolvedAt: json['resolved_at'] != null
          ? DateTime.parse(json['resolved_at'] as String)
          : null,
      resolvedByPlayerId: json['resolved_by_player_id'] as String?,
    );
  }

  static GoRequestStatus _parseStatus(String? raw) {
    switch (raw?.toLowerCase()) {
      case 'approved':
        return GoRequestStatus.approved;
      case 'rejected':
        return GoRequestStatus.rejected;
      default:
        return GoRequestStatus.pending;
    }
  }
}
