import '../entities/go_salary_request.dart';

abstract interface class GoRequestRepository {
  Future<GoSalaryRequest> requestCollectGo(String sessionId);
  Future<GoSalaryRequest> resolveCollectGo({
    required String requestId,
    required bool approve,
  });
  Stream<List<GoSalaryRequest>> watchGoRequests(String sessionId);
}
