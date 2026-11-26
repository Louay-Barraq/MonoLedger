import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/localization/app_locale.dart';
import 'package:monoledger/core/localization/app_localizations.dart';

void main() {
  test('every offered language has translations and FAQs', () {
    for (final locale in AppLocale.supported) {
      final l10n = lookupAppLocalizations(locale);
      expect(l10n.homeCreateSession, isNotEmpty, reason: locale.languageCode);
      expect(l10n.faqEntries, hasLength(10), reason: locale.languageCode);
      if (locale.languageCode != 'en') {
        final en = lookupAppLocalizations(const Locale('en'));
        expect(
          l10n.homeCreateSession,
          isNot(en.homeCreateSession),
          reason: '${locale.languageCode} is not just English',
        );
      }
    }
  });

  test('message codes translate and unknown codes fall back', () {
    final fr = lookupAppLocalizations(const Locale('fr'));
    expect(fr.message(MessageCode.insufficientFunds), contains('Fonds'));
    expect(fr.message('something-else'), fr.errGeneric);
  });

  test(
    'system memos are shown in the reader language, user memos untouched',
    () {
      final es = lookupAppLocalizations(const Locale('es'));
      expect(es.memo('PASSED GO', 'TRANSFER'), es.memoPassedGo);
      expect(es.memo(null, 'PAY BANK'), es.memoPayBank);
      expect(es.memo('rent', 'TRANSFER'), 'RENT');
    },
  );

  test('Arabic plurals use the right form', () {
    final ar = lookupAppLocalizations(const Locale('ar'));
    expect(ar.summaryPlayerCount(2), 'لاعبان');
    expect(ar.summaryPlayerCount(3), '3 لاعبين');
  });
}
