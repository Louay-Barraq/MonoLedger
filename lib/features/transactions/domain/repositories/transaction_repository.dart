import '../entities/transaction.dart';

abstract interface class TransactionRepository {
  Future<LedgerTransaction> transferToPlayer({
    required String sessionId,
    required String toPlayerId,
    required num amount,
    String? memo,
  });

  Future<LedgerTransaction> payBank({
    required String sessionId,
    required num amount,
    String? memo,
  });

  Future<LedgerTransaction> receiveFromBank({
    required String sessionId,
    required num amount,
    String? memo,
  });

  Future<LedgerTransaction> reverseTransaction(String transactionId);

  Future<List<LedgerTransaction>> fetchTransactions(String sessionId);

  Stream<List<LedgerTransaction>> watchTransactions(String sessionId);
}
