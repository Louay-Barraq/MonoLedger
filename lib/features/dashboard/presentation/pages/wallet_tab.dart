import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/core/widgets/overflow_safe_text.dart';
import 'package:monoledger/core/utils/payment_pad_route.dart';
import 'package:monoledger/features/home/domain/entities/player.dart';
import 'package:monoledger/features/home/domain/entities/session_extensions.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/go_request_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WalletTab extends StatelessWidget {
  final String sessionCode;

  const WalletTab({super.key, required this.sessionCode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is! SessionSuccess) {
          return const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          );
        }

        final session = state.session;
        final currentUserId = Supabase.instance.client.auth.currentUser?.id;
        final activePlayers = session.activePlayers;
        final sortedPlayers = List<Player>.from(activePlayers)
          ..sort((a, b) => b.balance.compareTo(a.balance));

        final currentPlayer = activePlayers.cast<Player?>().firstWhere(
          (p) => p!.userId == currentUserId,
          orElse: () => null,
        );

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BalanceCard(
                balance: currentPlayer?.balance ?? 0.0,
                startingBalance: session.startingBalance,
                currency: session.currency,
              ),
              const SizedBox(height: 24),
              _GoSalaryBanner(
                goAmount: session.goAmount,
                currency: session.currency,
                sessionId: session.id,
                myPlayerId: currentPlayer?.id,
                enabled: currentPlayer != null && session.status == 'open',
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _BankActionCard(
                      label: 'PAY BANK',
                      icon: Icons.account_balance_rounded,
                      onTap: () => context.push(
                        '/payment-pad',
                        extra: PaymentPadRoute.bank(
                          sessionId: session.id,
                          currency: session.currency,
                          isPaying: true,
                        ),
                      ),
                    ),
                  ),
                  // Only the Banker can take money from the bank (enforced server-side too).
                  if (currentPlayer?.isBanker ?? false) ...[
                    const SizedBox(width: 16),
                    Expanded(
                      child: _BankActionCard(
                        label: 'FROM BANK',
                        icon: Icons.payments_rounded,
                        onTap: () => context.push(
                          '/payment-pad',
                          extra: PaymentPadRoute.bank(
                            sessionId: session.id,
                            currency: session.currency,
                            isPaying: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Players',
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  Text(
                    '${activePlayers.length} ACTIVE',
                    style: GoogleFonts.spaceMono(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              if (sortedPlayers.isEmpty)
                Text(
                  'No players in session yet',
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.5),
                  ),
                )
              else
                ...sortedPlayers.asMap().entries.map((entry) {
                  final rank = entry.key + 1;
                  final player = entry.value;
                  final isCurrentUser = player.userId == currentUserId;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _PlayerCard(
                      name: player.name,
                      balance: player.balance,
                      rank: rank,
                      isCurrentUser: isCurrentUser,
                      currency: session.currency,
                      onTap: isCurrentUser
                          ? null
                          : () => context.push(
                              '/payment-pad',
                              extra: PaymentPadRoute.player(
                                sessionId: session.id,
                                currency: session.currency,
                                targetName: player.name,
                                recipientPlayerId: player.id,
                                isPaying: true,
                              ),
                            ),
                    ),
                  );
                }),
              const SizedBox(height: 80),
            ],
          ),
        );
      },
    );
  }
}

class _BalanceCard extends StatelessWidget {
  final num balance;
  final int startingBalance;
  final String currency;

