import '../../domain/entities/session.dart';
import 'player_model.dart';

class SessionModel extends Session {
  const SessionModel({
    required super.id,
    required super.status,
    required super.hostId,
    super.joinCode,
    required super.createdAt,
    super.players = const [],
    super.config = const {},
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'],
      status: json['status'],
      hostId: json['host_id'],
      joinCode: json['session_code'],
      createdAt: DateTime.parse(json['created_at']),
      config: json['config'] as Map<String, dynamic>? ?? {},
      players: (json['players'] as List<dynamic>?)
              ?.map((p) => PlayerModel.fromJson(p as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}
