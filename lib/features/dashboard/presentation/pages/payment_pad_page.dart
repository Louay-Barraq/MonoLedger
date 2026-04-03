import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/features/dashboard/presentation/widgets/slide_to_confirm.dart';

class PaymentPadPage extends StatefulWidget {
  final String targetName; // e.g., "The Bank", "Alex Rivera"
  final bool isPaying; // true if sending money, false if receiving

  const PaymentPadPage({
    super.key,
    required this.targetName,
    required this.isPaying,
  });

  @override
  State<PaymentPadPage> createState() => _PaymentPadPageState();
}

class _PaymentPadPageState extends State<PaymentPadPage> {
  String _amountString = '0';
  final String _currencySymbol = '\$'; // TODO: Get from Session

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'C') {
        _amountString = '0';
      } else if (key == '<') {
        if (_amountString.length > 1) {
          _amountString = _amountString.substring(0, _amountString.length - 1);
        } else {
          _amountString = '0';
        }
      } else {
        if (_amountString == '0') {
          _amountString = key;
        } else if (_amountString.length < 8) { // Prevent overflow
          _amountString += key;
        }
      }
    });
  }

  void _onConfirm() {
    final amount = int.tryParse(_amountString) ?? 0;
    if (amount > 0) {
      // TODO: Dispatch payment event to bloc
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${widget.isPaying ? 'Paid' : 'Received'} $_currencySymbol${CurrencyFormatter.formatAmount(amount)}',
            style: GoogleFonts.spaceMono(color: Colors.black),
          ),
          backgroundColor: AppTheme.primaryColor,
        ),
      );
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final int amount = int.tryParse(_amountString) ?? 0;
    final actionColor = widget.isPaying ? AppTheme.errorColor : AppTheme.primaryColor;

    return Scaffold(
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
            // Header
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
                  Text(
                    widget.targetName.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppTheme.primaryColor, // using primary color
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
            ),
            
            // Amount Display
            Expanded(
              flex: 3,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      '$_currencySymbol${CurrencyFormatter.formatAmount(amount)}',
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
            ),

            // Numpad Area
            Expanded(
              flex: 5,
              child: Container(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 32),
                decoration: BoxDecoration(
                  color: AppTheme.surfaceContainerLow,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
                  border: Border(
                    top: BorderSide(color: Colors.white.withValues(alpha: 0.05)),
                  ),
                ),
                child: Column(
                  children: [
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
                          _numpadButton('0'),
                          _numpadSpecialButton('<', Icons.backspace_outlined, Colors.white),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Action Button
                    Opacity(
                      opacity: amount > 0 ? 1.0 : 0.5,
                      child: IgnorePointer(
                        ignoring: amount <= 0,
                        child: SlideToConfirm(
                          text: widget.isPaying ? 'SLIDE TO PAY' : 'SLIDE TO RECEIVE',
                          baseColor: actionColor,
                          onConfirm: _onConfirm,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _numpadButton(String digit) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: InkWell(
          onTap: () => _onKeyPress(digit),
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withValues(alpha: 0.1),
          highlightColor: Colors.white.withValues(alpha: 0.05),
          child: Container(
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerHigh.withValues(alpha: 0.5),
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
          splashColor: color.withValues(alpha: 0.1),
          highlightColor: color.withValues(alpha: 0.05),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Icon(icon, color: color, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}