  const _BalanceCard({
    required this.balance,
    required this.startingBalance,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final pctChange = startingBalance > 0
        ? ((balance - startingBalance) / startingBalance * 100).round()
        : 0;
    final isPositive = pctChange >= 0;

    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'CURRENT BALANCE',
            style: GoogleFonts.spaceMono(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 12),
          OverflowSafeText(
            CurrencyFormatter.formatMoney(currency, balance),
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 48,
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppTheme.primaryColor.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isPositive
                      ? Icons.trending_up_rounded
                      : Icons.trending_down_rounded,
                  color: AppTheme.primaryColor,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Text(
                  '${isPositive ? '+' : ''}$pctChange% vs START',
                  style: GoogleFonts.spaceMono(
                    color: AppTheme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GoSalaryBanner extends StatelessWidget {
  final int goAmount;
  final String currency;
  final String sessionId;
  final String? myPlayerId;
  final bool enabled;

  const _GoSalaryBanner({
    required this.goAmount,
    required this.currency,
    required this.sessionId,
    required this.myPlayerId,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GoRequestBloc, GoRequestState>(
      listenWhen: (prev, curr) =>
          curr is GoRequestLoaded && curr.statusMessage != null,
      listener: (context, state) {
        if (state is! GoRequestLoaded || state.statusMessage == null) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.statusMessage!,
              style: GoogleFonts.spaceMono(
                color: state.statusIsError ? Colors.white : Colors.black,
              ),
            ),
            backgroundColor: state.statusIsError
                ? AppTheme.errorColor
                : AppTheme.primaryColor,
          ),
        );
        context.read<GoRequestBloc>().add(const GoRequestStatusCleared());
      },
      builder: (context, goState) {
        final loaded = goState is GoRequestLoaded ? goState : null;
        final hasPending =
            myPlayerId != null &&
            (loaded?.requests.any(
                  (r) => r.requesterPlayerId == myPlayerId && r.isPending,
                ) ??
                false);
        final isBusy = loaded?.actionInProgress ?? false;
        final canTap = enabled && !hasPending && !isBusy;

        return GestureDetector(
          onTap: canTap
              ? () {
                  context.read<GoRequestBloc>().add(
                    GoCollectRequested(sessionId),
                  );
                }
              : null,
          child: Opacity(
            opacity: canTap ? 1 : 0.55,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                color: AppTheme.primaryColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'GO',
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.black,
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            fontStyle: FontStyle.italic,
                            letterSpacing: -1,
                          ),
                        ),
                        Text(
                          hasPending ? 'AWAITING BANKER' : 'COLLECT SALARY',
                          style: GoogleFonts.spaceMono(
                            color: Colors.black.withValues(alpha: 0.6),
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 2,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      RowTrailingValue(
                        maxWidth: 160,
                        text: CurrencyFormatter.formatSignedMoney(
                          currency,
                          goAmount,
                          positive: true,
                        ),
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.black,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 8),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _BankActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _BankActionCard({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 28),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withValues(alpha: 0.06)),
        ),
        child: Column(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppTheme.primaryColor, size: 26),
            ),
            const SizedBox(height: 14),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: Colors.white,
                fontSize: 11,
                fontWeight: FontWeight.w700,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerCard extends StatelessWidget {
  final String name;
  final num balance;
  final int rank;
  final bool isCurrentUser;
  final String currency;
  final VoidCallback? onTap;

  const _PlayerCard({
    required this.name,
    required this.balance,
    required this.rank,
    required this.isCurrentUser,
    required this.currency,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentUser
                ? AppTheme.primaryColor.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                ),
              ),
              child: const Icon(
                Icons.person_rounded,
                color: AppTheme.primaryColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          name,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(
                              alpha: 0.15,
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.4,
                              ),
                            ),
                          ),
                          child: Text(
                            'YOU',
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.primaryColor,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  if (!isCurrentUser)
                    Text(
                      'TAP TO PAY',
                      style: GoogleFonts.spaceMono(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 9,
                        letterSpacing: 1,
                      ),
                    ),
                ],
              ),
            ),
            RowTrailingAmount(
              primary: CurrencyFormatter.formatMoney(currency, balance),
              primaryStyle: GoogleFonts.spaceMono(
                color: rank == 1 ? AppTheme.primaryColor : Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
              secondary: 'RANK #$rank',
              secondaryStyle: GoogleFonts.spaceMono(
                color: Colors.white.withValues(alpha: 0.4),
                fontSize: 9,
                letterSpacing: 1,
              ),
              maxWidth: 120,
            ),
          ],
        ),
      ),
    );
  }
}
