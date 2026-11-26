import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/auth/presentation/bloc/auth_bloc.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingStep> _steps = [
    const OnboardingStep(
      title: 'WELCOME TO\nMONOLEDGER',
      description:
          'The ultimate digital currency companion for your favorite board games.',
      icon: Icons.account_balance_wallet_rounded,
    ),
    const OnboardingStep(
      title: 'REAL-TIME\nSYNCING',
      description:
          'Every player stays in sync with live updates. No more manual calculations or paper money chaos.',
      icon: Icons.flash_on_rounded,
    ),
    const OnboardingStep(
      title: 'SECURE &\nPRIVATE',
      description:
          'Your session data is encrypted and secure. Focus on the game, we\'ll handle the numbers.',
      icon: Icons.security_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: Stack(
        children: [
          const Positioned.fill(child: _DotGridBackground()),
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) =>
                        setState(() => _currentPage = index),
                    itemCount: _steps.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(40.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor.withValues(
                                      alpha: 0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    _steps[index].icon,
                                    size: 80,
                                    color: AppTheme.primaryColor,
                                  ),
                                )
                                .animate(key: ValueKey('icon_$index'))
                                .scale(
                                  duration: 400.ms,
                                  curve: Curves.easeOutBack,
                                ),
                            const SizedBox(height: 60),
                            RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(
                                    style: GoogleFonts.plusJakartaSans(
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            '${_steps[index].title.split('\n')[0]}\n',
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      TextSpan(
                                        text: _steps[index].title.split(
                                          '\n',
                                        )[1],
                                        style: const TextStyle(
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                                .animate(key: ValueKey('title_$index'))
                                .fadeIn(duration: 400.ms)
                                .slideX(begin: 0.2, end: 0),
                            const SizedBox(height: 24),
                            Text(
                                  _steps[index].description,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: Colors.white.withValues(alpha: 0.6),
                                    fontSize: 16,
                                    height: 1.5,
                                  ),
                                )
                                .animate(key: ValueKey('desc_$index'))
                                .fadeIn(delay: 200.ms, duration: 400.ms),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                // Indicators and Button
                Padding(
                  padding: const EdgeInsets.all(40.0),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          _steps.length,
                          (index) => AnimatedContainer(
                            duration: 300.ms,
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            width: _currentPage == index ? 24 : 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppTheme.primaryColor
                                  : AppTheme.primaryColor.withValues(
                                      alpha: 0.2,
                                    ),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      SizedBox(
                        width: double.infinity,
                        height: 60,
                        child: BlocConsumer<AuthBloc, AuthState>(
                          listener: (context, state) {
                            if (state is AuthAuthenticated) {
                              context.go('/home');
                            } else if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(state.message),
                                  backgroundColor: AppTheme.errorColor,
                                ),
                              );
                            }
                          },
                          builder: (context, state) {
                            return Row(
                              children: [
                                if (_currentPage > 0)
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        right: 12.0,
                                      ),
                                      child: ElevatedButton(
                                        onPressed: () {
                                          _pageController.previousPage(
                                            duration: 300.ms,
                                            curve: Curves.easeInOut,
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(
                                            0xFF1C2026,
                                          ),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 16,
                                          ),
                                        ),
                                        child: const Icon(
                                          Icons.arrow_back,
                                          color: AppTheme.primaryColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                Expanded(
                                  flex: 2,
                                  child: ElevatedButton(
                                    onPressed: state is AuthLoading
                                        ? null
                                        : () {
                                            if (_currentPage <
                                                _steps.length - 1) {
                                              _pageController.nextPage(
                                                duration: 300.ms,
                                                curve: Curves.easeInOut,
                                              );
                                            } else {
                                              context.read<AuthBloc>().add(
                                                AuthLoginAnonymouslyRequested(),
                                              );
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppTheme.primaryColor,
                                      foregroundColor: Colors.black,
                                      elevation: 8,
                                      shadowColor: AppTheme.primaryColor
                                          .withValues(alpha: 0.3),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 16,
                                      ),
                                    ),
                                    child: state is AuthLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              color: Colors.black,
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : Text(
                                            _currentPage == _steps.length - 1
                                                ? 'START EXPERIENCE'
                                                : 'CONTINUE',
                                            style: GoogleFonts.plusJakartaSans(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 14,
                                              letterSpacing: 1,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
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

class OnboardingStep {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingStep({
    required this.title,
    required this.description,
    required this.icon,
  });
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

    const double spacing = 30.0;
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
