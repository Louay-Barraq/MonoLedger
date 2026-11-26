import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/qr_utils.dart';
import 'package:monoledger/core/widgets/session_removal_dialog.dart';
import 'package:monoledger/features/dashboard/presentation/pages/ledger_tab.dart';
import 'package:monoledger/features/dashboard/presentation/pages/players_tab.dart';
import 'package:monoledger/features/dashboard/presentation/pages/wallet_tab.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/go_approval_banner_host.dart';
import 'package:monoledger/features/transactions/presentation/bloc/go_request_bloc.dart';
import 'package:monoledger/features/home/domain/entities/session.dart'
    as domain;
import 'package:monoledger/features/home/domain/entities/session_extensions.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

class DashboardPage extends StatefulWidget {
  final String sessionCode;

  const DashboardPage({super.key, required this.sessionCode});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;
  bool _initialized = false;
  bool _handlingRemoval = false;
  String? _watchedSessionId;
  String? _watchedGoSessionId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _initialized = true;

    final sessionState = context.read<SessionBloc>().state;
    if (sessionState is! SessionSuccess) {
      context.read<SessionBloc>().add(
        SessionResumeByCodeRequested(widget.sessionCode),
      );
    } else {
      _startSessionWatches(sessionState.session.id);
    }
  }

  void _startSessionWatches(String sessionId) {
    _startTransactionWatch(sessionId);
    _startGoRequestWatch(sessionId);
  }

  void _startTransactionWatch(String sessionId) {
    if (_watchedSessionId == sessionId) return;
    _watchedSessionId = sessionId;
    context.read<TransactionBloc>().add(TransactionsWatchStarted(sessionId));
  }

  void _stopTransactionWatch() {
    _watchedSessionId = null;
    context.read<TransactionBloc>().add(const TransactionsWatchStopped());
  }

  void _startGoRequestWatch(String sessionId) {
    if (_watchedGoSessionId == sessionId) return;
    _watchedGoSessionId = sessionId;
    context.read<GoRequestBloc>().add(GoRequestsWatchStarted(sessionId));
  }

  void _stopGoRequestWatch() {
    _watchedGoSessionId = null;
    context.read<GoRequestBloc>().add(const GoRequestsWatchStopped());
  }

  void _stopAllWatches() {
    _stopTransactionWatch();
    _stopGoRequestWatch();
  }

  Future<void> _handleKicked() async {
    if (_handlingRemoval || !mounted) return;
    _handlingRemoval = true;
    _stopAllWatches();
    await showKickedFromSessionDialog(context);
    if (!mounted) return;
    context.read<SessionBloc>().add(const SessionAcknowledgeRemoval());
    context.go('/home');
    _handlingRemoval = false;
  }

  Future<void> _handleSessionEnded(domain.Session session) async {
    if (!mounted) return;
    _stopAllWatches();
    context.pushReplacement('/end-summary', extra: session);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionKicked) {
          _handleKicked();
        } else if (state is SessionInitial) {
          if (_handlingRemoval) return;
          _stopAllWatches();
          context.go('/home');
        } else if (state is SessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        } else if (state is SessionSuccess) {
          _startSessionWatches(state.session.id);

          final session = state.session;
          if (session.status == 'ended') {
            _handleSessionEnded(session);
          }
        }
      },
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          final session = state is SessionSuccess ? state.session : null;
          final currentUserId = Supabase.instance.client.auth.currentUser?.id;

          if (session != null && !session.isUserActive(currentUserId)) {
            return const Scaffold(
              backgroundColor: AppTheme.backgroundColor,
              body: Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              ),
            );
          }

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: DashboardAppBar(
              sessionCode: widget.sessionCode,
              onLeave: () => _showLeaveSessionDialog(context, session),
              onShare: () {
                QrUtils.showQrBottomSheet(context, widget.sessionCode);
              },
            ),
            body: Stack(
              children: [
                state is SessionLoading
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: AppTheme.primaryColor,
                        ),
                      )
                    : IndexedStack(
                        index: _currentIndex,
                        children: [
                          WalletTab(sessionCode: widget.sessionCode),
                          LedgerTab(key: ValueKey(session?.id ?? 'ledger')),
                          PlayersTab(sessionCode: widget.sessionCode),
                        ],
                      ),
                Positioned(
                  top: 8,
                  left: 16,
                  right: 16,
                  child: const GoApprovalBannerHost(),
                ),
              ],
            ),
            bottomNavigationBar: DashboardBottomNav(
              currentIndex: _currentIndex,
              onTap: (i) => setState(() => _currentIndex = i),
            ),
          );
        },
      ),
    );
  }

  void _showLeaveSessionDialog(BuildContext context, domain.Session? session) {
    if (session == null) {
      context.go('/home');
      return;
    }

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isBanker = session.activePlayers.any(
      (p) => p.userId == currentUserId && p.isBanker,
    );
    final activeCount = session.activePlayers.length;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: Text(AppLocalizations.of(context).leaveTitle),
        content: Text(
          isBanker
              ? (activeCount > 1
                    ? AppLocalizations.of(context).leaveBodyBanker
                    : AppLocalizations.of(context).leaveBodyLast)
              : AppLocalizations.of(context).leaveBody,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(AppLocalizations.of(context).commonCancel),
          ),
          TextButton(
            onPressed: () {
              context.read<SessionBloc>().add(
                SessionLeaveRequested(session.id),
              );
              Navigator.pop(ctx);
            },
            child: Text(
              AppLocalizations.of(context).leaveAction,
              style: const TextStyle(color: Colors.redAccent),
            ),
          ),
        ],
      ),
    );
  }
}
