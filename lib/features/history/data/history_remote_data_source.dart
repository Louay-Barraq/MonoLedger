import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserStats extends Equatable {
  final int gamesPlayed;
  final int wins;
  final int bankerGames;
  final double averageFinalBalance;

  const UserStats({
    required this.gamesPlayed,
    required this.wins,
    required this.bankerGames,
    required this.averageFinalBalance,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) => UserStats(
    gamesPlayed: (json['games_played'] as num? ?? 0).toInt(),
    wins: (json['wins'] as num? ?? 0).toInt(),
    bankerGames: (json['banker_games'] as num? ?? 0).toInt(),
    averageFinalBalance: (json['average_final_balance'] as num? ?? 0)
        .toDouble(),
  );

  @override
  List<Object?> get props => [
    gamesPlayed,
    wins,
    bankerGames,
    averageFinalBalance,
  ];
}

class PastGame extends Equatable {
  final String sessionId;
  final String sessionCode;
  final DateTime? endedAt;
  final String playerName;
  final double finalBalance;
  final bool wasBanker;
  final int rank;

  const PastGame({
    required this.sessionId,
    required this.sessionCode,
    required this.endedAt,
    required this.playerName,
    required this.finalBalance,
    required this.wasBanker,
    required this.rank,
  });

  factory PastGame.fromJson(Map<String, dynamic> json) => PastGame(
    sessionId: json['session_id'] as String,
    sessionCode: json['session_code'] as String? ?? '',
    endedAt: DateTime.tryParse(json['ended_at'] as String? ?? '')?.toLocal(),
    playerName: json['player_name'] as String? ?? 'Player',
    finalBalance: (json['final_balance'] as num? ?? 0).toDouble(),
    wasBanker: json['was_banker'] as bool? ?? false,
    rank: (json['rank'] as num? ?? 0).toInt(),
  );

  @override
  List<Object?> get props => [
    sessionId,
    sessionCode,
    endedAt,
    playerName,
    finalBalance,
    wasBanker,
    rank,
  ];
}

/// One highlight line from get_session_analytics (player + amount or count).
class GameHighlight extends Equatable {
  final String playerName;
  final num value;

  const GameHighlight(this.playerName, this.value);

  static GameHighlight? fromJson(Object? json, String valueKey) {
    if (json is! Map<String, dynamic> || json['player_name'] == null) {
      return null;
    }
    return GameHighlight(
      json['player_name'] as String,
      json[valueKey] as num? ?? 0,
    );
  }

  @override
  List<Object?> get props => [playerName, value];
}

class SessionAnalytics extends Equatable {
  final double totalVolume;
  final int goCollections;
  final Duration duration;
  final GameHighlight? biggestEarner;
  final GameHighlight? biggestSpender;
  final GameHighlight? mostActiveTrader;

  const SessionAnalytics({
    required this.totalVolume,
    required this.goCollections,
    required this.duration,
    this.biggestEarner,
    this.biggestSpender,
    this.mostActiveTrader,
  });

  factory SessionAnalytics.fromJson(Map<String, dynamic> json) =>
      SessionAnalytics(
        totalVolume: (json['total_volume'] as num? ?? 0).toDouble(),
        goCollections: (json['go_collections_count'] as num? ?? 0).toInt(),
        duration: Duration(
          seconds: (json['duration_seconds'] as num? ?? 0).toInt(),
        ),
        biggestEarner: GameHighlight.fromJson(json['biggest_earner'], 'amount'),
        biggestSpender: GameHighlight.fromJson(
          json['biggest_spender'],
          'amount',
        ),
        mostActiveTrader: GameHighlight.fromJson(
          json['most_active_trader'],
          'count',
        ),
      );

  @override
  List<Object?> get props => [
    totalVolume,
    goCollections,
    duration,
    biggestEarner,
    biggestSpender,
    mostActiveTrader,
  ];
}

/// Reads the history RPCs that already exist on the server.
class HistoryRemoteDataSource {
  final SupabaseClient _client;

  HistoryRemoteDataSource(this._client);

  Future<UserStats> fetchStats() async {
    final response = await _client.rpc('get_user_statistics');
    return UserStats.fromJson(response as Map<String, dynamic>);
  }

  Future<List<PastGame>> fetchPastGames({int limit = 50}) async {
    final response = await _client.rpc(
      'list_my_ended_sessions',
      params: {'p_limit': limit, 'p_offset': 0},
    );
    return (response as List<dynamic>)
        .map((row) => PastGame.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<SessionAnalytics> fetchSessionAnalytics(String sessionId) async {
    final response = await _client.rpc(
      'get_session_analytics',
      params: {'p_session_id': sessionId},
    );
    return SessionAnalytics.fromJson(response as Map<String, dynamic>);
  }
}
