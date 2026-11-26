import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';

Future<void> showKickedFromSessionDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => AlertDialog(
      backgroundColor: AppTheme.surfaceContainerHigh,
      title: Text(
        AppLocalizations.of(ctx).removedTitle,
        style: GoogleFonts.plusJakartaSans(
          color: Colors.white,
          fontWeight: FontWeight.w800,
        ),
      ),
      content: Text(
        AppLocalizations.of(ctx).removedBody,
        style: GoogleFonts.inter(
          color: Colors.white.withValues(alpha: 0.75),
          height: 1.5,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx),
          child: Text(
            MaterialLocalizations.of(ctx).okButtonLabel,
            style: GoogleFonts.spaceMono(
              color: AppTheme.primaryColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
