import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/widgets/overflow_safe_text.dart';
import 'package:monoledger/features/dashboard/presentation/utils/ledger_display.dart';
import 'package:monoledger/features/home/domain/entities/session.dart'
    as domain;
import 'package:monoledger/features/home/domain/entities/session_extensions.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/domain/entities/transaction.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

class LedgerTab extends StatelessWidget {
  const LedgerTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SessionBloc, SessionState>(
      builder: (context, sessionState) {
        final domain.Session? session = sessionState is SessionSuccess
            ? sessionState.session
            : null;

        final userId = Supabase.instance.client.auth.currentUser?.id;
        final isBanker = session?.playerByUserId(userId)?.isBanker ?? false;

        return BlocConsumer<TransactionBloc, TransactionState>(
          listenWhen: (_, curr) =>
              curr is TransactionSuccess || curr is TransactionError,
          listener: (context, state) {
            // The payment pad shows its own result; this covers ledger actions.
            if (ModalRoute.of(context)?.isCurrent != true) return;
            final message = switch (state) {
              TransactionSuccess(:final message) => message,
              TransactionError(:final message) => message,
              _ => null,
            };
            if (message == null) return;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: state is TransactionError
                    ? AppTheme.errorColor
                    : AppTheme.surfaceContainerHigh,
              ),
            );
          },
          buildWhen: (_, curr) =>
              curr is TransactionListLoaded || curr is TransactionInitial,
          builder: (context, txState) {
            final transactions = switch (txState) {
              TransactionListLoaded(:final transactions) => transactions,
              _ => <LedgerTransaction>[],
            };
            final reversedIds = {
              for (final t in transactions)
                if (t.reversesTxId != null) t.reversesTxId!,
            };

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
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppTheme.surfaceContainerHigh,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      transactions.length.toString(),
                                      style: GoogleFonts.spaceMono(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
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
                                onPressed: () => context.push(
                                  '/game-settings',
                                  extra: session,
                                ),
                                icon: const Icon(
                                  Icons.settings_outlined,
                                  color: AppTheme.primaryColor,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppTheme.surfaceContainerHigh,
                                  padding: const EdgeInsets.all(12),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'All session transactions',
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
                if (session == null)
                  const SliverFillRemaining(
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppTheme.primaryColor,
                      ),
                    ),
                  )
                else if (transactions.isEmpty)
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Text(
                        'No transactions yet',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    sliver: SliverList.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, index) {
                        final tx = transactions[index];
                        final item = ledgerDisplayItem(
                          tx: tx,
                          currency: session.currency,
                          players: session.players,
                        );
                        final isReversed = reversedIds.contains(tx.id);
                        final canReverse =
                            isBanker &&
                            session.status == 'open' &&
                            !isReversed &&
                            tx.reversesTxId == null;
                        return Column(
                          children: [
                            if (index > 0) const _LedgerDivider(),
                            _LedgerItem(
                              type: _mapType(item.type),
                              title: item.title,
                              subtitle: item.subtitle,
                              time: item.timeLabel,
                              amount: item.amountLabel,
                              isPositive: item.isPositive,
                              isReversed: isReversed,
                              onLongPress: canReverse
                                  ? () => _confirmReverse(
                                      context,
                                      tx.id,
                                      item.title,
                                      item.amountLabel,
                                    )
                                  : null,
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _confirmReverse(
    BuildContext context,
    String transactionId,
    String title,
    String amount,
  ) async {
    final bloc = context.read<TransactionBloc>();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Reverse transaction?'),
        content: Text(
          '$title ($amount) will be undone with an opposite entry in the ledger. '
          'This can only be done once.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text(
              'REVERSE',
              style: TextStyle(color: AppTheme.errorColor),
            ),
          ),
        ],
      ),
    );
    if (confirmed == true) bloc.add(TransactionReverseRequested(transactionId));
  }

  _TxType _mapType(TransactionType type) {
    switch (type) {
      case TransactionType.fromBank:
      case TransactionType.collectGo:
        return _TxType.fromBank;
      case TransactionType.payBank:
        return _TxType.toBank;
      case TransactionType.playerToPlayer:
        return _TxType.playerToPlayer;
    }
  }
}

enum _TxType { fromBank, toBank, playerToPlayer }

class _LedgerDivider extends StatelessWidget {
  const _LedgerDivider();

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
  final bool isReversed;
  final VoidCallback? onLongPress;

  const _LedgerItem({
    required this.type,
    required this.title,
    required this.subtitle,
    required this.time,
    required this.amount,
    required this.isPositive,
    this.isReversed = false,
    this.onLongPress,
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
      decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onLongPress: onLongPress,
      child: Opacity(opacity: isReversed ? 0.45 : 1, child: _buildRow()),
    );
  }

  Widget _buildRow() {
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
                  isReversed ? '$subtitle • REVERSED' : subtitle,
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
          RowTrailingValue(
            maxWidth: 112,
            text: amount,
            style: GoogleFonts.spaceMono(
              color: isPositive
                  ? AppTheme.primaryColor
                  : const Color(0xFFFF5252),
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
