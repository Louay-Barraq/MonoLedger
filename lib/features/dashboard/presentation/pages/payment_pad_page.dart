import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/amount_pad_input.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/core/widgets/overflow_safe_text.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/slide_to_confirm.dart';
import 'package:monoledger/features/home/domain/entities/session_extensions.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';

class PaymentPadPage extends StatefulWidget {
  final String targetName;
  final bool isPaying;
  final String sessionId;
  final String currency;
  final String? recipientPlayerId;
  final bool isBankTarget;

  const PaymentPadPage({
    super.key,
    required this.targetName,
    required this.isPaying,
    required this.sessionId,
    required this.currency,
    this.recipientPlayerId,
    this.isBankTarget = false,
  });

  @override
  State<PaymentPadPage> createState() => _PaymentPadPageState();
}

class _PaymentPadPageState extends State<PaymentPadPage> {
  final AmountPadInput _amountInput = AmountPadInput();
  final GlobalKey<SlideToConfirmState> _slideKey = GlobalKey<SlideToConfirmState>();

  static const List<num> _denominations = [1, 5, 10, 20, 50, 100, 500];

  void _onKeyPress(String key) {
    setState(() => _amountInput.onKey(key));
  }

  void _addDenomination(num value) {
    setState(() => _amountInput.add(value));
  }

  Future<bool> _handleSlideConfirm() async {
    final txState = context.read<TransactionBloc>().state;
    if (txState is TransactionLoading) return false;

    final amount = _amountInput.value;
    if (amount <= 0 || widget.sessionId.isEmpty) return false;
    if (!_canSubmitTransaction()) return false;

    if (_requiresLargeBankPayoutConfirm(amount)) {
      final confirmed = await _showLargeBankPayoutDialog(amount);
      if (!confirmed) return false;
    }

    return _executeTransaction(amount);
  }

  bool _requiresLargeBankPayoutConfirm(num amount) {
    if (!widget.isBankTarget || widget.isPaying) return false;

    final sessionState = context.read<SessionBloc>().state;
    if (sessionState is! SessionSuccess) return false;

    final totalLiquidity = sessionState.session.activePlayers
        .fold<double>(0, (sum, p) => sum + p.balance);

    if (totalLiquidity <= 0) return false;
    return amount > totalLiquidity * 0.5;
  }

