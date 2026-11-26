import 'dart:async';

import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/go_salary_request.dart';
import '../../domain/repositories/go_request_repository.dart';

abstract class GoRequestEvent extends Equatable {
  const GoRequestEvent();
  @override
  List<Object?> get props => [];
}

class GoRequestsWatchStarted extends GoRequestEvent {
  final String sessionId;
  const GoRequestsWatchStarted(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class GoRequestsWatchStopped extends GoRequestEvent {
  const GoRequestsWatchStopped();
}

class GoRequestsUpdated extends GoRequestEvent {
  final String sessionId;
  final List<GoSalaryRequest> requests;
  const GoRequestsUpdated(this.sessionId, this.requests);
  @override
  List<Object?> get props => [sessionId, requests];
}

class GoCollectRequested extends GoRequestEvent {
  final String sessionId;
  const GoCollectRequested(this.sessionId);
  @override
  List<Object?> get props => [sessionId];
}

class GoResolveRequested extends GoRequestEvent {
  final String requestId;
  final bool approve;
  const GoResolveRequested({required this.requestId, required this.approve});
  @override
  List<Object?> get props => [requestId, approve];
}

class GoRequestStatusCleared extends GoRequestEvent {
  const GoRequestStatusCleared();
}

abstract class GoRequestState extends Equatable {
  const GoRequestState();
  @override
  List<Object?> get props => [];
}

class GoRequestInitial extends GoRequestState {}

class GoRequestLoaded extends GoRequestState {
  final List<GoSalaryRequest> requests;
  final bool actionInProgress;
  final String? statusMessage;
  final bool statusIsError;

  const GoRequestLoaded({
    required this.requests,
    this.actionInProgress = false,
    this.statusMessage,
    this.statusIsError = false,
  });

  List<GoSalaryRequest> get pendingRequests =>
      requests.where((r) => r.isPending).toList();

  GoRequestLoaded copyWith({
    List<GoSalaryRequest>? requests,
    bool? actionInProgress,
    String? statusMessage,
    bool? statusIsError,
    bool clearStatus = false,
  }) {
    return GoRequestLoaded(
      requests: requests ?? this.requests,
      actionInProgress: actionInProgress ?? this.actionInProgress,
      statusMessage: clearStatus ? null : (statusMessage ?? this.statusMessage),
      statusIsError: statusIsError ?? this.statusIsError,
    );
  }

  @override
  List<Object?> get props => [
    requests,
    actionInProgress,
    statusMessage,
    statusIsError,
  ];
}

class GoRequestBloc extends Bloc<GoRequestEvent, GoRequestState> {
  final GoRequestRepository _repository;
  StreamSubscription<List<GoSalaryRequest>>? _watchSub;
  String? _activeSessionId;
  List<GoSalaryRequest> _requests = [];
  final Duration retryDelay;

  GoRequestBloc(
    this._repository, {
    this.retryDelay = const Duration(seconds: 2),
  }) : super(GoRequestInitial()) {
    on<GoRequestsWatchStarted>(_onWatchStarted);
    on<GoRequestsWatchStopped>(_onWatchStopped);
    on<GoRequestsUpdated>(_onUpdated);
    on<GoCollectRequested>(_onCollect);
    on<GoResolveRequested>(_onResolve);
    on<GoRequestStatusCleared>(_onStatusCleared);
  }

  @override
  Future<void> close() {
    _watchSub?.cancel();
    return super.close();
  }

  Future<void> _onWatchStarted(
    GoRequestsWatchStarted event,
    Emitter<GoRequestState> emit,
  ) async {
    if (_activeSessionId == event.sessionId && _watchSub != null) return;

    await _watchSub?.cancel();
    _activeSessionId = event.sessionId;
    _requests = [];
    emit(const GoRequestLoaded(requests: []));

    _listen(event.sessionId);
  }

  void _listen(String sessionId) {
    _watchSub = _repository
        .watchGoRequests(sessionId)
        .listen(
          (list) => add(GoRequestsUpdated(sessionId, list)),
          // Keep the last list and reconnect instead of wiping pending requests.
          onError: (_) => _retryWatch(sessionId),
          onDone: () => _retryWatch(sessionId),
          cancelOnError: true,
        );
  }

  void _retryWatch(String sessionId) {
    Future<void>.delayed(retryDelay, () {
      if (isClosed || _activeSessionId != sessionId) return;
      _watchSub?.cancel();
      _listen(sessionId);
    });
  }

  Future<void> _onWatchStopped(
    GoRequestsWatchStopped event,
    Emitter<GoRequestState> emit,
  ) async {
    await _watchSub?.cancel();
    _watchSub = null;
    _activeSessionId = null;
    _requests = [];
    emit(GoRequestInitial());
  }

  void _onUpdated(GoRequestsUpdated event, Emitter<GoRequestState> emit) {
    if (event.sessionId != _activeSessionId) return;
    _requests = event.requests;
    final current = state is GoRequestLoaded ? state as GoRequestLoaded : null;
    emit(
      GoRequestLoaded(
        requests: _requests,
        actionInProgress: current?.actionInProgress ?? false,
        statusMessage: current?.statusMessage,
        statusIsError: current?.statusIsError ?? false,
      ),
    );
  }

  Future<void> _onCollect(
    GoCollectRequested event,
    Emitter<GoRequestState> emit,
  ) async {
    final base = state is GoRequestLoaded
        ? (state as GoRequestLoaded)
        : const GoRequestLoaded(requests: []);
    emit(base.copyWith(actionInProgress: true, clearStatus: true));

    try {
      final result = await _repository.requestCollectGo(event.sessionId);
      if (result.status == GoRequestStatus.approved) {
        emit(
          base.copyWith(
            actionInProgress: false,
            statusMessage: MessageCode.goCollected,
            statusIsError: false,
          ),
        );
      } else {
        emit(
          base.copyWith(
            actionInProgress: false,
            statusMessage: MessageCode.goWaiting,
            statusIsError: false,
          ),
        );
      }
    } catch (e) {
      emit(
        base.copyWith(
          actionInProgress: false,
          statusMessage: _mapError(e),
          statusIsError: true,
        ),
      );
    }
  }

  Future<void> _onResolve(
    GoResolveRequested event,
    Emitter<GoRequestState> emit,
  ) async {
    final base = state is GoRequestLoaded
        ? (state as GoRequestLoaded)
        : const GoRequestLoaded(requests: []);
    emit(base.copyWith(actionInProgress: true, clearStatus: true));

    try {
      await _repository.resolveCollectGo(
        requestId: event.requestId,
        approve: event.approve,
      );
      emit(
        base.copyWith(
          actionInProgress: false,
          statusMessage: event.approve
              ? MessageCode.goApproved
              : MessageCode.goDeclined,
          statusIsError: false,
        ),
      );
    } catch (e) {
      emit(
        base.copyWith(
          actionInProgress: false,
          statusMessage: _mapError(e),
          statusIsError: true,
        ),
      );
    }
  }

  void _onStatusCleared(
    GoRequestStatusCleared event,
    Emitter<GoRequestState> emit,
  ) {
    if (state is! GoRequestLoaded) return;
    emit((state as GoRequestLoaded).copyWith(clearStatus: true));
  }

  String _mapError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('go_request_pending')) {
      return MessageCode.goPending;
    }
    if (msg.contains('only_banker')) {
      return MessageCode.onlyBanker;
    }
    if (msg.contains('session_closed')) {
      return MessageCode.sessionClosed;
    }
    return MessageCode.generic;
  }
}
