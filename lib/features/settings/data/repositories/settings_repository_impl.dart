import 'dart:ui' show PlatformDispatcher;

import '../../../../core/localization/app_locale.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_data_source.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  final SettingsLocalDataSource _local;

  SettingsRepositoryImpl(this._local);

  @override
  Future<AppLocale> getSavedLocale() async {
    // No choice saved yet: follow the phone's language if we support it.
    final code =
        await _local.getLanguageCode() ??
        PlatformDispatcher.instance.locale.languageCode;
    return AppLocale.fromCode(code);
  }

  @override
  Future<void> saveLocale(AppLocale locale) {
    return _local.saveLanguageCode(locale.code);
  }

  @override
  Future<bool> getHapticsEnabled() => _local.getHapticsEnabled();

  @override
  Future<void> setHapticsEnabled(bool value) {
    return _local.saveHapticsEnabled(value);
  }
}
