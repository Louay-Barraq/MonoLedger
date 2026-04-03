import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/home/domain/entities/session.dart';
import 'package:monoledger/features/home/domain/entities/player.dart';

class EndOfGameSummaryPage extends StatelessWidget {
  final Session session;

  const EndOfGameSummaryPage({super.key, required this.session});

  @override
  Widget build(BuildContext context) {
    final sortedPlayers = List<Player>.from(session.players)
      ..sort((a, b) => b.balance.compareTo(a.balance));
    
    final winner = sortedPlayers.isNotEmpty ? sortedPlayers.first : null;

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Background Glow for Winner
          Positioned(
            top: -100,
            left: MediaQuery.of(context).size.width / 2 - 150,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                color: Colors.amber.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.2),
                    blurRadius: 100,
                    spreadRadius: 50,
                  ),
                ],
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 20),
                        if (winner != null) _buildWinnerCard(winner),
                        const SizedBox(height: 40),
                        _sectionTitle('SESSION ANALYTICS'),
                        const SizedBox(height: 16),
                        _buildAnalyticsGrid(sortedPlayers),
                        const SizedBox(height: 40),
                        _sectionTitle('FINAL STANDINGS'),
                        const SizedBox(height: 16),
                        _buildRankings(sortedPlayers),
                        const SizedBox(height: 120),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Fixed Bottom Button
          Positioned(
            bottom: 32,
            left: 24,
            right: 24,
            child: _buildExitButton(context),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.settings_outlined, color: AppTheme.primaryColor),
          Text(
            'ML-${session.joinCode}',
            style: GoogleFonts.plusJakartaSans(
              color: AppTheme.primaryColor,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const Icon(Icons.logout_rounded, color: AppTheme.primaryColor),
        ],
      ),
    );
  }

  Widget _buildWinnerCard(Player winner) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.4),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.amber.withValues(alpha: 0.1),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.amber.withValues(alpha: 0.2)),
            ),
            child: const Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 48),
          ),
          const SizedBox(height: 16),
          Text(
            'GRAND CHAMPION',
            style: GoogleFonts.spaceMono(
              color: Colors.amber,
              fontSize: 12,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            winner.name.toUpperCase(),
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w900,
              letterSpacing: -1,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
            ),
            child: Text(
              '${session.currency}${winner.balance.toStringAsFixed(0)}',
              style: GoogleFonts.spaceMono(
                color: AppTheme.primaryColor,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.spaceMono(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 10,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }

  Widget _buildAnalyticsGrid(List<Player> players) {
    // Basic calcs
    final totalMoney = players.fold<double>(0, (sum, p) => sum + p.balance);
    
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            'Total Volume',
            '${session.currency}${totalMoney.toStringAsFixed(0)}',
            Icons.payments_rounded,
            const Color(0xFF44A5FF),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildStatCard(
            'Participants',
            '${players.length} Players',
            Icons.group_rounded,
            Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      height: 120,
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(20),
        border: Border(left: BorderSide(color: color, width: 3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: color, size: 24),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label.toUpperCase(),
                style: GoogleFonts.spaceMono(
                  color: Colors.white.withValues(alpha: 0.4),
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              Text(
                value,
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankings(List<Player> players) {
    return Column(
      children: players.asMap().entries.map((entry) {
        final index = entry.key;
        final player = entry.value;
        final isWinner = index == 0;
        
        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isWinner ? AppTheme.surfaceContainerHigh : AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: isWinner ? Colors.amber.withValues(alpha: 0.2) : Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: Text(
                  '${index + 1}',
                  style: GoogleFonts.spaceMono(
                    color: isWinner ? Colors.amber : Colors.white.withValues(alpha: 0.4),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  player.name,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontWeight: isWinner ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              Text(
                '${session.currency}${player.balance.toStringAsFixed(0)}',
                style: GoogleFonts.spaceMono(
                  color: isWinner ? Colors.amber : Colors.white.withValues(alpha: 0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildExitButton(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primaryColor, Color(0xFF13EA79)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.black, size: 24),
            const SizedBox(width: 12),
            Text(
              'SAVE & EXIT',
              style: GoogleFonts.plusJakartaSans(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
