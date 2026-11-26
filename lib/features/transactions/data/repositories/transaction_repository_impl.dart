import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import '../data_sources/transaction_remote_data_source.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource _remoteDataSource;

  TransactionRepositoryImpl(this._remoteDataSource);

  @override
  Future<LedgerTransaction> transferToPlayer({
    required String sessionId,
    required String toPlayerId,
    required num amount,
    String? memo,
  }) {
    return _remoteDataSource.transferToPlayer(
      sessionId: sessionId,
      toPlayerId: toPlayerId,
      amount: amount,
      memo: memo,
    );
  }

  @override
  Future<LedgerTransaction> payBank({
    required String sessionId,
    required num amount,
    String? memo,
  }) {
    return _remoteDataSource.payBank(
      sessionId: sessionId,
      amount: amount,
      memo: memo,
    );
  }

  @override
  Future<LedgerTransaction> receiveFromBank({
    required String sessionId,
    required num amount,
    String? memo,
  }) {
    return _remoteDataSource.receiveFromBank(
      sessionId: sessionId,
      amount: amount,
      memo: memo,
    );
  }

  @override
  Future<LedgerTransaction> reverseTransaction(String transactionId) {
    return _remoteDataSource.reverseTransaction(transactionId);
  }

  @override
  Future<List<LedgerTransaction>> fetchTransactions(String sessionId) {
    return _remoteDataSource.fetchTransactions(sessionId);
  }

  @override
  Stream<List<LedgerTransaction>> watchTransactions(String sessionId) {
    return _remoteDataSource.watchTransactions(sessionId);
  }
}
