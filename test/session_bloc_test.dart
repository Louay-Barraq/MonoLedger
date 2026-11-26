import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monoledger/features/home/domain/entities/session.dart';
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
      when(
        () => repository.fetchSessionByJoinCode(any()),
      ).thenAnswer((_) async => null);
    },
    act: (bloc) => bloc.add(const SessionResumeByCodeRequested('ABC123')),
    expect: () => [isA<SessionLoading>(), isA<SessionError>()],
  );

  final session = Session(
    id: 's1',
    status: 'open',
    hostId: 'u1',
    joinCode: 'ABC123',
    createdAt: DateTime(2025, 1, 1),
  );

  blocTest<SessionBloc, SessionState>(
    'a failed kick shows the error and keeps the live session',
    build: () => SessionBloc(repository),
    setUp: () {
      when(
        () => repository.createSession(
          currency: any(named: 'currency'),
          startingBalance: any(named: 'startingBalance'),
          goAmount: any(named: 'goAmount'),
          bankerName: any(named: 'bankerName'),
        ),
      ).thenAnswer((_) async => session);
      when(
        () => repository.watchSession(any()),
      ).thenAnswer((_) => StreamController<Session>().stream);
      when(
        () => repository.kickPlayer(any(), any()),
      ).thenThrow(Exception('player_not_found'));
    },
    act: (bloc) async {
      bloc.add(
        const SessionCreateRequested(
          currency: r'$',
          startingBalance: 1500,
          goAmount: 200,
          bankerName: 'Bank',
        ),
      );
      await Future<void>.delayed(Duration.zero);
      bloc.add(
        const SessionKickRequested(sessionId: 's1', targetPlayerId: 'p2'),
      );
    },
    expect: () => [
      isA<SessionLoading>(),
      SessionSuccess(session),
      const SessionError('That player is no longer in the session.'),
      SessionSuccess(session),
    ],
  );

  test('session watch reconnects after a stream error', () async {
    var calls = 0;
    when(
      () => repository.createSession(
        currency: any(named: 'currency'),
        startingBalance: any(named: 'startingBalance'),
        goAmount: any(named: 'goAmount'),
        bankerName: any(named: 'bankerName'),
      ),
    ).thenAnswer((_) async => session);
    when(() => repository.watchSession('s1')).thenAnswer((_) {
      calls++;
      return calls == 1
          ? Stream<Session>.error(Exception('realtime dropped'))
          : StreamController<Session>().stream;
    });

    final bloc = SessionBloc(
      repository,
      retryDelay: const Duration(milliseconds: 1),
    );
    bloc.add(
      const SessionCreateRequested(
        currency: r'$',
        startingBalance: 1500,
        goAmount: 200,
        bankerName: 'Bank',
      ),
    );
    await Future<void>.delayed(const Duration(milliseconds: 50));
    expect(calls, 2);
    await bloc.close();
  });
}
