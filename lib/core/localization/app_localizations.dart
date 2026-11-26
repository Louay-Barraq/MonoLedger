import 'package:flutter/material.dart';
import 'app_locale.dart';

/// Central string catalog. English is complete; other locales fall back to English
/// until translations are added in [_localizedValues].
class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  String _t(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ?? _localizedValues['en']![key] ?? key;
  }

  // Settings
  String get settingsTitle => _t('settingsTitle');
  String get settingsLanguage => _t('settingsLanguage');
  String get settingsHelp => _t('settingsHelp');
  String get settingsHelpSubtitle => _t('settingsHelpSubtitle');
  String get settingsAbout => _t('settingsAbout');
  String get settingsAboutSubtitle => _t('settingsAboutSubtitle');
  String get settingsHaptics => _t('settingsHaptics');
  String get settingsHapticsSubtitle => _t('settingsHapticsSubtitle');
  String get settingsVersion => _t('settingsVersion');
  String get settingsSectionGeneral => _t('settingsSectionGeneral');
  String get settingsSectionSupport => _t('settingsSectionSupport');

  // Help
  String get helpTitle => _t('helpTitle');
  String get helpIntro => _t('helpIntro');

  // About
  String get aboutTitle => _t('aboutTitle');
  String get aboutAppHeading => _t('aboutAppHeading');
  String get aboutAppBody => _t('aboutAppBody');
  String get aboutDeveloperHeading => _t('aboutDeveloperHeading');
  String get aboutDeveloperBody => _t('aboutDeveloperBody');

  // Home (sample wired strings — expand as translations are added)
  String get homeCreateSession => _t('homeCreateSession');
  String get homeJoinSession => _t('homeJoinSession');
  String get homeTagline => _t('homeTagline');
  String get homeFooter => _t('homeFooter');
  String get homeCapacity => _t('homeCapacity');
  String get homeSyncing => _t('homeSyncing');
  String get homeCapacityValue => _t('homeCapacityValue');
  String get homeSyncingValue => _t('homeSyncingValue');

  List<FaqEntry> get faqEntries =>
      FaqContent.forLanguageCode(locale.languageCode);
}

class FaqEntry {
  final String question;
  final String answer;

  const FaqEntry({required this.question, required this.answer});
}

/// FAQ copy per language. English only for now; others reuse English.
class FaqContent {
  static List<FaqEntry> forLanguageCode(String code) {
    return _faqs[code] ?? _faqs['en']!;
  }

