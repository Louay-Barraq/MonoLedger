import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:monoledger/core/theme/app_theme.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Wallet Tab
// ─────────────────────────────────────────────────────────────────────────────

class WalletTab extends StatelessWidget {
  final String sessionCode;

  const WalletTab({super.key, required this.sessionCode});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Balance Card
          _BalanceCard(),
          const SizedBox(height: 24),

          // GO Salary Banner
          _GoSalaryBanner(),
          const SizedBox(height: 24),

          // Bank Actions
          Row(
            children: [
              Expanded(
                child: _BankActionCard(
                  label: 'PAY BANK',
                  icon: Icons.account_balance_rounded,
                  isDebit: true,
                  onTap: () => context.push('/payment-pad', extra: {'targetName': 'The Bank', 'isPaying': true}),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _BankActionCard(
                  label: 'FROM BANK',
                  icon: Icons.payments_rounded,
                  isDebit: false,
                  onTap: () => context.push('/payment-pad', extra: {'targetName': 'The Bank', 'isPaying': false}),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Players Section Header
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
                '4 ACTIVE',
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

          // Players List
          _PlayerCard(name: 'Alex Rivera', token: 'CAR TOKEN', balance: 1450, rank: 1, isCurrentUser: false),
          const SizedBox(height: 8),
          _PlayerCard(name: 'Sarah Chen', token: 'HAT TOKEN', balance: 890, rank: 2, isCurrentUser: false),
          const SizedBox(height: 8),
          _PlayerCard(name: 'Chris Miller', token: 'THIMBLE TOKEN', balance: 420, rank: 3, isCurrentUser: true),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}

class _BalanceCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
          Text(
            '\$2,300',
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white,
              fontSize: 54,
              fontWeight: FontWeight.w800,
              letterSpacing: -2,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: AppTheme.primaryColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.trending_up_rounded, color: AppTheme.primaryColor, size: 16),
                const SizedBox(width: 6),
                Text(
                  '+12% vs START',
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
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // TODO: Collect GO salary action
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('GO Salary collected: +\$200', style: GoogleFonts.spaceMono(color: Colors.black)),
            backgroundColor: AppTheme.primaryColor,
          ),
        );
      },
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
            Column(
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
                  'COLLECT SALARY',
                  style: GoogleFonts.spaceMono(
                    color: Colors.black.withValues(alpha: 0.6),
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  '+\$200',
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.black,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.arrow_forward_rounded, color: Colors.black, size: 24),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _BankActionCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isDebit;
  final VoidCallback onTap;

  const _BankActionCard({required this.label, required this.icon, required this.isDebit, required this.onTap});

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
  final String token;
  final int balance;
  final int rank;
  final bool isCurrentUser;

  const _PlayerCard({
    required this.name,
    required this.token,
    required this.balance,
    required this.rank,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isCurrentUser 
          ? null 
          : () => context.push('/payment-pad', extra: {'targetName': name, 'isPaying': true}),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isCurrentUser ? AppTheme.primaryColor.withValues(alpha: 0.3) : Colors.white.withValues(alpha: 0.06),
          ),
        ),
        child: Row(
          children: [
            // Avatar
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: AppTheme.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.2)),
              ),
              child: const Icon(Icons.person_rounded, color: AppTheme.primaryColor, size: 26),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      if (isCurrentUser) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppTheme.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: AppTheme.primaryColor.withValues(alpha: 0.4)),
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
                  const SizedBox(height: 3),
                  Text(
                    token,
                    style: GoogleFonts.spaceMono(
                      color: Colors.white.withValues(alpha: 0.4),
                      fontSize: 10,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '\$$balance',
                  style: GoogleFonts.spaceMono(
                    color: rank == 1 ? AppTheme.primaryColor : Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'RANK #$rank',
                  style: GoogleFonts.spaceMono(
                    color: Colors.white.withValues(alpha: 0.4),
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
