import 'package:flutter/material.dart';

/// Supported app locales. Add translations in [AppLocalizations] per code.
enum AppLocale {
  english('en', 'English', '🇬🇧'),
  french('fr', 'Français', '🇫🇷'),
  arabic('ar', 'العربية', '🇸🇦'),
  spanish('es', 'Español', '🇪🇸'),
  german('de', 'Deutsch', '🇩🇪');

  final String code;
  final String label;
  final String flag;

  const AppLocale(this.code, this.label, this.flag);

  Locale get locale => Locale(code);

  static List<Locale> get supported =>
      AppLocale.values.map((l) => l.locale).toList();

  static AppLocale fromCode(String? code) {
    return AppLocale.values.firstWhere(
      (l) => l.code == code,
      orElse: () => AppLocale.english,
    );
  }

  static AppLocale fromLocale(Locale locale) => fromCode(locale.languageCode);
}
