import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monoledger/features/transactions/domain/entities/transaction.dart';
import 'package:monoledger/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';

class MockTransactionRepository extends Mock implements TransactionRepository {}

void main() {
  late MockTransactionRepository repository;
  late TransactionBloc bloc;

  setUp(() {
    repository = MockTransactionRepository();
    bloc = TransactionBloc(repository);
  });

  tearDown(() => bloc.close());

  blocTest<TransactionBloc, TransactionState>(
    'emits success when collect go salary succeeds',
    build: () {
      when(() => repository.collectGoSalary(sessionId: any(named: 'sessionId')))
          .thenAnswer((_) async => LedgerTransaction(
                id: '1',
                sessionId: 's1',
                type: TransactionType.collectGo,
                amount: 200,
                createdAt: DateTime(2025, 1, 1),
              ));
      return bloc;
    },
    act: (b) => b.add(const CollectGoSalaryRequested(sessionId: 's1')),
    expect: () => [
      isA<TransactionLoading>(),
      isA<TransactionSuccess>(),
    ],
  );

  blocTest<TransactionBloc, TransactionState>(
    'clears ledger when switching watch to a new session id',
    build: () {
      when(() => repository.watchTransactions('session-a'))
          .thenAnswer((_) => Stream.value(const []));
      when(() => repository.watchTransactions('session-b'))
          .thenAnswer((_) => Stream.value(const []));

      return bloc;
    },
    act: (b) async {
      b.add(const TransactionsWatchStarted('session-a'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
      b.add(const TransactionsWatchStarted('session-b'));
      await Future<void>.delayed(const Duration(milliseconds: 20));
    },
    expect: () => [const TransactionListLoaded([])],
    verify: (b) {
      expect(b.state, isA<TransactionListLoaded>());
    },
  );

  blocTest<TransactionBloc, TransactionState>(
    'TransactionsWatchStopped resets to initial',
    build: () => bloc,
    act: (b) async {
      when(() => repository.watchTransactions(any()))
          .thenAnswer((_) => const Stream.empty());
      b.add(const TransactionsWatchStarted('session-a'));
      await Future<void>.delayed(Duration.zero);
      b.add(const TransactionsWatchStopped());
    },
    expect: () => [
      const TransactionListLoaded([]),
      isA<TransactionInitial>(),
    ],
  );
}
