import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/dashboard/presentation/pages/game_settings_page.dart';
import 'package:monoledger/features/home/domain/entities/session.dart' as domain;

// ─────────────────────────────────────────────────────────────────────────────
// Ledger Tab
// ─────────────────────────────────────────────────────────────────────────────

class LedgerTab extends StatelessWidget {
  const LedgerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, state) {
        final domain.Session? session = state is SessionSuccess ? state.session : null;

        return CustomScrollView(
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Ledger',
                              style: GoogleFonts.plusJakartaSans(
                                color: Colors.white,
                                fontSize: 36,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 6),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppTheme.surfaceContainerHigh,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  session?.players.length.toString() ?? '...',
                                  style: GoogleFonts.spaceMono(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (session != null)
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) => GameSettingsPage(session: session),
                                ),
                              );
                            },
                            icon: const Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
                            style: IconButton.styleFrom(
                              backgroundColor: AppTheme.surfaceContainerHigh,
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'All session transactions — visible to everyone',
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 14,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 28),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _LedgerItem(
                    type: _TxType.fromBank,
                    title: 'From The Bank',
                    subtitle: 'PASSED GO • ALEX',
                    time: '3m ago',
                    amount: '+\$200',
                    isPositive: true,
                  ),
                  _LedgerDivider(),
                  _LedgerItem(
                    type: _TxType.playerToPlayer,
                    title: 'Sarah → Chris',
                    subtitle: 'RENT (BROADWALK) • SARAH',
                    time: '8m ago',
                    amount: '-\$50',
                    isPositive: false,
                  ),
                  _LedgerDivider(),
                  _LedgerItem(
                    type: _TxType.fromBank,
                    title: 'From The Bank',
                    subtitle: 'UTILITY BONUS • CHRIS',
                    time: '15m ago',
                    amount: '+\$150',
                    isPositive: true,
                  ),
                  _LedgerDivider(),
                  _LedgerItem(
                    type: _TxType.playerToPlayer,
                    title: 'Alex → Sarah',
                    subtitle: 'PROPERTY TRADE • ALEX',
                    time: '34m ago',
                    amount: '-\$2,500',
                    isPositive: false,
                  ),
                  _LedgerDivider(),
                  _LedgerItem(
                    type: _TxType.toBank,
                    title: 'To The Bank',
                    subtitle: 'INCOME TAX • CHRIS',
                    time: '1h ago',
                    amount: '-\$200',
                    isPositive: false,
                  ),
                  _LedgerDivider(),
                  _LedgerItem(
                    type: _TxType.fromBank,
                    title: 'From The Bank',
                    subtitle: 'PASSED GO • SARAH',
                    time: '2h ago',
                    amount: '+\$200',
                    isPositive: true,
                  ),
                  const SizedBox(height: 80),
                ]),
              ),
            ),
          ],
        );
      },
    );
  }
}

enum _TxType { fromBank, toBank, playerToPlayer }

class _LedgerDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      color: Colors.white.withValues(alpha: 0.07),
      height: 1,
      thickness: 1,
    );
  }
}

class _LedgerItem extends StatelessWidget {
  final _TxType type;
  final String title;
  final String subtitle;
  final String time;
  final String amount;
  final bool isPositive;

  const _LedgerItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.isPositive,
  });

  Widget _buildIcon() {
    final Color bg;
    final Color iconColor;
    final IconData icon;

    switch (type) {
      case _TxType.fromBank:
        bg = const Color(0xFF0D2E1E);
        iconColor = AppTheme.primaryColor;
        icon = Icons.arrow_back_rounded;
        break;
      case _TxType.toBank:
        bg = const Color(0xFF2E0D0D);
        iconColor = const Color(0xFFFF5252);
        icon = Icons.arrow_forward_rounded;
        break;
      case _TxType.playerToPlayer:
        bg = const Color(0xFF2E1A0D);
        iconColor = const Color(0xFFFF8C42);
        icon = Icons.swap_horiz_rounded;
        break;
    }

    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Row(
        children: [
          _buildIcon(),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: GoogleFonts.spaceMono(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 10,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: GoogleFonts.inter(
                    color: Colors.white.withValues(alpha: 0.3),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: GoogleFonts.spaceMono(
              color: isPositive ? AppTheme.primaryColor : const Color(0xFFFF5252),
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}
