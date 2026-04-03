import '../entities/session.dart';

abstract interface class SessionRepository {
  Future<Session> createSession({
    required String currency,
    required int startingBalance,
    required int goAmount,
    required String bankerName,
  });
  Future<Session> joinSession(String joinCode, String playerName);
  Future<void> leaveSession(String sessionId);
  Future<void> endSession(String sessionId);
  Future<void> kickPlayer(String sessionId, String playerUserId);
  Future<void> transferBankerRole(String sessionId, String newBankerPlayerId);
  Stream<Session> watchSession(String sessionId);
}
