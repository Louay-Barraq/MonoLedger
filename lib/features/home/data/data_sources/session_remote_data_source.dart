import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  Future<void> kickPlayer(String sessionId, String playerUserId);
  Future<void> transferBankerRole(String sessionId, String newBankerPlayerId);
  Future<void> leaveSession(String sessionId);
  Stream<SessionModel> watchSession(String sessionId);
}

class SessionRemoteDataSourceImpl implements SessionRemoteDataSource {
  final SupabaseClient _supabaseClient;

  SessionRemoteDataSourceImpl(this._supabaseClient);

  String _generateSessionCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        6, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  @override
  Future<SessionModel> createSession({
    required String currency,
    required int startingBalance,
    required int goAmount,
    required String bankerName,
  }) async {
    try {
      final sessionCode = _generateSessionCode();
      final response = await _supabaseClient.from('sessions').insert({
        'session_code': sessionCode,
        'host_id': _supabaseClient.auth.currentUser!.id,
        'status': 'open',
        'config': {
          'currency': currency,
          'starting_balance': startingBalance,
          'go_amount': goAmount,
          'banker_name': bankerName,
        },
      }).select().single();

      return SessionModel.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('Error creating session: $e\n$stackTrace');
      rethrow;
    }
  }

  @override
  Future<SessionModel> joinSession(String joinCode, String playerName) async {
    try {
      final response = await _supabaseClient.rpc('join_session_by_code', params: {
        'p_session_code': joinCode,
        'p_player_name': playerName,
      });

      return SessionModel.fromJson(response as Map<String, dynamic>);
    } catch (e, stackTrace) {
      debugPrint('Error joining session: $e\n$stackTrace');
      if (e is PostgrestException && e.message == 'invalid_session') {
        throw 'Invalid session code. Please check and try again.';
      }
      rethrow;
    }
  }

  @override
  Future<void> endSession(String sessionId) async {
    await _supabaseClient
        .from('sessions')
        .update({'status': 'ended'})
        .eq('id', sessionId);
  }

  @override
  Future<void> kickPlayer(String sessionId, String playerUserId) async {
    await _supabaseClient.rpc('kick_player', params: {
      'p_session_id': sessionId,
      'p_target_player_id': playerUserId,
    });
  }

  @override
  Future<void> transferBankerRole(String sessionId, String newBankerPlayerId) async {
    await _supabaseClient.rpc('transfer_banker', params: {
      'p_session_id': sessionId,
      'p_new_banker_player_id': newBankerPlayerId,
    });
  }

  @override
  Future<void> leaveSession(String sessionId) async {
    await _supabaseClient.rpc('leave_session', params: {
      'p_session_id': sessionId,
    });
  }

  @override
  Stream<SessionModel> watchSession(String sessionId) {
    return _supabaseClient
        .from('sessions')
        .stream(primaryKey: ['id'])
        .eq('id', sessionId)
        .map((data) => SessionModel.fromJson(data.first));
  }
}
