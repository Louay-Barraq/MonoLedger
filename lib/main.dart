import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/payment_pad_route.dart';
import 'package:monoledger/init_dependencies.dart';

import 'package:monoledger/features/splash/presentation/pages/splash_page.dart';
import 'package:monoledger/features/splash/presentation/pages/onboarding_page.dart';
import 'package:monoledger/features/home/presentation/pages/home_page.dart';
import 'package:monoledger/features/session/presentation/pages/create_session_page.dart';
import 'package:monoledger/features/session/presentation/pages/join_session_page.dart';
import 'package:monoledger/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:monoledger/features/dashboard/presentation/pages/payment_pad_page.dart';
import 'package:monoledger/features/dashboard/presentation/pages/game_settings_page.dart';
import 'package:monoledger/features/dashboard/presentation/pages/end_of_game_summary_page.dart';

import 'package:monoledger/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/home/domain/entities/session.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initDependencies();
  runApp(const MonoLedgerApp());
}

final _router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashPage(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingPage(),
    ),
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/create-session',
      builder: (context, state) => const CreateSessionPage(),
    ),
    GoRoute(
      path: '/join-session',
      builder: (context, state) => const JoinSessionPage(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) {
        final sessionCode = state.uri.queryParameters['code'] ?? '000000';
        return DashboardPage(sessionCode: sessionCode);
      },
    ),
    GoRoute(
      path: '/payment-pad',
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>? ?? {};
        return PaymentPadPage(
          targetName: args[PaymentPadRoute.targetName] as String? ?? 'Unknown',
          isPaying: args[PaymentPadRoute.isPaying] as bool? ?? true,
          sessionId: args[PaymentPadRoute.sessionId] as String? ?? '',
          currency: args[PaymentPadRoute.currency] as String? ?? '\$',
          recipientPlayerId: args[PaymentPadRoute.recipientPlayerId] as String?,
          isBankTarget: args[PaymentPadRoute.isBankTarget] as bool? ?? false,
        );
      },
    ),
    GoRoute(
      path: '/game-settings',
      builder: (context, state) {
        final session = state.extra as Session;
        return GameSettingsPage(session: session);
      },
    ),
    GoRoute(
      path: '/end-summary',
      builder: (context, state) {
        final session = state.extra as Session;
        return EndOfGameSummaryPage(session: session);
      },
    ),
  ],
);

class MonoLedgerApp extends StatelessWidget {
  const MonoLedgerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => serviceLocator<AuthBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<SessionBloc>(),
        ),
        BlocProvider(
          create: (context) => serviceLocator<TransactionBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'MonoLedger',
        theme: AppTheme.darkTheme,
        routerConfig: _router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
