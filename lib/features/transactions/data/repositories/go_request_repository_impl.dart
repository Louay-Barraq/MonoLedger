import '../../domain/entities/go_salary_request.dart';
import '../../domain/repositories/go_request_repository.dart';
import '../data_sources/go_request_remote_data_source.dart';

class GoRequestRepositoryImpl implements GoRequestRepository {
  final GoRequestRemoteDataSource _remote;

  GoRequestRepositoryImpl(this._remote);

  @override
  Future<GoSalaryRequest> requestCollectGo(String sessionId) {
    return _remote.requestCollectGo(sessionId);
  }

  @override
  Future<GoSalaryRequest> resolveCollectGo({
    required String requestId,
    required bool approve,
  }) {
    return _remote.resolveCollectGo(requestId: requestId, approve: approve);
  }

  @override
  Stream<List<GoSalaryRequest>> watchGoRequests(String sessionId) {
    return _remote.watchGoRequests(sessionId);
  }
}
