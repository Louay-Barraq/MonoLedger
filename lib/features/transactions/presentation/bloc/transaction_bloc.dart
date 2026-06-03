import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/transaction.dart';
import '../../domain/repositories/transaction_repository.dart';

// Events
abstract class TransactionEvent extends Equatable {
  const TransactionEvent();
  @override
  List<Object?> get props => [];
}

class TransferSubmitted extends TransactionEvent {
  final String sessionId;
  final String toPlayerId;
  final num amount;
  final String? memo;

  const TransferSubmitted({
    required this.sessionId,
    required this.toPlayerId,
    required this.amount,
    this.memo,
  });

  @override
  List<Object?> get props => [sessionId, toPlayerId, amount, memo];
}

class BankPaymentSubmitted extends TransactionEvent {
  final String sessionId;
  final num amount;
  final bool isPaying;

  const BankPaymentSubmitted({
    required this.sessionId,
    required this.amount,
    required this.isPaying,
  });

  @override
  List<Object?> get props => [sessionId, amount, isPaying];
}

class CollectGoSalaryRequested extends TransactionEvent {
  final String sessionId;
  const CollectGoSalaryRequested({required this.sessionId});
  @override
  List<Object?> get props => [sessionId];
}

class TransactionsWatchStarted extends TransactionEvent {
  final String sessionId;
  const TransactionsWatchStarted(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class TransactionsWatchStopped extends TransactionEvent {
  const TransactionsWatchStopped();
}

class TransactionsUpdated extends TransactionEvent {
  final String sessionId;
  final List<LedgerTransaction> transactions;
  const TransactionsUpdated(this.sessionId, this.transactions);
  @override
  List<Object?> get props => [sessionId, transactions];
}

// States
abstract class TransactionState extends Equatable {
  const TransactionState();
  @override
  List<Object?> get props => [];
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionListLoaded extends TransactionState {
  final List<LedgerTransaction> transactions;
  const TransactionListLoaded(this.transactions);
  @override
  List<Object?> get props => [transactions];
}

class TransactionSuccess extends TransactionState {
  final String message;
  const TransactionSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class TransactionError extends TransactionState {
  final String message;
  const TransactionError(this.message);
  @override
  List<Object?> get props => [message];
}

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository _repository;
  StreamSubscription<List<LedgerTransaction>>? _watchSub;
  String? _activeSessionId;
  List<LedgerTransaction> _cachedTransactions = [];

  TransactionBloc(this._repository) : super(TransactionInitial()) {
    on<TransferSubmitted>(_onTransferSubmitted);
    on<BankPaymentSubmitted>(_onBankPaymentSubmitted);
    on<CollectGoSalaryRequested>(_onCollectGoSalary);
    on<TransactionsWatchStarted>(_onWatchStarted);
    on<TransactionsWatchStopped>(_onWatchStopped);
    on<TransactionsUpdated>(_onTransactionsUpdated);
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    return super.close();
  }

  Future<void> _onWatchStarted(
    TransactionsWatchStarted event,
    Emitter<TransactionState> emit,
  ) async {
    if (_activeSessionId == event.sessionId && _watchSub != null) return;

    await _watchSub?.cancel();
    _watchSub = null;
    _activeSessionId = event.sessionId;
    _cachedTransactions = [];
    emit(const TransactionListLoaded([]));

    _watchSub = _repository.watchTransactions(event.sessionId).listen(
      (txs) => add(TransactionsUpdated(event.sessionId, txs)),
      onError: (_) => add(TransactionsUpdated(event.sessionId, const [])),
    );
  }

  Future<void> _onWatchStopped(
    TransactionsWatchStopped event,
    Emitter<TransactionState> emit,
  ) async {
    await _watchSub?.cancel();
    _watchSub = null;
    _activeSessionId = null;
    _cachedTransactions = [];
    emit(TransactionInitial());
  }

  void _onTransactionsUpdated(
    TransactionsUpdated event,
    Emitter<TransactionState> emit,
  ) {
    if (event.sessionId != _activeSessionId) return;
    _cachedTransactions = event.transactions;
    emit(TransactionListLoaded(_cachedTransactions));
  }

  Future<void> _onTransferSubmitted(
    TransferSubmitted event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      await _repository.transferToPlayer(
        sessionId: event.sessionId,
        toPlayerId: event.toPlayerId,
        amount: event.amount,
        memo: event.memo,
      );
      emit(const TransactionSuccess('Transfer completed'));
      if (_cachedTransactions.isNotEmpty) {
        emit(TransactionListLoaded(_cachedTransactions));
      }
    } catch (e) {
      emit(TransactionError(_mapError(e)));
      if (_cachedTransactions.isNotEmpty) {
        emit(TransactionListLoaded(_cachedTransactions));
      }
    }
  }

  Future<void> _onBankPaymentSubmitted(
    BankPaymentSubmitted event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      if (event.isPaying) {
        await _repository.payBank(sessionId: event.sessionId, amount: event.amount);
        emit(const TransactionSuccess('Paid to the Bank'));
      } else {
        await _repository.receiveFromBank(sessionId: event.sessionId, amount: event.amount);
        emit(const TransactionSuccess('Received from the Bank'));
      }
      if (_cachedTransactions.isNotEmpty) {
        emit(TransactionListLoaded(_cachedTransactions));
      }
    } catch (e) {
      emit(TransactionError(_mapError(e)));
      if (_cachedTransactions.isNotEmpty) {
        emit(TransactionListLoaded(_cachedTransactions));
      }
    }
  }

  Future<void> _onCollectGoSalary(
    CollectGoSalaryRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(TransactionLoading());
    try {
      await _repository.collectGoSalary(sessionId: event.sessionId);
      emit(const TransactionSuccess('GO salary collected'));
      if (_cachedTransactions.isNotEmpty) {
        emit(TransactionListLoaded(_cachedTransactions));
      }
    } catch (e) {
      emit(TransactionError(_mapError(e)));
      if (_cachedTransactions.isNotEmpty) {
        emit(TransactionListLoaded(_cachedTransactions));
      }
    }
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('insufficient_funds')) {
      return 'Insufficient funds for this transfer.';
    }
    if (msg.contains('session_closed')) {
      return 'This session is no longer active.';
    }
    if (msg.contains('not_in_session')) {
      return 'You are not an active member of this session.';
    }
    if (msg.contains('cannot_pay_self')) {
      return 'You cannot pay yourself.';
    }
    if (msg.contains('player_not_found')) {
      return 'Recipient not found in this session.';
    }
    return 'Transaction failed. Please try again.';
  }
}
