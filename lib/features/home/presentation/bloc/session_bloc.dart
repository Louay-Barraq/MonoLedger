import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;
import '../../domain/entities/session.dart';
import '../../domain/entities/session_extensions.dart';
import '../../domain/repositories/session_repository.dart';

// Events
abstract class SessionEvent extends Equatable {
  const SessionEvent();
  @override
  List<Object?> get props => [];
}

class SessionUpdateReceived extends SessionEvent {
  final Session session;
  const SessionUpdateReceived(this.session);
  @override
  List<Object?> get props => [session];
}

class SessionCreateRequested extends SessionEvent {
  final String currency;
  final int startingBalance;
  final int goAmount;
  final String bankerName;

  const SessionCreateRequested({
    required this.currency,
    required this.startingBalance,
    required this.goAmount,
    required this.bankerName,
  });

  @override
  List<Object?> get props => [currency, startingBalance, goAmount, bankerName];
}

class SessionJoinRequested extends SessionEvent {
  final String joinCode;
  final String playerName;
  const SessionJoinRequested({
    required this.joinCode,
    required this.playerName,
  });
  @override
  List<Object> get props => [joinCode, playerName];
}

class SessionEndRequested extends SessionEvent {
  final String sessionId;
  const SessionEndRequested(this.sessionId);
  @override
  List<Object> get props => [sessionId];
}

class SessionKickRequested extends SessionEvent {
  final String sessionId;
  final String targetPlayerId;
  const SessionKickRequested({
    required this.sessionId,
    required this.targetPlayerId,
  });
  @override
  List<Object> get props => [sessionId, targetPlayerId];
}

class SessionTransferBankerRequested extends SessionEvent {
  final String sessionId;
  final String newBankerPlayerId;
  const SessionTransferBankerRequested({
    required this.sessionId,
    required this.newBankerPlayerId,
  });
  @override
  List<Object> get props => [sessionId, newBankerPlayerId];
}

class SessionLeaveRequested extends SessionEvent {
  final String sessionId;
  const SessionLeaveRequested(this.sessionId);
  @override
  List<Object> get props => [sessionId];
}

class SessionResumeByCodeRequested extends SessionEvent {
  final String joinCode;
  const SessionResumeByCodeRequested(this.joinCode);
  @override
  List<Object> get props => [joinCode];
}

// States
abstract class SessionState extends Equatable {
  const SessionState();
  @override
  List<Object> get props => [];
}

class SessionInitial extends SessionState {}

class SessionLoading extends SessionState {}

class SessionSuccess extends SessionState {
  final Session session;
  const SessionSuccess(this.session);
  @override
  List<Object> get props => [session];
}

class SessionError extends SessionState {
  final String message;
  const SessionError(this.message);
  @override
  List<Object> get props => [message];
}

/// Current user was removed by the Banker (kick).
class SessionKicked extends SessionState {
  const SessionKicked();
}

class SessionAcknowledgeRemoval extends SessionEvent {
  const SessionAcknowledgeRemoval();
}

// BLoC
class SessionBloc extends Bloc<SessionEvent, SessionState> {
  final SessionRepository _repository;
  StreamSubscription? _sessionSubscription;
  String? _watchedSessionId;
  bool _voluntaryLeaveInProgress = false;
  final Duration retryDelay;

  SessionBloc(this._repository, {this.retryDelay = const Duration(seconds: 2)})
    : super(SessionInitial()) {
    on<SessionCreateRequested>(_onCreateRequested);
    on<SessionJoinRequested>(_onJoinRequested);
    on<SessionEndRequested>(_onEndRequested);
    on<SessionKickRequested>(_onKickRequested);
    on<SessionTransferBankerRequested>(_onTransferBankerRequested);
    on<SessionLeaveRequested>(_onLeaveRequested);
    on<SessionUpdateReceived>(_onUpdateReceived);
    on<SessionResumeByCodeRequested>(_onResumeByCodeRequested);
    on<SessionAcknowledgeRemoval>((_, emit) => emit(SessionInitial()));
  }

  @override
  Future<void> close() {
    _sessionSubscription?.cancel();
    return super.close();
  }

  void _startWatching(String sessionId) {
    _sessionSubscription?.cancel();
    _watchedSessionId = sessionId;
    _sessionSubscription = _repository
        .watchSession(sessionId)
        .listen(
          (session) => add(SessionUpdateReceived(session)),
          // A dropped connection or failed refetch must not freeze balances.
          onError: (_) => _retryWatch(sessionId),
          onDone: () => _retryWatch(sessionId),
          cancelOnError: true,
        );
  }

  void _retryWatch(String sessionId) {
    Future<void>.delayed(retryDelay, () {
      if (isClosed || _watchedSessionId != sessionId) return;
      _startWatching(sessionId);
    });
  }

  Future<void> _stopWatching() async {
    _watchedSessionId = null;
    await _sessionSubscription?.cancel();
    _sessionSubscription = null;
  }

