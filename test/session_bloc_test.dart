import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monoledger/features/home/domain/repositories/session_repository.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';

class MockSessionRepository extends Mock implements SessionRepository {}

void main() {
  late MockSessionRepository repository;

  setUp(() {
    repository = MockSessionRepository();
  });

  blocTest<SessionBloc, SessionState>(
    'emits error when resume by code finds no session',
    build: () => SessionBloc(repository),
    setUp: () {
      when(() => repository.fetchSessionByJoinCode(any()))
          .thenAnswer((_) async => null);
    },
    act: (bloc) => bloc.add(const SessionResumeByCodeRequested('ABC123')),
    expect: () => [
      isA<SessionLoading>(),
      isA<SessionError>(),
    ],
  );
}