  static const _faqs = {
    'en': [
      FaqEntry(
        question: 'What is MonoLedger?',
        answer:
            'MonoLedger is a digital cash manager for board-game nights. It replaces physical bills with live balances, a shared ledger, and slide-to-pay transfers.',
      ),
      FaqEntry(
        question: 'How do I create a session?',
        answer:
            'From the home screen, tap Create Session, set starting capital and GO amount, enter your name, and share the 6-character code or QR with friends.',
      ),
      FaqEntry(
        question: 'How do I join a session?',
        answer:
            'Tap Join Session, then enter the code manually or scan the host\'s QR code. Enter your display name and confirm.',
      ),
      FaqEntry(
        question: 'What is the Banker?',
        answer:
            'The Banker is the session host who can end the game, kick players, transfer the Banker role, and approve GO salary requests from other players.',
      ),
      FaqEntry(
        question: 'How does GO salary work?',
        answer:
            'When you pass GO, tap Collect Salary on the wallet tab. Non-bankers send a request; the Banker approves or declines from an on-screen prompt. The Banker collects instantly.',
      ),
      FaqEntry(
        question: 'Can I leave and rejoin?',
        answer:
            'Yes. If you leave voluntarily, you can rejoin the same session with the code. You keep the balance you had when you left.',
      ),
      FaqEntry(
        question: 'What happens if I am kicked?',
        answer:
            'You are removed from the active player list and cannot rejoin that session. You will see a notification and return to the home screen.',
      ),
      FaqEntry(
        question: 'Is my data stored online?',
        answer:
            'Sessions, balances, and transactions are stored in Supabase and sync in real time for all players in the session. Use session codes only with people you trust.',
      ),
      FaqEntry(
        question: 'Which games is it for?',
        answer:
            'MonoLedger works with any board game that uses play money. The defaults (1,500 to start, 200 for passing GO) suit classic property-trading games.',
      ),
      FaqEntry(
        question: 'Who built MonoLedger?',
        answer:
            'MonoLedger was designed and developed by Louay Barraq. See Settings → About for more.',
      ),
    ],
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocale.values.any((l) => l.code == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

const Map<String, Map<String, String>> _localizedValues = {
  'en': {
    'settingsTitle': 'SETTINGS',
    'settingsLanguage': 'Language',
    'settingsHelp': 'Help & FAQ',
    'settingsHelpSubtitle': 'Common questions and answers',
    'settingsAbout': 'About',
    'settingsAboutSubtitle': 'App info and developer',
    'settingsHaptics': 'Haptic feedback',
    'settingsHapticsSubtitle': 'Vibration on slide-to-pay',
    'settingsVersion': 'Version',
    'settingsSectionGeneral': 'GENERAL',
    'settingsSectionSupport': 'SUPPORT',
    'helpTitle': 'HELP & FAQ',
    'helpIntro': 'Quick answers about sessions, payments, and roles.',
    'aboutTitle': 'ABOUT',
    'aboutAppHeading': 'MonoLedger',
    'aboutAppBody':
        'MonoLedger turns board-game night into a seamless digital ledger. Host or join a session, track balances in real time, pay the bank or other players with a tactile slide-to-confirm flow, and review every move in a shared transaction history.',
    'aboutDeveloperHeading': 'Developer',
    'aboutDeveloperBody':
        'MonoLedger was created by Louay Barraq — focused on clean, fast tooling for game nights with friends and family.',
    'homeCreateSession': 'CREATE SESSION',
    'homeJoinSession': 'JOIN SESSION',
    'homeTagline': 'DIGITAL CURRENCY FOR BOARD GAMES',
    'homeFooter':
        'Supports 2-10 players.\nFor any board game\nthat uses play money.',
    'homeCapacity': 'CAPACITY',
    'homeSyncing': 'SYNCING',
    'homeCapacityValue': '2-10 PLAYERS',
    'homeSyncingValue': 'REAL-TIME',
  },
  'fr': {
    'settingsTitle': 'PARAMÈTRES',
    'settingsLanguage': 'Langue',
    'settingsHelp': 'Aide & FAQ',
    'settingsHelpSubtitle': 'Questions fréquentes',
    'settingsAbout': 'À propos',
    'settingsAboutSubtitle': 'Infos app et développeur',
    'settingsHaptics': 'Retour haptique',
    'settingsHapticsSubtitle': 'Vibration au paiement',
    'settingsVersion': 'Version',
    'settingsSectionGeneral': 'GÉNÉRAL',
    'settingsSectionSupport': 'ASSISTANCE',
    'helpTitle': 'AIDE & FAQ',
    'helpIntro': 'Réponses rapides sur les sessions et paiements.',
    'aboutTitle': 'À PROPOS',
    'aboutAppHeading': 'MonoLedger',
    'aboutAppBody':
        'MonoLedger transforme vos soirées jeux en ledger numérique fluide. Hébergez ou rejoignez une session, suivez les soldes en temps réel et consultez l\'historique partagé.',
    'aboutDeveloperHeading': 'Développeur',
    'aboutDeveloperBody':
        'MonoLedger a été créé par Louay Barraq — des outils rapides et élégants pour vos parties entre amis.',
    'homeCreateSession': 'CRÉER UNE SESSION',
    'homeJoinSession': 'REJOINDRE',
    'homeTagline': 'MONNAIE NUMÉRIQUE POUR JEUX DE SOCIÉTÉ',
    'homeFooter': '2 à 10 joueurs.\nPour tout jeu avec de la fausse monnaie.',
    'homeCapacity': 'CAPACITÉ',
    'homeSyncing': 'SYNC',
    'homeCapacityValue': '2-10 JOUEURS',
    'homeSyncingValue': 'TEMPS RÉEL',
  },
  'de': {
    'settingsTitle': 'EINSTELLUNGEN',
    'settingsLanguage': 'Sprache',
    'settingsHelp': 'Hilfe & FAQ',
    'settingsHelpSubtitle': 'Häufige Fragen',
    'settingsAbout': 'Über',
    'settingsAboutSubtitle': 'App & Entwickler',
    'settingsHaptics': 'Haptisches Feedback',
    'settingsHapticsSubtitle': 'Vibration beim Bezahlen',
    'settingsVersion': 'Version',
    'settingsSectionGeneral': 'ALLGEMEIN',
    'settingsSectionSupport': 'HILFE',
    'helpTitle': 'HILFE & FAQ',
    'helpIntro': 'Kurze Antworten zu Sessions und Zahlungen.',
    'aboutTitle': 'ÜBER',
    'aboutAppHeading': 'MonoLedger',
    'aboutAppBody':
        'MonoLedger macht Brettspielabende digital: Sessions hosten oder beitreten, Guthaben live verfolgen und eine gemeinsame Transaktionshistorie nutzen.',
    'aboutDeveloperHeading': 'Entwickler',
    'aboutDeveloperBody':
        'MonoLedger wurde von Louay Barraq entwickelt — schnelle Tools für Spieleabende mit Freunden.',
    'homeCreateSession': 'SESSION ERSTELLEN',
    'homeJoinSession': 'BEITRETEN',
    'homeTagline': 'DIGITALES GELD FÜR BRETTSPIELE',
    'homeFooter': '2–10 Spieler.\nFür jedes Brettspiel mit Spielgeld.',
    'homeCapacity': 'KAPAZITÄT',
    'homeSyncing': 'SYNC',
    'homeCapacityValue': '2-10 SPIELER',
    'homeSyncingValue': 'Echtzeit',
  },
  'ar': {
    'settingsTitle': 'الإعدادات',
    'settingsLanguage': 'اللغة',
    'settingsHelp': 'المساعدة والأسئلة',
    'settingsHelpSubtitle': 'أسئلة شائعة',
    'settingsAbout': 'حول التطبيق',
    'settingsAboutSubtitle': 'معلومات التطبيق والمطور',
    'settingsHaptics': 'الاهتزاز',
    'settingsHapticsSubtitle': 'اهتزاز عند الدفع',
    'settingsVersion': 'الإصدار',
    'settingsSectionGeneral': 'عام',
    'settingsSectionSupport': 'الدعم',
    'helpTitle': 'المساعدة',
    'helpIntro': 'إجابات سريعة عن الجلسات والمدفوعات.',
    'aboutTitle': 'حول',
    'aboutAppHeading': 'MonoLedger',
    'aboutAppBody':
        'MonoLedger يحول أمسيات الألعاب إلى دفتر حسابات رقمي. استضف جلسة أو انضم، تابع الأرصدة لحظياً، وراجع سجل المعاملات المشترك.',
    'aboutDeveloperHeading': 'المطور',
    'aboutDeveloperBody':
        'طوّر MonoLedger Louay Barraq — أدوات سريعة وأنيقة للعب مع الأصدقاء.',
    'homeCreateSession': 'إنشاء جلسة',
    'homeJoinSession': 'انضمام',
    'homeTagline': 'عملة رقمية لألعاب الطاولة',
    'homeFooter': 'يدعم 2-10 لاعبين.\nلأي لعبة لوحية تستخدم أموال اللعب.',
    'homeCapacity': 'السعة',
    'homeSyncing': 'المزامنة',
    'homeCapacityValue': '2-10 لاعبين',
    'homeSyncingValue': 'فوري',
  },
};
