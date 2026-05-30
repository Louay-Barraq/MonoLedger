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
}
