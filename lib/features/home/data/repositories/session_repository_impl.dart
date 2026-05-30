import 'package:monoledger/features/home/domain/entities/session.dart';
import '../data_sources/session_remote_data_source.dart';
import '../../domain/repositories/session_repository.dart';

class SessionRepositoryImpl implements SessionRepository {
  final SessionRemoteDataSource _remoteDataSource;

  SessionRepositoryImpl(this._remoteDataSource);

  @override
  Future<Session> createSession({
    required String currency,
    required int startingBalance,
    required int goAmount,
    required String bankerName,
  }) async {
    return await _remoteDataSource.createSession(
      currency: currency,
      startingBalance: startingBalance,
      goAmount: goAmount,
      bankerName: bankerName,
    );
  }

  @override
  Future<Session> joinSession(String joinCode, String playerName) async {
    return await _remoteDataSource.joinSession(joinCode, playerName);
  }

  @override
  Future<void> leaveSession(String sessionId) async {
    await _remoteDataSource.leaveSession(sessionId);
  }

  @override
  Future<void> endSession(String sessionId) async {
    await _remoteDataSource.endSession(sessionId);
  }

  @override
  Future<void> kickPlayer(String sessionId, String targetPlayerId) async {
    await _remoteDataSource.kickPlayer(sessionId, targetPlayerId);
  }

  @override
  Future<void> transferBankerRole(String sessionId, String newBankerPlayerId) async {
    await _remoteDataSource.transferBankerRole(sessionId, newBankerPlayerId);
  }

  @override
  Stream<Session> watchSession(String sessionId) {
    return _remoteDataSource.watchSession(sessionId);
  }

  @override
  Future<Session?> fetchSessionByJoinCode(String joinCode) {
    return _remoteDataSource.fetchSessionByJoinCode(joinCode);
  }
}
