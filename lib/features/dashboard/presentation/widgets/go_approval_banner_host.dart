import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monoledger/core/widgets/go_approval_banner.dart';
import 'package:monoledger/features/home/domain/entities/session_extensions.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/go_request_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

class GoApprovalBannerHost extends StatelessWidget {
  const GoApprovalBannerHost({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, sessionState) {
        if (sessionState is! SessionSuccess) return const SizedBox.shrink();

        final session = sessionState.session;
        final userId = Supabase.instance.client.auth.currentUser?.id;
        final myPlayer = session.playerByUserId(userId);
        final isBanker = myPlayer?.isBanker ?? false;
        if (!isBanker) return const SizedBox.shrink();

        return BlocBuilder<GoRequestBloc, GoRequestState>(
          builder: (context, goState) {
            if (goState is! GoRequestLoaded) return const SizedBox.shrink();

            final pending = goState.pendingRequests
                .where((r) => r.requesterPlayerId != myPlayer?.id)
                .toList();
            if (pending.isEmpty) return const SizedBox.shrink();

            final request = pending.first;
            String playerName = 'Player';
            for (final p in session.activePlayers) {
              if (p.id == request.requesterPlayerId) {
                playerName = p.name;
                break;
              }
            }

            return GoApprovalBanner(
              playerName: playerName,
              currency: session.currency,
              amount: request.amount,
              isLoading: goState.actionInProgress,
              onApprove: () => context.read<GoRequestBloc>().add(
                GoResolveRequested(requestId: request.id, approve: true),
              ),
              onDecline: () => context.read<GoRequestBloc>().add(
                GoResolveRequested(requestId: request.id, approve: false),
              ),
            );
          },
        );
      },
    );
  }
}
