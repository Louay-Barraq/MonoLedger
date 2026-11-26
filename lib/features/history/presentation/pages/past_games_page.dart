import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/features/history/data/history_remote_data_source.dart';
import 'package:monoledger/features/history/presentation/cubit/history_cubit.dart';

class PastGamesPage extends StatelessWidget {
  const PastGamesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          AppLocalizations.of(context).historyTitle,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
      ),
      body: BlocBuilder<HistoryCubit, HistoryState>(
        builder: (context, state) => switch (state) {
          HistoryLoading() => const Center(
            child: CircularProgressIndicator(color: AppTheme.primaryColor),
          ),
          HistoryError() => Center(
            child: TextButton(
              onPressed: () => context.read<HistoryCubit>().load(),
              child: Text(AppLocalizations.of(context).historyLoadFailed),
            ),
          ),
          HistoryLoaded(:final stats, :final games) => RefreshIndicator(
            color: AppTheme.primaryColor,
            onRefresh: () => context.read<HistoryCubit>().load(),
            child: ListView(
              padding: const EdgeInsets.all(24),
              children: [
                _StatsRow(stats: stats),
                const SizedBox(height: 32),
                if (games.isEmpty)
                  Text(
                    AppLocalizations.of(context).historyEmpty,
                    style: GoogleFonts.inter(
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  )
                else
                  for (final game in games) _PastGameTile(game: game),
              ],
            ),
          ),
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  final UserStats stats;
  const _StatsRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _stat(
          AppLocalizations.of(context).historyGames,
          '${stats.gamesPlayed}',
        ),
        _stat(AppLocalizations.of(context).historyWins, '${stats.wins}'),
        _stat(
          AppLocalizations.of(context).historyAsBanker,
          '${stats.bankerGames}',
        ),
      ],
    );
  }

  Widget _stat(String label, String value) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.spaceMono(
                color: AppTheme.primaryColor,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PastGameTile extends StatelessWidget {
  final PastGame game;
  const _PastGameTile({required this.game});

  @override
  Widget build(BuildContext context) {
    final date = game.endedAt == null
        ? ''
        : DateFormat.yMMMd(
            AppLocalizations.of(context).localeName,
          ).add_jm().format(game.endedAt!);
    final isWin = game.rank == 1;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: isWin
                ? AppTheme.primaryColor
                : AppTheme.surfaceContainerHigh,
            child: Text(
              '#${game.rank}',
              style: GoogleFonts.spaceMono(
                color: isWin ? Colors.black : Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  game.wasBanker
                      ? AppLocalizations.of(
                          context,
                        ).historyBankerTag(game.playerName)
                      : game.playerName,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '${game.sessionCode}  $date',
                  style: GoogleFonts.spaceMono(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
          Text(
            CurrencyFormatter.formatAmount(game.finalBalance),
            style: GoogleFonts.spaceMono(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
