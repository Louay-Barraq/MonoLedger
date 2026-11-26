import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/currency_formatter.dart';
import 'package:monoledger/core/utils/thousands_separator_formatter.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/go_request_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';

class CreateSessionPage extends StatefulWidget {
  const CreateSessionPage({super.key});

  @override
  State<CreateSessionPage> createState() => _CreateSessionPageState();
}

class _CreateSessionPageState extends State<CreateSessionPage> {
  // Form state
  String _bankerName = '';
  String _currencySymbol = '\$';
  int _startingCapital = 1500;
  int _goAmount = 200;
  bool _isCustomCapital = false;
  bool _isCustomGoAmount = false;
  final TextEditingController _customCapitalController =
      TextEditingController();
  final TextEditingController _customGoAmountController =
      TextEditingController();
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _capitalFocusNode = FocusNode();
  final FocusNode _goFocusNode = FocusNode();

  @override
  void dispose() {
    _customCapitalController.dispose();
    _customGoAmountController.dispose();
    _nameFocusNode.dispose();
    _capitalFocusNode.dispose();
    _goFocusNode.dispose();
    super.dispose();
  }

  void _onCustomCapitalSubmitted(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final amount = int.tryParse(cleanValue);
    if (amount != null && amount > 0) {
      setState(() {
        _startingCapital = amount;
        // Keep it as custom but unfocus
        _capitalFocusNode.unfocus();
      });
    }
  }

  void _onCustomCapitalChanged(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final amount = int.tryParse(cleanValue);
    if (amount != null && amount > 0) {
      setState(() {
        _startingCapital = amount;
      });
    }
  }

  void _onCustomGoAmountSubmitted(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final amount = int.tryParse(cleanValue);
    if (amount != null && amount > 0) {
      setState(() {
        _goAmount = amount;
        _goFocusNode.unfocus();
      });
    }
  }

