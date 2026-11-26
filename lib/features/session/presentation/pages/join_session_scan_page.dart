import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/core/utils/join_code_parser.dart';

class JoinSessionScanPage extends StatefulWidget {
  const JoinSessionScanPage({super.key});

  @override
  State<JoinSessionScanPage> createState() => _JoinSessionScanPageState();
}

class _JoinSessionScanPageState extends State<JoinSessionScanPage> {
  final MobileScannerController _controller = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
  bool _handled = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_handled) return;
    final code = capture.barcodes
        .map((b) => b.rawValue)
        .whereType<String>()
        .map(JoinCodeParser.parse)
        .whereType<String>()
        .firstOrNull;
    if (code == null) return;

    _handled = true;
    _controller.stop();
    if (!mounted) return;
    context.pushReplacement('/join-session/code?code=$code');
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
          AppLocalizations.of(context).scanTitle,
          style: GoogleFonts.spaceMono(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppTheme.primaryColor,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              AppLocalizations.of(context).scanHint,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.6),
                fontSize: 14,
              ),
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: MobileScanner(
                  controller: _controller,
                  onDetect: _onDetect,
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}
