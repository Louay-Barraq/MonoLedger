import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/transaction_model.dart';

abstract interface class TransactionRemoteDataSource {
  Future<TransactionModel> transferToPlayer({
    required String sessionId,
    required String toPlayerId,
    required num amount,
    String? memo,
  });

  Future<TransactionModel> payBank({
    required String sessionId,
    required num amount,
    String? memo,
  });

  Future<TransactionModel> receiveFromBank({
    required String sessionId,
    required num amount,
    String? memo,
  });

  Future<TransactionModel> collectGoSalary({required String sessionId});

  Future<List<TransactionModel>> fetchTransactions(String sessionId);

  Stream<List<TransactionModel>> watchTransactions(String sessionId);
}

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  final SupabaseClient _client;

  TransactionRemoteDataSourceImpl(this._client);

  TransactionModel _fromRpcRow(Map<String, dynamic> row) {
    return TransactionModel.fromJson(row);
  }

  @override
  Future<TransactionModel> transferToPlayer({
    required String sessionId,
    required String toPlayerId,
    required num amount,
    String? memo,
  }) async {
    try {
      final response = await _client.rpc('transfer_to_player', params: {
        'p_session_id': sessionId,
        'p_to_player_id': toPlayerId,
        'p_amount': amount,
        'p_memo': memo,
      });
      return _fromRpcRow(response as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('transfer_to_player: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<TransactionModel> payBank({
    required String sessionId,
    required num amount,
    String? memo,
  }) async {
    try {
      final response = await _client.rpc('pay_bank', params: {
        'p_session_id': sessionId,
        'p_amount': amount,
        'p_memo': memo,
      });
      return _fromRpcRow(response as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('pay_bank: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<TransactionModel> receiveFromBank({
    required String sessionId,
    required num amount,
    String? memo,
  }) async {
    try {
      final response = await _client.rpc('receive_from_bank', params: {
        'p_session_id': sessionId,
        'p_amount': amount,
        'p_memo': memo,
      });
      return _fromRpcRow(response as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('receive_from_bank: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<TransactionModel> collectGoSalary({required String sessionId}) async {
    try {
      final response = await _client.rpc('collect_go_salary', params: {
        'p_session_id': sessionId,
      });
      return _fromRpcRow(response as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('collect_go_salary: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<List<TransactionModel>> fetchTransactions(String sessionId) async {
    final rows = await _client
        .from('transactions')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((row) => TransactionModel.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<TransactionModel>> watchTransactions(String sessionId) async* {
    yield await fetchTransactions(sessionId);

    await for (final _ in _client
        .from('transactions')
        .stream(primaryKey: ['id'])
        .eq('session_id', sessionId)) {
      yield await fetchTransactions(sessionId);
    }
  }

}
