import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';

class JoinMethodPage extends StatelessWidget {
  const JoinMethodPage({super.key});

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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                AppLocalizations.of(context).joinHeader,
                style: GoogleFonts.spaceMono(
                  color: AppTheme.primaryColor,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).joinTitle,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).joinSubtitle,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: Colors.white.withValues(alpha: 0.6),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 48),
              _MethodButton(
                label: AppLocalizations.of(context).joinEnterCode,
                subtitle: AppLocalizations.of(context).joinEnterCodeSubtitle,
                icon: Icons.pin_outlined,
                onTap: () => context.push('/join-session/code'),
              ),
              const SizedBox(height: 16),
              _MethodButton(
                label: AppLocalizations.of(context).joinScanQr,
                subtitle: AppLocalizations.of(context).joinScanQrSubtitle,
                icon: Icons.qr_code_scanner_rounded,
                onTap: () => context.push('/join-session/scan'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MethodButton extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const _MethodButton({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: AppTheme.primaryColor, size: 28),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: AppTheme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
