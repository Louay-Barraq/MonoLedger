import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalDataSource {
  Future<String?> getLanguageCode();
  Future<void> saveLanguageCode(String code);
  Future<bool> getHapticsEnabled();
  Future<void> saveHapticsEnabled(bool value);
}

class SettingsLocalDataSourceImpl implements SettingsLocalDataSource {
  static const _languageKey = 'app_language_code';
  static const _hapticsKey = 'haptics_enabled';

  final SharedPreferences _prefs;

  SettingsLocalDataSourceImpl(this._prefs);

  @override
  Future<String?> getLanguageCode() async {
    return _prefs.getString(_languageKey);
  }

  @override
  Future<void> saveLanguageCode(String code) async {
    await _prefs.setString(_languageKey, code);
  }

  @override
  Future<bool> getHapticsEnabled() async {
    return _prefs.getBool(_hapticsKey) ?? true;
  }

  @override
  Future<void> saveHapticsEnabled(bool value) async {
    await _prefs.setBool(_hapticsKey, value);
  }
}
