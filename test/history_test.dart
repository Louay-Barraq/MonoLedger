import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monoledger/features/history/data/history_remote_data_source.dart';
import 'package:monoledger/features/history/presentation/cubit/history_cubit.dart';

class MockHistoryRemoteDataSource extends Mock
    implements HistoryRemoteDataSource {}

void main() {
  late MockHistoryRemoteDataSource dataSource;

  setUp(() => dataSource = MockHistoryRemoteDataSource());

  const stats = UserStats(
    gamesPlayed: 3,
    wins: 1,
    bankerGames: 2,
    averageFinalBalance: 1200,
  );

  blocTest<HistoryCubit, HistoryState>(
    'loads stats and past games together',
    build: () => HistoryCubit(dataSource),
    setUp: () {
      when(() => dataSource.fetchStats()).thenAnswer((_) async => stats);
      when(() => dataSource.fetchPastGames()).thenAnswer((_) async => const []);
    },
    act: (c) => c.load(),
    expect: () => [const HistoryLoading(), const HistoryLoaded(stats, [])],
  );

  blocTest<HistoryCubit, HistoryState>(
    'shows an error when the server call fails',
    build: () => HistoryCubit(dataSource),
    setUp: () {
      when(() => dataSource.fetchStats()).thenThrow(Exception('offline'));
      when(() => dataSource.fetchPastGames()).thenAnswer((_) async => const []);
    },
    act: (c) => c.load(),
    expect: () => [const HistoryLoading(), const HistoryError()],
  );

  test('session analytics treats empty highlights as missing', () {
    final a = SessionAnalytics.fromJson({
      'total_volume': 2500,
      'go_collections_count': 4,
      'duration_seconds': 5400,
      'biggest_earner': {
        'player_id': 'p1',
        'player_name': 'Pat',
        'amount': 900,
      },
      'biggest_spender': <String, dynamic>{},
      'most_active_trader': {
        'player_id': 'p1',
        'player_name': 'Pat',
        'count': 7,
      },
    });
    expect(a.duration, const Duration(minutes: 90));
    expect(a.biggestEarner, const GameHighlight('Pat', 900));
    expect(a.biggestSpender, isNull);
    expect(a.mostActiveTrader, const GameHighlight('Pat', 7));
  });

  test('past game parses the list_my_ended_sessions row', () {
    final g = PastGame.fromJson({
      'session_id': 's1',
      'session_code': 'ABC123',
      'ended_at': '2026-11-20T20:00:00+00:00',
      'player_name': 'Pat',
      'final_balance': 1750,
      'was_banker': true,
      'rank': 1,
    });
    expect(g.rank, 1);
    expect(g.wasBanker, isTrue);
    expect(g.finalBalance, 1750);
  });
}
