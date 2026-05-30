import 'player.dart';
import 'session.dart';

extension SessionPlayersX on Session {
  /// Players still in the game (can receive payments, appear in lists).
  List<Player> get activePlayers =>
      players.where((p) => p.status == 'ACTIVE').toList();

  Player? playerByUserId(String? userId) {
    if (userId == null) return null;
    for (final player in players) {
      if (player.userId == userId) return player;
    }
    return null;
  }

  bool isUserActive(String? userId) {
    final player = playerByUserId(userId);
    return player != null && player.status == 'ACTIVE';
  }
}
