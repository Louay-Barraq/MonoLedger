import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/go_salary_request_model.dart';

abstract interface class GoRequestRemoteDataSource {
  Future<GoSalaryRequestModel> requestCollectGo(String sessionId);
  Future<GoSalaryRequestModel> resolveCollectGo({
    required String requestId,
    required bool approve,
  });
  Future<List<GoSalaryRequestModel>> fetchGoRequests(String sessionId);
  Stream<List<GoSalaryRequestModel>> watchGoRequests(String sessionId);
}

class GoRequestRemoteDataSourceImpl implements GoRequestRemoteDataSource {
  final SupabaseClient _client;

  GoRequestRemoteDataSourceImpl(this._client);

  @override
  Future<GoSalaryRequestModel> requestCollectGo(String sessionId) async {
    try {
      final response = await _client.rpc(
        'request_collect_go',
        params: {'p_session_id': sessionId},
      );
      return GoSalaryRequestModel.fromJson(response as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('request_collect_go: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<GoSalaryRequestModel> resolveCollectGo({
    required String requestId,
    required bool approve,
  }) async {
    try {
      final response = await _client.rpc(
        'resolve_collect_go',
        params: {'p_request_id': requestId, 'p_approve': approve},
      );
      return GoSalaryRequestModel.fromJson(response as Map<String, dynamic>);
    } catch (e, st) {
      debugPrint('resolve_collect_go: $e\n$st');
      rethrow;
    }
  }

  @override
  Future<List<GoSalaryRequestModel>> fetchGoRequests(String sessionId) async {
    final rows = await _client
        .from('go_salary_requests')
        .select()
        .eq('session_id', sessionId)
        .order('created_at', ascending: false);

    return (rows as List<dynamic>)
        .map((r) => GoSalaryRequestModel.fromJson(r as Map<String, dynamic>))
        .toList();
  }

  @override
  Stream<List<GoSalaryRequestModel>> watchGoRequests(String sessionId) async* {
    yield await fetchGoRequests(sessionId);

    await for (final _
        in _client
            .from('go_salary_requests')
            .stream(primaryKey: ['id'])
            .eq('session_id', sessionId)) {
      yield await fetchGoRequests(sessionId);
    }
  }
}
