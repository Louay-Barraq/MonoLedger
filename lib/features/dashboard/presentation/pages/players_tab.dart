import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/core/widgets/overflow_safe_text.dart';
import 'package:monoledger/features/home/domain/entities/player.dart';
import 'package:monoledger/features/home/domain/entities/session_extensions.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';

class PlayersTab extends StatelessWidget {
  final String sessionCode;
  const PlayersTab({super.key, required this.sessionCode});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        if (state is! SessionSuccess) {
          return const Center(child: CircularProgressIndicator(color: AppTheme.primaryColor));
        }

        final session = state.session;
        final currency = session.currency;
        final activePlayers = session.activePlayers;
        final banker = activePlayers.cast<Player?>().firstWhere(
              (p) => p!.isBanker,
              orElse: () => null,
            );

        return SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _BankCard(bankerName: banker?.name ?? 'The Bank'),
              const SizedBox(height: 24),
              Text(
                'PLAYERS',
                style: GoogleFonts.spaceMono(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 16),
              if (activePlayers.isEmpty)
                Text(
                  'No active players',
                  style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.5)),
                )
              else
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: activePlayers.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final player = activePlayers[index];
                    return _PlayerListItem(
                      name: player.name,
                      balance: player.balance.round(),
                      currency: currency,
                      isBanker: player.isBanker,
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }
}

class _BankCard extends StatelessWidget {
  final String bankerName;

  const _BankCard({required this.bankerName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1E2430),
            Color(0xFF14181F),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.account_balance_rounded, color: AppTheme.primaryColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'THE BANK',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Banker: $bankerName',
                  style: GoogleFonts.spaceMono(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 12,
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

class _PlayerListItem extends StatelessWidget {
  final String name;
  final int balance;
  final String currency;
  final bool isBanker;

  const _PlayerListItem({
    required this.name,
    required this.balance,
    required this.currency,
    required this.isBanker,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF14181F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.05),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: GoogleFonts.spaceMono(color: AppTheme.primaryColor, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isBanker)
                  Text(
                    'BANKER',
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.primaryColor,
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
              ],
            ),
          ),
          RowTrailingValue(
            text: CurrencyFormatter.formatMoney(currency, balance),
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
