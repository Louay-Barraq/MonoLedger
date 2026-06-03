import '../../../../core/localization/app_locale.dart';

abstract interface class SettingsRepository {
  Future<AppLocale> getSavedLocale();
  Future<void> saveLocale(AppLocale locale);
  Future<bool> getHapticsEnabled();
  Future<void> setHapticsEnabled(bool value);
}
