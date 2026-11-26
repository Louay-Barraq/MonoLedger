import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/join_code_parser.dart';
import 'package:monoledger/features/home/presentation/bloc/session_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/go_request_bloc.dart';
import 'package:monoledger/features/transactions/presentation/bloc/transaction_bloc.dart';

class JoinSessionCodePage extends StatefulWidget {
  final String? initialCode;

  const JoinSessionCodePage({super.key, this.initialCode});

  @override
  State<JoinSessionCodePage> createState() => _JoinSessionCodePageState();
}

class _JoinSessionCodePageState extends State<JoinSessionCodePage> {
  late final TextEditingController _codeController;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final code = widget.initialCode != null
        ? JoinCodeParser.parse(widget.initialCode!) ?? widget.initialCode!
        : '';
    _codeController = TextEditingController(text: code);
  }

  @override
  void dispose() {
    _codeController.dispose();
    _nameController.dispose();
    super.dispose();
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
            size: 20,
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
                content: Text(state.message),
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
                    'SESSION CODE',
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
                      'Enter Code',
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
                    'Enter the 6-character connect code and your name to join.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.6),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 32),
                  _InputFieldLabel(label: 'SESSION CODE'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _codeController,
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.characters,
                    maxLength: 6,
                    style: GoogleFonts.spaceMono(
                      fontSize: 28,
                      letterSpacing: 8,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      hintText: '000000',
                      hintStyle: GoogleFonts.spaceMono(
                        color: Colors.white.withValues(alpha: 0.1),
                        letterSpacing: 8,
                      ),
                      filled: true,
                      fillColor: const Color(0xFF14181F),
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
                      counterText: '',
                      contentPadding: const EdgeInsets.symmetric(vertical: 24),
                    ),
                  ),
                  const SizedBox(height: 24),
                  _InputFieldLabel(label: 'YOUR NAME'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameController,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Name',
                      hintStyle: GoogleFonts.plusJakartaSans(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                      filled: true,
                      fillColor: const Color(0xFF14181F),
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: AppTheme.primaryColor,
                      ),
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
                    ),
                  ),
                  const SizedBox(height: 48),
                  SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      onPressed: isLoading
                          ? null
                          : () {
                              final code = _codeController.text.toUpperCase();
                              final name = _nameController.text.trim();
                              if (code.length == 6 && name.isNotEmpty) {
                                context.read<TransactionBloc>().add(
                                  const TransactionsWatchStopped(),
                                );
                                context.read<GoRequestBloc>().add(
                                  const GoRequestsWatchStopped(),
                                );
                                context.read<SessionBloc>().add(
                                  SessionJoinRequested(
                                    joinCode: code,
                                    playerName: name,
                                  ),
                                );
                              } else {
                                String message =
                                    'Please enter a valid 6-character code.';
                                if (name.isEmpty) {
                                  message = 'Please enter your name.';
                                }
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(message),
                                    backgroundColor: AppTheme.errorColor,
                                  ),
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.primaryColor,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.black)
                          : Text(
                              'CONFIRM JOIN',
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                                letterSpacing: 1,
                              ),
                            ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _InputFieldLabel extends StatelessWidget {
  final String label;
  const _InputFieldLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.spaceMono(
        color: Colors.white.withValues(alpha: 0.4),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 2,
      ),
    );
  }
}