  Future<bool> _showLargeBankPayoutDialog(num amount) async {
    final formatted = CurrencyFormatter.formatMoney(widget.currency, amount);
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerHigh,
        title: const Text('Large bank payout'),
        content: Text(
          'This payout ($formatted) exceeds 50% of total session liquidity. Confirm to proceed.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('CANCEL'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('CONFIRM', style: TextStyle(color: AppTheme.primaryColor)),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  Future<bool> _executeTransaction(num amount) async {
    final bloc = context.read<TransactionBloc>();
    final completer = Completer<bool>();

    late final StreamSubscription<TransactionState> subscription;
    subscription = bloc.stream.listen((state) {
      if (state is TransactionSuccess) {
        if (!completer.isCompleted) completer.complete(true);
        subscription.cancel();
      } else if (state is TransactionError) {
        if (!completer.isCompleted) completer.complete(false);
        subscription.cancel();
      }
    });

    _dispatchTransaction(bloc, amount);

    try {
      return await completer.future.timeout(
        const Duration(seconds: 20),
        onTimeout: () => false,
      );
    } finally {
      await subscription.cancel();
    }
  }

  bool _canSubmitTransaction() {
    final sessionState = context.read<SessionBloc>().state;
    if (sessionState is! SessionSuccess) return false;
    if (!sessionState.session.isUserActive(
      Supabase.instance.client.auth.currentUser?.id,
    )) {
      return false;
    }
    if (!widget.isBankTarget &&
        widget.recipientPlayerId != null &&
        !sessionState.session.activePlayers
            .any((p) => p.id == widget.recipientPlayerId)) {
      return false;
    }
    return true;
  }

  void _dispatchTransaction(TransactionBloc bloc, num amount) {
    if (!_canSubmitTransaction()) return;

    if (widget.isBankTarget) {
      bloc.add(BankPaymentSubmitted(
        sessionId: widget.sessionId,
        amount: amount,
        isPaying: widget.isPaying,
      ));
    } else if (widget.recipientPlayerId != null && widget.isPaying) {
      bloc.add(TransferSubmitted(
        sessionId: widget.sessionId,
        toPlayerId: widget.recipientPlayerId!,
        amount: amount,
        memo: 'PAYMENT',
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final amount = _amountInput.value;
    final amountLabel = CurrencyFormatter.formatPadAmount(
      widget.currency,
      _amountInput.raw.isEmpty ? '0' : _amountInput.raw,
    );
    final actionColor = widget.isPaying ? AppTheme.errorColor : AppTheme.primaryColor;

    return MultiBlocListener(
      listeners: [
        BlocListener<SessionBloc, SessionState>(
          listenWhen: (prev, curr) =>
              curr is SessionKicked || curr is SessionInitial,
          listener: (context, state) {
            if (state is SessionKicked || state is SessionInitial) {
              if (context.mounted) context.pop();
            }
          },
        ),
        BlocListener<TransactionBloc, TransactionState>(
          listenWhen: (prev, curr) =>
              curr is TransactionSuccess || curr is TransactionError,
          listener: (context, state) {
        if (state is TransactionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                state.message,
                style: GoogleFonts.spaceMono(color: Colors.black),
              ),
              backgroundColor: AppTheme.primaryColor,
            ),
          );
          context.pop();
        } else if (state is TransactionError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close_rounded, color: Colors.white),
            onPressed: () => context.pop(),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  children: [
                    Text(
                      widget.isPaying ? 'PAYING TO' : 'RECEIVING FROM',
                      style: GoogleFonts.spaceMono(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    OverflowSafeText(
                      widget.targetName.toUpperCase(),
                      style: GoogleFonts.plusJakartaSans(
                        color: AppTheme.primaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: OverflowSafeText(
                      amountLabel,
                      style: GoogleFonts.plusJakartaSans(
                        color: amount > 0 ? Colors.white : Colors.white.withValues(alpha: 0.2),
                        fontSize: 84,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -4,
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                  decoration: BoxDecoration(
                    color: AppTheme.surfaceContainerLow,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                    border: Border(
                      top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: _denominations.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 8),
                          itemBuilder: (context, index) {
                            final value = _denominations[index];
                            return _DenominationChip(
                              label: CurrencyFormatter.formatMoney(widget.currency, value),
                              onTap: () => _addDenomination(value),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Expanded(
                        child: Row(
                          children: [
                            _numpadButton('1'),
                            _numpadButton('2'),
                            _numpadButton('3'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _numpadButton('4'),
                            _numpadButton('5'),
                            _numpadButton('6'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _numpadButton('7'),
                            _numpadButton('8'),
                            _numpadButton('9'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            _numpadSpecialButton('C', Icons.clear_rounded, Colors.white.withValues(alpha: 0.2)),
                            _numpadButton(','),
                            _numpadButton('0'),
                            _numpadSpecialButton('<', Icons.backspace_outlined, Colors.white),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<TransactionBloc, TransactionState>(
                        builder: (context, state) {
                          final loading = state is TransactionLoading;
                          return SlideToConfirm(
                            key: _slideKey,
                            text: widget.isPaying ? 'SLIDE TO PAY' : 'SLIDE TO RECEIVE',
                            baseColor: actionColor,
                            enabled: amount > 0 && !loading,
                            onConfirmAsync: _handleSlideConfirm,
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _numpadButton(String digit) {
    final isDecimal = digit == ',';
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          onTap: () => _onKeyPress(digit),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh.withValues(alpha: isDecimal ? 0.35 : 0.5),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.white.withValues(alpha: 0.03)),
            ),
            child: Center(
              child: Text(
                digit,
                style: GoogleFonts.spaceMono(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _numpadSpecialButton(String value, IconData icon, Color color) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          onTap: () => _onKeyPress(value),
          borderRadius: BorderRadius.circular(16),
          child: Container(
            child: Center(child: Icon(icon, color: color, size: 28)),
          ),
        ),
      ),
    );
  }
}

class _DenominationChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DenominationChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 96),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                label,
                style: GoogleFonts.spaceMono(
                  color: AppTheme.primaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
