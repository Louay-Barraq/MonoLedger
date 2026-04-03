import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/home/domain/entities/session.dart' as domain;
import 'package:monoledger/features/home/domain/entities/player.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Session;

class GameSettingsPage extends StatelessWidget {
  final domain.Session session;

  const GameSettingsPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isBanker = session.players.any((p) => p.userId == currentUserId && p.isBanker);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'GAME SETTINGS',
          style: GoogleFonts.plusJakartaSans(
            color: AppTheme.primaryColor,
            fontSize: 18,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Session Code Section
            _buildSessionCode(context),
            const SizedBox(height: 32),

            // Fiscal Rules Section
            _sectionHeader('FISCAL RULES', Icons.account_balance_rounded),
            const SizedBox(height: 16),
            _buildFiscalRules(),
            const SizedBox(height: 32),

            // Players Management Section
            _sectionHeader('ACTIVE PLAYERS', Icons.group_rounded),
            const SizedBox(height: 16),
            _buildPlayersList(context, isBanker, currentUserId),
            const SizedBox(height: 48),

            // Game Management Section
            if (isBanker) ...[
              _sectionHeader('GAME MANAGEMENT', Icons.settings_applications_rounded),
              const SizedBox(height: 16),
              _buildGameManagement(context),
            ] else ...[
              _sectionHeader('EXIT', Icons.exit_to_app_rounded),
              const SizedBox(height: 16),
              _buildPlayerExit(context),
            ],
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCode(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'SESSION CODE',
                style: GoogleFonts.spaceMono(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '#${session.joinCode}',
                style: GoogleFonts.spaceMono(
                  color: AppTheme.primaryColor,
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              final code = session.joinCode;
              if (code != null) {
                Clipboard.setData(ClipboardData(text: code));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Code copied to clipboard')),
                );
              }
            },
            icon: const Icon(Icons.content_copy_rounded, color: AppTheme.primaryColor),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.surfaceContainerHigh,
              padding: const EdgeInsets.all(12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.primaryColor, size: 16),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.spaceMono(
            color: Colors.white.withValues(alpha: 0.6),
            fontSize: 12,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
      ],
    );
  }

  Widget _buildFiscalRules() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.5,
      children: [
        _buildRuleCard('Starting Capital', '${session.currency}${session.startingBalance}', Icons.payments_rounded),
        _buildRuleCard('GO Bonus', '${session.currency}${session.goAmount}', Icons.autorenew_rounded),
      ],
    );
  }

  Widget _buildRuleCard(String label, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: AppTheme.primaryColor.withValues(alpha: 0.3), width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(color: Colors.white.withValues(alpha: 0.4), fontSize: 12),
              ),
              Icon(icon, color: AppTheme.primaryColor, size: 14),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.spaceMono(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayersList(BuildContext context, bool isBanker, String? currentUserId) {
    return Column(
      children: session.players.map((player) {
        final isSelf = player.userId == currentUserId;
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isSelf ? AppTheme.surfaceContainerHigh : AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: (player.isBanker ? AppTheme.primaryColor : Colors.white).withValues(alpha: 0.1),
                child: Text(
                  player.name[0].toUpperCase(),
                  style: TextStyle(
                    color: player.isBanker ? AppTheme.primaryColor : Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    if (player.isBanker)
                      Text(
                        'BANKER',
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.primaryColor,
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                  ],
                ),
              ),
              if (isBanker && !isSelf) ...[
                IconButton(
                  onPressed: () => _showTransferBankerDialog(context, player),
                  icon: const Icon(Icons.history_edu_rounded, color: Colors.orangeAccent),
                  tooltip: 'Transfer Banker Role',
                ),
                IconButton(
                  onPressed: () => _showKickDialog(context, player),
                  icon: const Icon(Icons.person_remove_rounded, color: Colors.redAccent),
                  tooltip: 'Kick Player',
                ),
              ],
              if (!isBanker && player.isBanker)
                const Icon(Icons.admin_panel_settings_rounded, color: AppTheme.primaryColor, size: 20),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildGameManagement(BuildContext context) {
    return Column(
      children: [
        _actionButton(
          label: 'LEAVE SESSION',
          icon: Icons.exit_to_app_rounded,
          color: Colors.white,
          onPressed: () => _showLeaveSessionDialog(context),
        ),
        const SizedBox(height: 16),
        _actionButton(
          label: 'END SESSION',
          icon: Icons.cancel_rounded,
          color: AppTheme.errorColor,
          onPressed: () => _showEndGameDialog(context),
        ),
      ],
    );
  }

  Widget _buildPlayerExit(BuildContext context) {
    return Column(
      children: [
        _actionButton(
          label: 'LEAVE SESSION',
          icon: Icons.exit_to_app_rounded,
          color: Colors.white,
          onPressed: () => _showLeaveSessionDialog(context),
        ),
      ],
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: color.withValues(alpha: 0.3)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          backgroundColor: color.withValues(alpha: 0.05),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: color,
                fontWeight: FontWeight.bold,
                fontSize: 14,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTransferBankerDialog(BuildContext context, Player player) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Transfer Banker Role?'),
        content: Text('Are you sure you want to transfer the Banker role to ${player.name}? You will lose Banker privileges.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              context.read<SessionBloc>().add(SessionTransferBankerRequested(
                sessionId: session.id,
                newBankerPlayerId: player.userId,
              ));
              Navigator.pop(ctx);
              Navigator.pop(context); // Close settings page
            },
            child: const Text('TRANSFER', style: TextStyle(color: Colors.orangeAccent)),
          ),
        ],
      ),
    );
  }

  void _showKickDialog(BuildContext context, Player player) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Kick Player?'),
        content: Text('Are you sure you want to remove ${player.name} from the session?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              context.read<SessionBloc>().add(SessionKickRequested(
                sessionId: session.id,
                playerUserId: player.userId,
              ));
              Navigator.pop(ctx);
            },
            child: const Text('KICK', style: TextStyle(color: Colors.redAccent)),
          ),
        ],
      ),
    );
  }

  void _showEndGameDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('End Session?'),
        content: const Text('This will permanently end the game for everyone and move to the summary screen.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              context.read<SessionBloc>().add(SessionEndRequested(session.id));
              Navigator.pop(ctx);
              Navigator.pop(context); // Close settings
            },
            child: const Text('END GAME', style: TextStyle(color: AppTheme.errorColor)),
          ),
        ],
      ),
    );
  }

  void _showLeaveSessionDialog(BuildContext context) {
    final currentUserId = Supabase.instance.client.auth.currentUser?.id;
    final isBanker = session.players.any((p) => p.userId == currentUserId && p.isBanker);
    final hasOthers = session.players.length > 1;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Leave Session?'),
        content: Text(
          isBanker 
            ? (hasOthers 
                ? 'As the Banker, leaving will randomly transfer your role to another player. Continue?' 
                : 'Leaving will end the session as you are the only player. Continue?')
            : 'Are you sure you want to leave this session?'
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          TextButton(
            onPressed: () {
              context.read<SessionBloc>().add(SessionLeaveRequested(session.id));
              Navigator.pop(ctx);
              Navigator.pop(context); // Close settings
              // Dashboard listener will handle navigation to home
            },
            child: const Text('LEAVE', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
