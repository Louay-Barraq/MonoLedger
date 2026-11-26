import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monoledger/core/widgets/monoledger_logo.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:go_router/go_router.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();
    context.read<AuthBloc>().add(AuthCheckStatusRequested());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) context.go('/home');
          });
        } else if (state is AuthUnauthenticated || state is AuthError) {
          Future.delayed(const Duration(seconds: 3), () {
            if (context.mounted) context.go('/onboarding');
          });
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: Stack(
          children: [
            // Scanline effect
            Positioned.fill(
              child: Opacity(
                opacity: 0.05,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: List.generate(
                        100,
                        (index) =>
                            index % 2 == 0 ? Colors.transparent : Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo Icon (A stylized coin or ledger)
                  Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withValues(alpha: 0.1),
                          border: Border.all(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withValues(
                                alpha: 0.3,
                              ),
                              blurRadius: 20,
                            ),
                          ],
                        ),
                        child: const Center(child: MonoLedgerLogo(size: 52)),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .shimmer(duration: 2.seconds, color: Colors.white24)
                      .shake(hz: 2, curve: Curves.easeInOut)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        end: const Offset(1.0, 1.0),
                        duration: 1.seconds,
                      ),
                  const SizedBox(height: 24),
                  // App Title
                  RichText(
                        text: TextSpan(
                          style: GoogleFonts.plusJakartaSans(
                            fontSize: 32,
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
                      )
                      .animate()
                      .fadeIn(duration: 800.ms)
                      .slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 12),
                  // Version / Loading subtitle
                  Text(
                        'DIGITAL CURRENCY FOR BOARD GAMES',
                        style: GoogleFonts.inter(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 10,
                          letterSpacing: 2,
                        ),
                      )
                      .animate(onPlay: (controller) => controller.repeat())
                      .fadeIn(duration: 500.ms)
                      .then()
                      .fadeOut(duration: 500.ms, delay: 1.seconds),
                ],
              ),
            ),
            // CRT "Power On" overlay
            Container(color: Colors.white)
                .animate()
                .fadeOut(duration: 100.ms)
                .scaleY(
                  begin: 1,
                  end: 0.01,
                  duration: 200.ms,
                  curve: Curves.easeIn,
                )
                .scaleX(
                  begin: 1,
                  end: 0,
                  delay: 200.ms,
                  duration: 150.ms,
                  curve: Curves.easeIn,
                ),
          ],
        ),
      ),
    );
  }
}
