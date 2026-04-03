import 'package:flutter/material.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/dashboard_app_bar.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/dashboard_bottom_nav.dart';
import 'package:monoledger/core/utils/qr_utils.dart';
import 'package:monoledger/features/dashboard/presentation/pages/wallet_tab.dart';
import 'package:monoledger/features/dashboard/presentation/pages/ledger_tab.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Dashboard Page – top-level container
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/dashboard/presentation/pages/end_of_game_summary_page.dart';
import 'package:monoledger/features/home/domain/entities/session.dart' as domain;
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

class DashboardPage extends StatefulWidget {
  final String sessionCode;

  const DashboardPage({super.key, required this.sessionCode});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SessionBloc, SessionState>(
      listener: (context, state) {
        if (state is SessionInitial) {
          // Player left the session
          Navigator.of(context).popUntil((route) => route.isFirst);
        } else if (state is SessionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppTheme.errorColor),
          );
        } else if (state is SessionSuccess) {
          final session = state.session;
          final currentUserId = Supabase.instance.client.auth.currentUser?.id;
          
          // Check if session ended
          if (session.status == 'ended') {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => EndOfGameSummaryPage(session: session)),
            );
          }
          
          // Check if player was kicked
          final isActive = session.players.any((p) => p.userId == currentUserId);
          if (!isActive && session.status != 'ended') {
            Navigator.of(context).popUntil((route) => route.isFirst);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('You have been removed from the session.')),
            );
          }
        }
      },
      child: BlocBuilder<SessionBloc, SessionState>(
        builder: (context, state) {
          final session = state is SessionSuccess ? state.session : null;

          return Scaffold(
            backgroundColor: AppTheme.backgroundColor,
            appBar: DashboardAppBar(
              sessionCode: widget.sessionCode,
              onLeave: () => _showLeaveSessionDialog(context, session),
              onShare: () {
                QrUtils.showQrBottomSheet(context, widget.sessionCode);
              },
            ),
            body: IndexedStack(
              index: _currentIndex,
              children: [
                WalletTab(sessionCode: widget.sessionCode),
                const LedgerTab(),
                // PlayersTab(sessionCode: widget.sessionCode),
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
      Navigator.of(context).popUntil((route) => route.isFirst);
      return;
    }

    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isBanker = session.players.any((p) => p.userId == currentUserId && p.isBanker);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Leave Session?'),
        content: Text(isBanker 
          ? 'You are the Banker. If you leave, the role will be randomly transferred to another player. Are you sure?'
          : 'Are you sure you want to leave this session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              context.read<SessionBloc>().add(SessionLeaveRequested(session.id));
              Navigator.pop(ctx);
            },
            child: const Text('LEAVE', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }
}