  void _onCustomGoAmountChanged(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final amount = int.tryParse(cleanValue);
    if (amount != null && amount > 0) {
      setState(() {
        _goAmount = amount;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppTheme.primaryColor,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'MONOLEDGER',
          style: GoogleFonts.spaceMono(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SessionBloc, SessionState>(
        listener: (context, state) {
          if (state is SessionError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context).message(state.message),
                ),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          } else if (state is SessionSuccess) {
            context.pushReplacement(
              '/dashboard?code=${state.session.joinCode}',
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is SessionLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    AppLocalizations.of(context).createHeader,
                    style: GoogleFonts.spaceMono(
                      color: AppTheme.primaryColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: Text(
                      AppLocalizations.of(context).createTitle,
                      style: GoogleFonts.plusJakartaSans(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    AppLocalizations.of(context).createSubtitle,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Your Name
                  _sectionTitle(AppLocalizations.of(context).createYourName),
                  const SizedBox(height: 12),
                  TextField(
                    focusNode: _nameFocusNode,
                    onChanged: (val) => setState(() => _bankerName = val),
                    onTap: () {
                      setState(() {
                        _isCustomCapital = false;
                        _isCustomGoAmount = false;
                        _customCapitalController.clear();
                        _customGoAmountController.clear();
                      });
                    },
                    style: GoogleFonts.inter(color: Colors.white, fontSize: 16),
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context).createNameHint,
                      hintStyle: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF14181F),
                      contentPadding: const EdgeInsets.all(20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide(
                          color: Colors.white.withValues(alpha: 0.05),
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: Icon(
                          Icons.fingerprint,
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Currency Symbol
                  _sectionTitle(AppLocalizations.of(context).createCurrency),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _currencyChip('\$', _currencySymbol == '\$'),
                        const SizedBox(width: 12),
                        _currencyChip('€', _currencySymbol == '€'),
                        const SizedBox(width: 12),
                        _currencyChip('£', _currencySymbol == '£'),
                        const SizedBox(width: 12),
                        _currencyChip('¥', _currencySymbol == '¥'),
                        const SizedBox(width: 12),
                        _currencyChip('TND', _currencySymbol == 'TND'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Starting Capital
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle(
                        AppLocalizations.of(context).createStartingCapital,
                      ),
                      Text(
                        CurrencyFormatter.formatMoney(
                          _currencySymbol,
                          _startingCapital,
                        ),
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Cards Grid
                  Row(
                    children: [
                      Expanded(
                        child: _capitalCard(
                          1500,
                          AppLocalizations.of(context).createPresetStandard,
                          _startingCapital == 1500 && !_isCustomCapital,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _capitalCard(
                          2000,
                          AppLocalizations.of(context).createPresetPro,
                          _startingCapital == 2000 && !_isCustomCapital,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _capitalCard(
                          3000,
                          AppLocalizations.of(context).createPresetCapitalist,
                          _startingCapital == 3000 && !_isCustomCapital,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _capitalCard(
                          5000,
                          AppLocalizations.of(context).createPresetWhale,
                          _startingCapital == 5000 && !_isCustomCapital,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Custom Capital Button/Input
                  // Custom Capital Button/Input
                  if (_isCustomCapital)
                    TextField(
                      controller: _customCapitalController,
                      focusNode: _capitalFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsSeparatorInputFormatter()],
                      autofocus: true,
                      onTap: () {
                        // Ensure other custom states are handled
                        setState(() {
                          _isCustomGoAmount = false;
                          _customGoAmountController.clear();
                        });
                      },
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        ).createEnterAmount,
                        hintStyle: GoogleFonts.spaceMono(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF14181F),
                        suffixText: _currencySymbol,
                        suffixStyle: GoogleFonts.spaceMono(
                          color: AppTheme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: _onCustomCapitalChanged,
                      onSubmitted: _onCustomCapitalSubmitted,
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCustomCapital = true;
                          _isCustomGoAmount = false;
                          _nameFocusNode.unfocus();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14181F),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).createCustomAmount,
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 32),

                  // GO Amount
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _sectionTitle(
                        AppLocalizations.of(context).createGoAmount,
                      ),
                      Text(
                        CurrencyFormatter.formatMoney(
                          _currencySymbol,
                          _goAmount,
                        ),
                        style: GoogleFonts.spaceMono(
                          color: AppTheme.primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _capitalCard(
                          100,
                          '100',
                          _goAmount == 100 && !_isCustomGoAmount,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _capitalCard(
                          200,
                          '200',
                          _goAmount == 200 && !_isCustomGoAmount,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _capitalCard(
                          400,
                          '400',
                          _goAmount == 400 && !_isCustomGoAmount,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _capitalCard(
                          500,
                          '500',
                          _goAmount == 500 && !_isCustomGoAmount,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_isCustomGoAmount)
                    TextField(
                      controller: _customGoAmountController,
                      focusNode: _goFocusNode,
                      keyboardType: TextInputType.number,
                      inputFormatters: [ThousandsSeparatorInputFormatter()],
                      autofocus: true,
                      onTap: () {
                        setState(() {
                          _isCustomCapital = false;
                          _customCapitalController.clear();
                        });
                      },
                      style: GoogleFonts.spaceMono(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(
                          context,
                        ).createEnterAmount,
                        hintStyle: GoogleFonts.spaceMono(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        filled: true,
                        fillColor: const Color(0xFF14181F),
                        suffixText: _currencySymbol,
                        suffixStyle: GoogleFonts.spaceMono(
                          color: AppTheme.primaryColor,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: const BorderSide(
                            color: AppTheme.primaryColor,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: _onCustomGoAmountChanged,
                      onSubmitted: _onCustomGoAmountSubmitted,
                    )
                  else
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          _isCustomGoAmount = true;
                          _isCustomCapital = false;
                          _nameFocusNode.unfocus();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: const Color(0xFF14181F),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.05),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context).createCustomAmount,
                            style: GoogleFonts.spaceMono(
                              color: AppTheme.primaryColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              letterSpacing: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: 40),

                  // Create Start Button
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final name = _bankerName.trim();
                              if (name.isEmpty) {
                                _showValidationError(
                                  AppLocalizations.of(
                                    context,
                                  ).createNameRequired,
                                );
                                return;
                              }

                              if (_startingCapital <= 0) {
                                _showValidationError(
                                  AppLocalizations.of(
                                    context,
                                  ).createCapitalInvalid,
                                );
                                return;
                              }

                              if (_goAmount < 0) {
                                _showValidationError(
                                  AppLocalizations.of(context).createGoInvalid,
                                );
                                return;
                              }

                              context.read<TransactionBloc>().add(
                                const TransactionsWatchStopped(),
                              );
                              context.read<GoRequestBloc>().add(
                                const GoRequestsWatchStopped(),
                              );
                              context.read<SessionBloc>().add(
                                SessionCreateRequested(
                                  currency: _currencySymbol,
                                  startingBalance: _startingCapital,
                                  goAmount: _goAmount,
                                  bankerName: _bankerName.trim(),
                                ),
                              );
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 8,
                        shadowColor: AppTheme.primaryColor.withValues(
                          alpha: 0.5,
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    AppLocalizations.of(context).createSubmit,
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.rocket_launch, size: 20),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showValidationError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.errorColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.spaceMono(
        color: Colors.white.withValues(alpha: 0.5),
        fontSize: 10,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }

  Widget _currencyChip(String symbol, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _currencySymbol = symbol),
      child: Container(
        height: 64,
        width: 80,
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primaryColor : const Color(0xFF1C2026),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : Colors.white.withValues(alpha: 0.05),
          ),
        ),
        child: Center(
          child: Text(
            symbol,
            style: GoogleFonts.spaceMono(
              color: isSelected ? Colors.black : Colors.white,
              fontSize: symbol.length > 1 ? 18 : 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _capitalCard(int amount, String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // determine which field to set based on label content vs amount comparisons
          // since _capitalCard is shared, check label to know if it's a GO card or capital card
          final goAmounts = [100, 200, 400, 500];
          if (goAmounts.contains(amount) &&
              ![1500, 2000, 3000, 5000].contains(amount)) {
            _goAmount = amount;
            _isCustomGoAmount = false;
          } else {
            _startingCapital = amount;
            _isCustomCapital = false;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.primaryColor.withValues(alpha: 0.05)
              : const Color(0xFF14181F),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected
                ? AppTheme.primaryColor
                : Colors.white.withValues(alpha: 0.05),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              CurrencyFormatter.formatMoney(_currencySymbol, amount),
              style: GoogleFonts.spaceMono(
                color: isSelected ? AppTheme.primaryColor : Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: GoogleFonts.spaceMono(
                color: isSelected
                    ? AppTheme.primaryColor
                    : Colors.white.withValues(alpha: 0.5),
                fontSize: 10,
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
