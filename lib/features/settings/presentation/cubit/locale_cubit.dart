import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/localization/app_locale.dart';
import '../../domain/repositories/settings_repository.dart';

class LocaleState extends Equatable {
  final Locale locale;
  final bool hapticsEnabled;
  final bool loaded;

  const LocaleState({
    required this.locale,
    this.hapticsEnabled = true,
    this.loaded = false,
  });

  AppLocale get appLocale => AppLocale.fromLocale(locale);

  LocaleState copyWith({Locale? locale, bool? hapticsEnabled, bool? loaded}) {
    return LocaleState(
      locale: locale ?? this.locale,
      hapticsEnabled: hapticsEnabled ?? this.hapticsEnabled,
      loaded: loaded ?? this.loaded,
    );
  }

  @override
  List<Object?> get props => [locale, hapticsEnabled, loaded];
}

class LocaleCubit extends Cubit<LocaleState> {
  final SettingsRepository _repository;

  LocaleCubit(this._repository)
    : super(LocaleState(locale: AppLocale.english.locale));

  Future<void> load() async {
    final saved = await _repository.getSavedLocale();
    final haptics = await _repository.getHapticsEnabled();
    emit(
      LocaleState(locale: saved.locale, hapticsEnabled: haptics, loaded: true),
    );
  }

  Future<void> setLocale(AppLocale appLocale) async {
    await _repository.saveLocale(appLocale);
    emit(state.copyWith(locale: appLocale.locale));
  }

  Future<void> setHapticsEnabled(bool enabled) async {
    await _repository.setHapticsEnabled(enabled);
    emit(state.copyWith(hapticsEnabled: enabled));
  }
}
