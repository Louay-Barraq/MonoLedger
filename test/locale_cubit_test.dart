import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:monoledger/core/localization/app_locale.dart';
import 'package:monoledger/features/settings/domain/repositories/settings_repository.dart';
import 'package:monoledger/features/settings/presentation/cubit/locale_cubit.dart';

class MockSettingsRepository extends Mock implements SettingsRepository {}

void main() {
  late MockSettingsRepository repository;

  setUpAll(() {
    registerFallbackValue(AppLocale.english);
  });

  setUp(() {
    repository = MockSettingsRepository();
    when(() => repository.getSavedLocale())
        .thenAnswer((_) async => AppLocale.english);
    when(() => repository.getHapticsEnabled()).thenAnswer((_) async => true);
    when(() => repository.saveLocale(any())).thenAnswer((_) async {});
    when(() => repository.setHapticsEnabled(any())).thenAnswer((_) async {});
  });

  blocTest<LocaleCubit, LocaleState>(
    'load emits saved locale and haptics preference',
    build: () => LocaleCubit(repository),
    act: (cubit) => cubit.load(),
    expect: () => [
      LocaleState(
        locale: AppLocale.french.locale,
        hapticsEnabled: true,
        loaded: true,
      ),
    ],
    setUp: () {
      when(() => repository.getSavedLocale())
          .thenAnswer((_) async => AppLocale.french);
    },
  );

  blocTest<LocaleCubit, LocaleState>(
    'setLocale persists and updates state',
    build: () => LocaleCubit(repository),
    seed: () => LocaleState(locale: AppLocale.english.locale, loaded: true),
    act: (cubit) => cubit.setLocale(AppLocale.arabic),
    expect: () => [
      LocaleState(locale: AppLocale.arabic.locale, loaded: true),
    ],
    verify: (_) {
      verify(() => repository.saveLocale(AppLocale.arabic)).called(1);
    },
  );
}
