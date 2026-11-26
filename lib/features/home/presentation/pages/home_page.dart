import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          // Background Dot Grid
          const Positioned.fill(child: _DotGridBackground()),

          SafeArea(
            child: Stack(
              children: [
                Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 40,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Logo Section
                        const _LogoSection(),
                        const SizedBox(height: 32),

                        // Title Section
                        _TitleSection(tagline: l10n.homeTagline),
                        const SizedBox(height: 48),

                        // Action Buttons
                        BlocListener<SessionBloc, SessionState>(
                          listenWhen: (_, state) => state is SessionError,
                          listener: (context, state) {
                            if (state is SessionError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                            }
                          },
                          child: Column(
                            children: [
                              _LandingButton(
                                label: l10n.homeCreateSession,
                                icon: Icons.add_circle,
                                isPrimary: true,
                                isLoading: false,
                                onPressed: () =>
                                    context.push('/create-session'),
                              ),
                              const SizedBox(height: 16),
                              _LandingButton(
                                label: l10n.homeJoinSession,
                                icon: Icons.arrow_forward,
                                isPrimary: false,
                                onPressed: () => context.push('/join-session'),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Info Cards Row
                        Row(
                          children: [
                            Expanded(
                              child: _InfoCard(
                                icon: Icons.group_outlined,
                                label: l10n.homeCapacity,
                                value: l10n.homeCapacityValue,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _InfoCard(
                                icon: Icons.flash_on_rounded,
                                label: l10n.homeSyncing,
                                value: l10n.homeSyncingValue,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 48),

                        // Footer Text
                        Text(
                          l10n.homeFooter,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.plusJakartaSans(
                            color: Colors.white.withValues(alpha: 0.5),
                            fontSize: 14,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            3,
                            (index) => Container(
                              width: 4,
                              height: 4,
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppTheme.primaryColor.withValues(
                                  alpha: index == 1 ? 1 : 0.2,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Buttons go last so they sit above the full-screen scroll view.
                Positioned(
                  top: 8,
                  left: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.settings_rounded,
                      color: AppTheme.primaryColor,
                      size: 26,
                    ),
                    tooltip: l10n.settingsTitle,
                    onPressed: () => context.push('/settings'),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 16,
                  child: IconButton(
                    icon: const Icon(
                      Icons.history_rounded,
                      color: AppTheme.primaryColor,
                      size: 26,
                    ),
                    tooltip: 'Past games',
                    onPressed: () => context.push('/history'),
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

class _LogoSection extends StatelessWidget {
  const _LogoSection();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xFF14181F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppTheme.primaryColor.withValues(alpha: 0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryColor.withValues(alpha: 0.1),
            blurRadius: 20,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.account_balance_wallet_rounded,
        color: AppTheme.primaryColor,
        size: 40,
      ),
    ).animate().fadeIn(duration: 600.ms).scale(delay: 200.ms);
  }
}

class _TitleSection extends StatelessWidget {
  final String tagline;

  const _TitleSection({required this.tagline});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            style: GoogleFonts.plusJakartaSans(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
            children: const [
              TextSpan(
                text: 'Mono',
                style: TextStyle(color: Colors.white),
              ),
              TextSpan(
                text: 'Ledger',
                style: TextStyle(color: AppTheme.primaryColor),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          tagline,
          style: GoogleFonts.plusJakartaSans(
            color: Colors.white.withValues(alpha: 0.7),
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 2,
          ),
        ),
      ],
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.2, end: 0);
  }
}

class _LandingButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isPrimary;
  final bool isLoading;
  final VoidCallback onPressed;

  const _LandingButton({
    required this.label,
    required this.icon,
    required this.isPrimary,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? AppTheme.primaryColor
              : const Color(0xFF1C2026),
          foregroundColor: isPrimary ? Colors.black : Colors.white,
          elevation: isPrimary ? 8 : 0,
          shadowColor: isPrimary
              ? AppTheme.primaryColor.withValues(alpha: 0.5)
              : Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.black,
                ),
              )
            else ...[
              const Spacer(),
              Text(
                label,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  letterSpacing: 0.5,
                ),
              ),
              const Spacer(),
              Icon(
                icon,
                size: 20,
                color: isPrimary ? Colors.black : AppTheme.primaryColor,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111418),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: AppTheme.primaryColor, size: 24),
          const SizedBox(height: 16),
          Text(
            label,
            style: GoogleFonts.plusJakartaSans(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
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

class _DotGridBackground extends StatelessWidget {
  const _DotGridBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: _DotPainter());
  }
}

class _DotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    const double spacing = 25.0;
    const double radius = 1.0;

    for (double x = 0; x < size.width; x += spacing) {
      for (double y = 0; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
