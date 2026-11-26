import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monoledger/features/history/data/history_remote_data_source.dart';

sealed class HistoryState extends Equatable {
  const HistoryState();
  @override
  List<Object?> get props => [];
}

class HistoryLoading extends HistoryState {
  const HistoryLoading();
}

class HistoryLoaded extends HistoryState {
  final UserStats stats;
  final List<PastGame> games;
  const HistoryLoaded(this.stats, this.games);
  @override
  List<Object?> get props => [stats, games];
}

class HistoryError extends HistoryState {
  const HistoryError();
}

class HistoryCubit extends Cubit<HistoryState> {
  final HistoryRemoteDataSource _dataSource;

  HistoryCubit(this._dataSource) : super(const HistoryLoading());

  Future<void> load() async {
    emit(const HistoryLoading());
    try {
      final results = await Future.wait([
        _dataSource.fetchStats(),
        _dataSource.fetchPastGames(),
      ]);
      emit(
        HistoryLoaded(results[0] as UserStats, results[1] as List<PastGame>),
      );
    } catch (_) {
      emit(const HistoryError());
    }
  }
}
