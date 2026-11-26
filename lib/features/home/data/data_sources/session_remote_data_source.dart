import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/session_extensions.dart';
import '../models/session_model.dart';

abstract interface class SessionRemoteDataSource {
  Future<SessionModel> createSession({
    required String currency,
    required int startingBalance,
    required int goAmount,
    required String bankerName,
  });
  Future<SessionModel> joinSession(String joinCode, String playerName);
  Future<void> endSession(String sessionId);
  Future<void> kickPlayer(String sessionId, String targetPlayerId);
  Future<void> transferBankerRole(String sessionId, String newBankerPlayerId);
  Future<void> leaveSession(String sessionId);
  Stream<SessionModel> watchSession(String sessionId);
  Future<SessionModel?> fetchSessionByJoinCode(String joinCode);
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SessionRemoteDataSourceImpl(this._supabaseClient);

  @override
  Future<SessionModel> createSession({
    required String currency,
    required int startingBalance,
    required int goAmount,
    required String bankerName,
  }) async {
    try {
      // Server picks a unique code and adds the host as the Banker player.
      final response = await _supabaseClient.rpc(
        'create_session',
        params: {
          'p_config': {
            'currency': currency,
            'starting_balance': startingBalance,
            'go_amount': goAmount,
          },
          'p_banker_name': bankerName,
        },
      );

      return SessionModel.fromJson(response as Map<String, dynamic>);
    } catch (e, stackTrace) {
      debugPrint('Error creating session: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<SessionModel> joinSession(String joinCode, String playerName) async {
    try {
      final response = await _supabaseClient.rpc(
        'join_session_by_code',
        params: {
          'p_session_code': joinCode.trim(),
          'p_player_name': playerName.trim(),
        },
      );

      var session = SessionModel.fromJson(response as Map<String, dynamic>);
      session = await _ensureActiveMembership(session, playerName.trim());
      return session;
    } catch (e, stackTrace) {
      debugPrint('Error joining session: $e\n$stackTrace');
      if (e is PostgrestException) {
        final msg = e.message.toLowerCase();
        if (msg.contains('invalid_session')) {
          throw 'Invalid session code. Please check and try again.';
        }
        if (msg.contains('session_closed')) {
          throw 'This session is no longer active.';
        }
        if (msg.contains('player_kicked')) {
          throw 'You were removed from this session and cannot rejoin.';
        }
      }
      if (e is String) rethrow;
      rethrow;
    }
  }

  /// Re-activates LEFT players after join when the RPC did not upgrade status yet.
  Future<SessionModel> _ensureActiveMembership(
    SessionModel session,
    String playerName,
  ) async {
    final userId = _supabaseClient.auth.currentUser?.id;
    final me = session.playerByUserId(userId);

    if (me == null) return session;

    if (me.status == 'KICKED') {
      throw 'You were removed from this session and cannot rejoin.';
    }

    if (me.status == 'LEFT') {
      final response = await _supabaseClient.rpc(
        'reactivate_left_player',
        params: {'p_session_id': session.id, 'p_player_name': playerName},
      );
      return SessionModel.fromJson(response as Map<String, dynamic>);
    }

    if (me.status != 'ACTIVE') {
      throw 'Unable to rejoin this session.';
    }

    return session;
  }

  @override
  Future<void> endSession(String sessionId) async {
    await _supabaseClient.rpc(
      'end_session',
      params: {'p_session_id': sessionId},
    );
  }

  @override
  Future<void> kickPlayer(String sessionId, String targetPlayerId) async {
    await _supabaseClient.rpc(
      'kick_player',
      params: {'p_session_id': sessionId, 'p_target_player_id': targetPlayerId},
    );
  }

  @override
  Future<void> transferBankerRole(
    String sessionId,
    String newBankerPlayerId,
  ) async {
    await _supabaseClient.rpc(
      'transfer_banker',
      params: {
        'p_session_id': sessionId,
        'p_new_banker_player_id': newBankerPlayerId,
      },
    );
  }

  @override
  Future<void> leaveSession(String sessionId) async {
    await _supabaseClient.rpc(
      'leave_session',
      params: {'p_session_id': sessionId},
    );
  }

  Future<SessionModel> _fetchSessionWithPlayers(String sessionId) async {
    final session = await _supabaseClient
        .from('sessions')
        .select()
        .eq('id', sessionId)
        .single();
    final players = await _supabaseClient
        .from('players')
        .select()
        .eq('session_id', sessionId);
    return SessionModel.fromJson({...session, 'players': players});
  }

  @override
  Future<SessionModel?> fetchSessionByJoinCode(String joinCode) async {
    try {
      final session = await _supabaseClient
          .from('sessions')
          .select()
          .eq('session_code', joinCode.trim().toUpperCase())
          .maybeSingle();
      if (session == null) return null;

      final fullSession = await _fetchSessionWithPlayers(
        session['id'] as String,
      );
      final userId = _supabaseClient.auth.currentUser?.id;
      final me = fullSession.playerByUserId(userId);

      if (me?.status == 'KICKED' || me?.status == 'LEFT') return null;
      if (!fullSession.isUserActive(userId)) return null;

      return fullSession;
    } catch (e, stackTrace) {
      debugPrint('fetchSessionByJoinCode: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Stream<SessionModel> watchSession(String sessionId) async* {
    yield await _fetchSessionWithPlayers(sessionId);

    final controller = StreamController<void>.broadcast();
    final sessionSub = _supabaseClient
        .from('sessions')
        .stream(primaryKey: ['id'])
        .eq('id', sessionId)
        .listen((_) => controller.add(null), onError: controller.addError);
    final playersSub = _supabaseClient
        .from('players')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)
        .listen((_) => controller.add(null), onError: controller.addError);

    try {
      await for (final _ in controller.stream) {
        yield await _fetchSessionWithPlayers(sessionId);
      }
    } finally {
      await sessionSub.cancel();
      await playersSub.cancel();
      await controller.close();
    }
  }
}
