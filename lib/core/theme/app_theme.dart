import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color primaryColor = Color(0xFF14F195);
  static const Color secondaryColor = Color(0xFF00E676);
  static const Color backgroundColor = Color(0xFF0B0D0F);
  static const Color surfaceContainerLow = Color(0xFF111418);
  static const Color surfaceContainerHigh = Color(0xFF1C2026);
  static const Color surfaceBright = Color(0xFF242931);
  static const Color errorColor = Color(0xFFFF5252);

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    colorScheme: const ColorScheme.dark(
      primary: primaryColor,
      secondary: secondaryColor,
      surface: surfaceContainerHigh,
      surfaceContainerLow: surfaceContainerLow,
      surfaceContainerHigh: surfaceContainerHigh,
      onSurface: Colors.white,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme(
      ThemeData.dark().textTheme,
    ).apply(bodyColor: Colors.white, displayColor: Colors.white),
  );
}
