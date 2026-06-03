import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/localization/app_locale.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';
import 'package:monoledger/features/settings/presentation/cubit/locale_cubit.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppTheme.primaryColor, size: 20),
          onPressed: () => context.pop(),
        ),
        title: Text(
          l10n.settingsTitle,
          style: GoogleFonts.spaceMono(
            color: AppTheme.primaryColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _SectionHeader(title: l10n.settingsSectionGeneral),
          const SizedBox(height: 12),
          _LanguageTile(),
          const SizedBox(height: 8),
          _HapticsTile(),
          const SizedBox(height: 32),
          _SectionHeader(title: l10n.settingsSectionSupport),
          const SizedBox(height: 12),
          _SettingsNavTile(
            icon: Icons.help_outline_rounded,
            title: l10n.settingsHelp,
            subtitle: l10n.settingsHelpSubtitle,
            onTap: () => context.push('/settings/help'),
          ),
          const SizedBox(height: 8),
          _SettingsNavTile(
            icon: Icons.info_outline_rounded,
            title: l10n.settingsAbout,
            subtitle: l10n.settingsAboutSubtitle,
            onTap: () => context.push('/settings/about'),
          ),
          const SizedBox(height: 32),
          Center(
            child: Text(
              '${l10n.settingsVersion} 1.0.0',
              style: GoogleFonts.spaceMono(
                color: Colors.white.withValues(alpha: 0.35),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.spaceMono(
        color: Colors.white.withValues(alpha: 0.45),
        fontSize: 11,
        fontWeight: FontWeight.bold,
        letterSpacing: 2,
      ),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              const Icon(Icons.language_rounded, color: AppTheme.primaryColor),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  l10n.settingsLanguage,
                  style: GoogleFonts.plusJakartaSans(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              DropdownButtonHideUnderline(
                child: DropdownButton<AppLocale>(
                  value: state.appLocale,
                  dropdownColor: AppTheme.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                  items: AppLocale.values
                      .map(
                        (locale) => DropdownMenuItem(
                          value: locale,
                          child: Text(
                            '${locale.flag} ${locale.label}',
                            style: GoogleFonts.inter(color: Colors.white),
                          ),
                        ),
                      )
                      .toList(),
                  onChanged: (locale) {
                    if (locale != null) {
                      context.read<LocaleCubit>().setLocale(locale);
                    }
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HapticsTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<LocaleCubit, LocaleState>(
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLow,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: SwitchListTile(
            contentPadding: EdgeInsets.zero,
            activeThumbColor: AppTheme.primaryColor,
            title: Text(
              l10n.settingsHaptics,
              style: GoogleFonts.plusJakartaSans(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              l10n.settingsHapticsSubtitle,
              style: GoogleFonts.inter(
                color: Colors.white.withValues(alpha: 0.45),
                fontSize: 12,
              ),
            ),
            value: state.hapticsEnabled,
            onChanged: (v) => context.read<LocaleCubit>().setHapticsEnabled(v),
          ),
        );
      },
    );
  }
}

class _SettingsNavTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsNavTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppTheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Row(
            children: [
              Icon(icon, color: AppTheme.primaryColor),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.plusJakartaSans(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: GoogleFonts.inter(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: Colors.white.withValues(alpha: 0.35)),
            ],
          ),
        ),
      ),
    );
  }
}
