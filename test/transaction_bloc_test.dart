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
    'emits success when paying the bank succeeds',
    build: () {
      when(
        () => repository.payBank(
          sessionId: any(named: 'sessionId'),
          amount: any(named: 'amount'),
        ),
      ).thenAnswer(
        (_) async => LedgerTransaction(
          id: '1',
          sessionId: 's1',
          type: TransactionType.payBank,
          amount: 200,
          createdAt: DateTime(2025, 1, 1),
        ),
      );
      return bloc;
    },
    act: (b) => b.add(
      const BankPaymentSubmitted(sessionId: 's1', amount: 200, isPaying: true),
    ),
    expect: () => [isA<TransactionLoading>(), isA<TransactionSuccess>()],
  );

  blocTest<TransactionBloc, TransactionState>(
    'maps only_banker to a readable error',
    build: () {
      when(
        () => repository.receiveFromBank(
          sessionId: any(named: 'sessionId'),
          amount: any(named: 'amount'),
        ),
      ).thenThrow(Exception('only_banker'));
      return bloc;
    },
    act: (b) => b.add(
      const BankPaymentSubmitted(sessionId: 's1', amount: 200, isPaying: false),
    ),
    expect: () => [
      isA<TransactionLoading>(),
      const TransactionError('Only the Banker can do this.'),
    ],
  );

  blocTest<TransactionBloc, TransactionState>(
    'clears ledger when switching watch to a new session id',
    build: () {
      when(
        () => repository.watchTransactions('session-a'),
      ).thenAnswer((_) => Stream.value(const []));
      when(
        () => repository.watchTransactions('session-b'),
      ).thenAnswer((_) => Stream.value(const []));

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
      when(
        () => repository.watchTransactions(any()),
      ).thenAnswer((_) => const Stream.empty());
      b.add(const TransactionsWatchStarted('session-a'));
      await Future<void>.delayed(Duration.zero);
      b.add(const TransactionsWatchStopped());
    },
    expect: () => [const TransactionListLoaded([]), isA<TransactionInitial>()],
  );

  test('ledger watch keeps data and reconnects after a stream error', () async {
    final tx = LedgerTransaction(
      id: '1',
      sessionId: 's1',
      type: TransactionType.payBank,
      amount: 50,
      createdAt: DateTime(2025, 1, 1),
    );
    var calls = 0;
    when(() => repository.watchTransactions('s1')).thenAnswer((_) {
      calls++;
      return calls == 1
          ? Stream<List<LedgerTransaction>>.error(Exception('realtime dropped'))
          : Stream.value([tx]);
    });

    final b = TransactionBloc(
      repository,
      retryDelay: const Duration(milliseconds: 1),
    );
    final states = <TransactionState>[];
    final sub = b.stream.listen(states.add);
    b.add(const TransactionsWatchStarted('s1'));
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(states, [
      const TransactionListLoaded([]),
      TransactionListLoaded([tx]),
    ]);
    await sub.cancel();
    await b.close();
  });

  blocTest<TransactionBloc, TransactionState>(
    'reversing a transaction reports success and keeps the ledger',
    build: () {
      when(() => repository.reverseTransaction('tx1')).thenAnswer(
        (_) async => LedgerTransaction(
          id: 'tx2',
          sessionId: 's1',
          type: TransactionType.fromBank,
          amount: 50,
          createdAt: DateTime(2025, 1, 1),
          reversesTxId: 'tx1',
        ),
      );
      return bloc;
    },
    act: (b) => b.add(const TransactionReverseRequested('tx1')),
    expect: () => [
      isA<TransactionLoading>(),
      const TransactionSuccess('Transaction reversed'),
      const TransactionListLoaded([]),
    ],
  );

  blocTest<TransactionBloc, TransactionState>(
    'reversing twice shows a readable error',
    build: () {
      when(
        () => repository.reverseTransaction('tx1'),
      ).thenThrow(Exception('already_reversed'));
      return bloc;
    },
    act: (b) => b.add(const TransactionReverseRequested('tx1')),
    expect: () => [
      isA<TransactionLoading>(),
      const TransactionError('This transaction was already reversed.'),
      const TransactionListLoaded([]),
    ],
  );
}