  /// Shows [message] but keeps the live session on screen.
  void _emitActionError(String message, Emitter<SessionState> emit) {
    final previous = state;
    emit(SessionError(message));
    if (previous is SessionSuccess) emit(previous);
  }

  Future<void> _onCreateRequested(
    SessionCreateRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final session = await _repository.createSession(
        currency: event.currency,
        startingBalance: event.startingBalance,
        goAmount: event.goAmount,
        bankerName: event.bankerName,
      );
      _startWatching(session.id);
      emit(SessionSuccess(session));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }

  Future<void> _onJoinRequested(
    SessionJoinRequested event,
    Emitter<SessionState> emit,
  ) async {
    emit(SessionLoading());
    try {
      final session = await _repository.joinSession(
        event.joinCode,
        event.playerName,
      );
      _startWatching(session.id);
      emit(SessionSuccess(session));
    } catch (e) {
      String errorMessage = 'Failed to join session. Please try again.';
      final errorStr = e.toString().toLowerCase();

      if (errorStr.contains('invalid_session') ||
          errorStr.contains('not found') ||
          errorStr.contains('no rows')) {
        errorMessage = 'Invalid session code. Please check and try again.';
      } else if (errorStr.contains('session_closed')) {
        errorMessage = 'This session is no longer active.';
      } else if (errorStr.contains('player_kicked') ||
          errorStr.contains('removed from this session')) {
        errorMessage = 'You were removed from this session and cannot rejoin.';
      } else if (errorStr.contains('socket') ||
          errorStr.contains('network') ||
          errorStr.contains('connection')) {
        errorMessage = 'Network error. Please check your connection.';
      }

      emit(SessionError(errorMessage));
    }
  }

  void _onUpdateReceived(
    SessionUpdateReceived event,
    Emitter<SessionState> emit,
  ) {
    if (_voluntaryLeaveInProgress) return;

    final session = event.session;
    final userId = Supabase.instance.client.auth.currentUser?.id;
    final myPlayer = session.playerByUserId(userId);

    if (myPlayer?.status == 'KICKED') {
      _stopWatching();
      emit(const SessionKicked());
      return;
    }

    if (!session.isUserActive(userId)) {
      _stopWatching();
      emit(SessionInitial());
      return;
    }

    emit(SessionSuccess(session));
  }

  Future<void> _onEndRequested(
    SessionEndRequested event,
    Emitter<SessionState> emit,
  ) async {
    try {
      await _repository.endSession(event.sessionId);
    } catch (e) {
      _emitActionError(_mapSessionError(e), emit);
    }
  }

  Future<void> _onKickRequested(
    SessionKickRequested event,
    Emitter<SessionState> emit,
  ) async {
    try {
      await _repository.kickPlayer(event.sessionId, event.targetPlayerId);
    } catch (e) {
      _emitActionError(_mapSessionError(e), emit);
    }
  }

  Future<void> _onTransferBankerRequested(
    SessionTransferBankerRequested event,
    Emitter<SessionState> emit,
  ) async {
    try {
      await _repository.transferBankerRole(
        event.sessionId,
        event.newBankerPlayerId,
      );
    } catch (e) {
      _emitActionError(_mapSessionError(e), emit);
    }
  }

  Future<void> _onLeaveRequested(
    SessionLeaveRequested event,
    Emitter<SessionState> emit,
  ) async {
    _voluntaryLeaveInProgress = true;
    try {
      await _repository.leaveSession(event.sessionId);
      await _stopWatching();
      emit(SessionInitial());
    } catch (e) {
      _emitActionError(_mapSessionError(e), emit);
    } finally {
      _voluntaryLeaveInProgress = false;
    }
  }

  String _mapSessionError(Object e) {
    final msg = e.toString().toLowerCase();
    if (msg.contains('only_banker') || msg.contains('only the banker')) {
      return 'Only the Banker can perform this action.';
    }
    if (msg.contains('player_not_found')) {
      return 'That player is no longer in the session.';
    }
    return 'Session action failed. Please try again.';
  }

  Future<void> _onResumeByCodeRequested(
    SessionResumeByCodeRequested event,
    Emitter<SessionState> emit,
  ) async {
    if (state is SessionSuccess) {
      final current = (state as SessionSuccess).session;
      if (current.joinCode?.toUpperCase() ==
          event.joinCode.trim().toUpperCase()) {
        return;
      }
      await _stopWatching();
    }
    emit(SessionLoading());
    try {
      final session = await _repository.fetchSessionByJoinCode(event.joinCode);
      if (session == null) {
        emit(
          const SessionError(
            'Session not found. Join again from the home screen.',
          ),
        );
        return;
      }
      _startWatching(session.id);
      emit(SessionSuccess(session));
    } catch (e) {
      emit(SessionError(e.toString()));
    }
  }
}
