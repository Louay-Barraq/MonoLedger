// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appName => 'MonoLedger';

  @override
  String get brandMono => 'Mono';

  @override
  String get brandLedger => 'Ledger';

  @override
  String get commonCancel => 'ABBRECHEN';

  @override
  String get commonConfirm => 'BESTÄTIGEN';

  @override
  String get commonDelete => 'LÖSCHEN';

  @override
  String get commonContinue => 'WEITER';

  @override
  String get commonRetry => 'Erneut versuchen';

  @override
  String get commonPlayer => 'Spieler';

  @override
  String get commonUnknown => 'Unbekannt';

  @override
  String get commonBanker => 'BANKIER';

  @override
  String get commonYou => 'DU';

  @override
  String get commonTheBank => 'Die Bank';

  @override
  String get codeCopied => 'Code in die Zwischenablage kopiert';

  @override
  String get settingsTitle => 'EINSTELLUNGEN';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsHelp => 'Hilfe & FAQ';

  @override
  String get settingsHelpSubtitle => 'Häufige Fragen';

  @override
  String get settingsAbout => 'Über';

  @override
  String get settingsAboutSubtitle => 'App & Entwickler';

  @override
  String get settingsHaptics => 'Haptisches Feedback';

  @override
  String get settingsHapticsSubtitle => 'Vibration beim Wischen zum Bezahlen';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsSectionGeneral => 'ALLGEMEIN';

  @override
  String get settingsSectionSupport => 'HILFE';

  @override
  String get settingsSectionPrivacy => 'DATENSCHUTZ';

  @override
  String get settingsPrivacyPolicy => 'Datenschutzerklärung';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Was MonoLedger speichert und warum';

  @override
  String get settingsDeleteData => 'Meine Daten löschen';

  @override
  String get settingsDeleteDataSubtitle => 'Konto und Spielverlauf löschen';

  @override
  String get settingsDeleting => 'Wird gelöscht…';

  @override
  String get deleteDataTitle => 'Meine Daten löschen?';

  @override
  String get deleteDataBody =>
      'Dein MonoLedger-Konto, dein Profil und dein Spielverlauf werden gelöscht. Du verlässt laufende Spiele. In Spielen mit anderen bleiben deine Einträge als „Gelöschter Spieler“ erhalten, damit deren Abrechnung stimmt. Das kann nicht rückgängig gemacht werden.';

  @override
  String get deleteDataFailed =>
      'Daten konnten nicht gelöscht werden. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get authInitFailed =>
      'MonoLedger konnte nicht starten. Prüfe deine Verbindung und versuche es erneut.';

  @override
  String get helpTitle => 'HILFE & FAQ';

  @override
  String get helpIntro => 'Kurze Antworten zu Spielen, Zahlungen und Rollen.';

  @override
  String get aboutTitle => 'ÜBER';

  @override
  String get aboutAppHeading => 'MonoLedger';

  @override
  String get aboutAppBody =>
      'MonoLedger macht deinen Spieleabend digital: Erstelle oder tritt einer Runde bei, verfolge Guthaben live, bezahle Bank oder Mitspieler per Wischen und prüfe jede Buchung im gemeinsamen Verlauf.';

  @override
  String get aboutDeveloperHeading => 'Entwickler';

  @override
  String get aboutDeveloperBody =>
      'MonoLedger wurde von Louay Barraq entwickelt – für schnelle, einfache Spieleabende mit Freunden und Familie.';

  @override
  String get faqQ1 => 'Was ist MonoLedger?';

  @override
  String get faqA1 =>
      'MonoLedger verwaltet das Geld deiner Brettspielabende. Statt Scheinen gibt es Live-Guthaben, einen gemeinsamen Verlauf und Zahlungen per Wischen.';

  @override
  String get faqQ2 => 'Wie erstelle ich eine Runde?';

  @override
  String get faqA2 =>
      'Tippe auf dem Startbildschirm auf Runde erstellen, wähle Startkapital und Los-Betrag, gib deinen Namen ein und teile den 6-stelligen Code oder QR-Code.';

  @override
  String get faqQ3 => 'Wie trete ich einer Runde bei?';

  @override
  String get faqA3 =>
      'Tippe auf Beitreten und gib den Code ein oder scanne den QR-Code des Gastgebers. Gib deinen Namen ein und bestätige.';

  @override
  String get faqQ4 => 'Was macht der Bankier?';

  @override
  String get faqA4 =>
      'Der Bankier leitet die Runde. Er kann das Spiel beenden, Spieler entfernen, die Rolle weitergeben, Los-Gehälter genehmigen, aus der Bank zahlen und eine Fehlbuchung stornieren.';

  @override
  String get faqQ5 => 'Wie funktioniert das Los-Gehalt?';

  @override
  String get faqA5 =>
      'Wenn du über Los ziehst, tippe im Tab Geldbörse auf Gehalt kassieren. Mitspieler senden eine Anfrage, die der Bankier annimmt oder ablehnt; der Bankier erhält es sofort.';

  @override
  String get faqQ6 => 'Kann ich gehen und wiederkommen?';

  @override
  String get faqA6 =>
      'Ja. Du kannst mit dem Code derselben Runde zurückkehren und behältst dein Guthaben.';

  @override
  String get faqQ7 => 'Was passiert, wenn ich entfernt werde?';

  @override
  String get faqA7 =>
      'Du verschwindest aus der Spielerliste und kannst der Runde nicht mehr beitreten. Du erhältst einen Hinweis und kehrst zum Start zurück.';

  @override
  String get faqQ8 => 'Kann man eine Zahlung rückgängig machen?';

  @override
  String get faqA8 =>
      'Ja. Der Bankier kann einen Eintrag lange antippen und ihn einmal stornieren. Die Stornierung ist für alle sichtbar.';

  @override
  String get faqQ9 => 'Werden meine Daten online gespeichert?';

  @override
  String get faqA9 =>
      'Runden, Guthaben und Zahlungen werden online gespeichert, damit alle sie live sehen. Du kannst deine Daten jederzeit in den Einstellungen löschen.';

  @override
  String get faqQ10 => 'Für welche Spiele?';

  @override
  String get faqA10 =>
      'Für jedes Brettspiel mit Spielgeld. Die Standardwerte (1.500 zum Start, 200 beim Ziehen über Los) passen zu klassischen Immobilienspielen.';

  @override
  String get homeCreateSession => 'RUNDE ERSTELLEN';

  @override
  String get homeJoinSession => 'BEITRETEN';

  @override
  String get homeTagline => 'DIGITALES GELD FÜR BRETTSPIELE';

  @override
  String get homeFooter =>
      '2 bis 10 Spieler.\nFür jedes Brettspiel\nmit Spielgeld.';

  @override
  String get homeCapacity => 'KAPAZITÄT';

  @override
  String get homeSyncing => 'SYNCHRON';

  @override
  String get homeCapacityValue => '2-10 SPIELER';

  @override
  String get homeSyncingValue => 'LIVE';

  @override
  String get homePastGames => 'Frühere Spiele';

  @override
  String get onboardingTitle1 => 'WILLKOMMEN BEI\nMONOLEDGER';

  @override
  String get onboardingBody1 =>
      'Das Spielgeld deiner Lieblingsspiele auf jedem Handy.';

  @override
  String get onboardingTitle2 => 'LIVE\nSYNCHRON';

  @override
  String get onboardingBody2 =>
      'Alle bleiben live auf dem neuesten Stand. Schluss mit Kopfrechnen und Scheinchaos.';

  @override
  String get onboardingTitle3 => 'SICHER &\nPRIVAT';

  @override
  String get onboardingBody3 =>
      'Zahlungen laufen über verschlüsselte Verbindungen. Konzentriere dich aufs Spiel, wir rechnen.';

  @override
  String get onboardingStart => 'LOSLEGEN';

  @override
  String get createHeader => 'EINRICHTUNG';

  @override
  String get createTitle => 'Runde erstellen';

  @override
  String get createSubtitle => 'Lege die Geldregeln deines Spiels fest.';

  @override
  String get createYourName => 'DEIN NAME';

  @override
  String get createNameHint => 'Name des Bankiers';

  @override
  String get createCurrency => 'WÄHRUNGSZEICHEN';

  @override
  String get createStartingCapital => 'STARTKAPITAL';

  @override
  String get createPresetStandard => 'STANDARD';

  @override
  String get createPresetPro => 'PROFI';

  @override
  String get createPresetCapitalist => 'KAPITALIST';

  @override
  String get createPresetWhale => 'GROSSVERDIENER';

  @override
  String get createEnterAmount => 'BETRAG EINGEBEN';

  @override
  String get createCustomAmount => 'EIGENER BETRAG';

  @override
  String get createGoAmount => 'LOS-BETRAG';

  @override
  String get createNameRequired => 'Gib deinen Namen ein, um fortzufahren.';

  @override
  String get createCapitalInvalid => 'Das Startkapital muss größer als 0 sein.';

  @override
  String get createGoInvalid => 'Der Los-Betrag darf nicht negativ sein.';

  @override
  String get createSubmit => 'ERSTELLEN & STARTEN';

  @override
  String get joinHeader => 'VERBINDUNG';

  @override
  String get joinTitle => 'Runde beitreten';

  @override
  String get joinSubtitle =>
      'Gib den Code ein oder scanne den QR-Code des Gastgebers.';

  @override
  String get joinEnterCode => 'CODE EINGEBEN';

  @override
  String get joinEnterCodeSubtitle => '6-stelligen Code eintippen';

  @override
  String get joinScanQr => 'QR-CODE SCANNEN';

  @override
  String get joinScanQrSubtitle => 'Mit der Kamera scannen';

  @override
  String get joinCodeHeader => 'RUNDEN-CODE';

  @override
  String get joinCodeTitle => 'Code eingeben';

  @override
  String get joinCodeSubtitle =>
      'Gib den 6-stelligen Code und deinen Namen ein.';

  @override
  String get joinCodeLabel => 'RUNDEN-CODE';

  @override
  String get joinNameLabel => 'DEIN NAME';

  @override
  String get joinNameHint => 'Name';

  @override
  String get joinCodeInvalid => 'Gib einen gültigen 6-stelligen Code ein.';

  @override
  String get joinNameRequired => 'Gib deinen Namen ein.';

  @override
  String get joinConfirm => 'BEITRETEN';

  @override
  String get scanTitle => 'QR SCANNEN';

  @override
  String get scanHint => 'Richte die Kamera auf den QR-Code des Gastgebers';

  @override
  String get dashboardRoomCode => 'RAUMCODE';

  @override
  String get navWallet => 'BÖRSE';

  @override
  String get navLedger => 'VERLAUF';

  @override
  String get navPlayers => 'SPIELER';

  @override
  String get leaveTitle => 'Runde verlassen?';

  @override
  String get leaveBodyBanker =>
      'Als Bankier geht deine Rolle samt Leitung zufällig an einen anderen Spieler. Fortfahren?';

  @override
  String get leaveBodyLast =>
      'Du bist der einzige Spieler. Verlassen beendet die Runde für alle. Fortfahren?';

  @override
  String get leaveBody =>
      'Du verlässt diese Runde und kehrst zum Start zurück. Fortfahren?';

  @override
  String get leaveAction => 'VERLASSEN';

  @override
  String get walletCurrentBalance => 'AKTUELLES GUTHABEN';

  @override
  String walletVsStart(String change) {
    return '$change% seit Start';
  }

  @override
  String get walletGo => 'LOS';

  @override
  String get walletCollectSalary => 'GEHALT KASSIEREN';

  @override
  String get walletAwaitingBanker => 'WARTET AUF BANKIER';

  @override
  String get walletPayBank => 'AN DIE BANK';

  @override
  String get walletFromBank => 'VON DER BANK';

  @override
  String get walletPlayers => 'Spieler';

  @override
  String walletActiveCount(int count) {
    return '$count AKTIV';
  }

  @override
  String get walletNoPlayers => 'Noch keine Spieler in der Runde';

  @override
  String get walletTapToPay => 'ZUM BEZAHLEN TIPPEN';

  @override
  String walletRank(int rank) {
    return 'PLATZ $rank';
  }

  @override
  String get ledgerTitle => 'Verlauf';

  @override
  String get ledgerSubtitle => 'Alle Buchungen der Runde';

  @override
  String get ledgerEmpty => 'Noch keine Buchungen';

  @override
  String get ledgerFromBank => 'Von der Bank';

  @override
  String get ledgerToBank => 'An die Bank';

  @override
  String get ledgerReversed => 'STORNIERT';

  @override
  String get ledgerJustNow => 'Gerade eben';

  @override
  String ledgerMinutesAgo(int minutes) {
    return 'vor $minutes Min.';
  }

  @override
  String ledgerHoursAgo(int hours) {
    return 'vor $hours Std.';
  }

  @override
  String ledgerDaysAgo(int days) {
    return 'vor $days T.';
  }

  @override
  String get memoPassedGo => 'ÜBER LOS';

  @override
  String get memoFromBank => 'VON DER BANK';

  @override
  String get memoPayBank => 'AN DIE BANK';

  @override
  String get memoTransfer => 'ÜBERWEISUNG';

  @override
  String get memoPayment => 'ZAHLUNG';

  @override
  String get memoReversal => 'STORNO';

  @override
  String get reverseTitle => 'Buchung stornieren?';

  @override
  String reverseBody(String title, String amount) {
    return '$title ($amount) wird durch eine Gegenbuchung im Verlauf aufgehoben. Das geht nur einmal.';
  }

  @override
  String get reverseAction => 'STORNIEREN';

  @override
  String get playersTitle => 'SPIELER';

  @override
  String get playersNone => 'Keine aktiven Spieler';

  @override
  String get playersBankCard => 'DIE BANK';

  @override
  String playersBankerName(String name) {
    return 'Bankier: $name';
  }

  @override
  String get padPayingTo => 'ZAHLUNG AN';

  @override
  String get padReceivingFrom => 'ERHALT VON';

  @override
  String get padSlideToPay => 'ZUM ZAHLEN WISCHEN';

  @override
  String get padSlideToReceive => 'ZUM ERHALTEN WISCHEN';

  @override
  String get padProcessing => 'WIRD AUSGEFÜHRT...';

  @override
  String get padLargePayoutTitle => 'Große Auszahlung der Bank';

  @override
  String padLargePayoutBody(String amount) {
    return 'Diese Auszahlung ($amount) ist mehr als die Hälfte des gesamten Spielgelds. Zum Fortfahren bestätigen.';
  }

  @override
  String get goPassed => 'ÜBER LOS';

  @override
  String get goDecline => 'ABLEHNEN';

  @override
  String get goApprove => 'ANNEHMEN';

  @override
  String get settingsGameTitle => 'SPIELEINSTELLUNGEN';

  @override
  String get settingsGameRules => 'GELDREGELN';

  @override
  String get settingsGamePlayers => 'AKTIVE SPIELER';

  @override
  String get settingsGameManagement => 'SPIELVERWALTUNG';

  @override
  String get settingsGameExit => 'VERLASSEN';

  @override
  String get settingsGameSessionCode => 'RUNDEN-CODE';

  @override
  String get settingsGameStartingCapital => 'Startkapital';

  @override
  String get settingsGameGoBonus => 'Los-Bonus';

  @override
  String get settingsGameTransferTooltip => 'Zum Bankier machen';

  @override
  String get settingsGameKickTooltip => 'Spieler entfernen';

  @override
  String get settingsGameLeave => 'RUNDE VERLASSEN';

  @override
  String get settingsGameEnd => 'RUNDE BEENDEN';

  @override
  String transferTitle(String name) {
    return '$name zum Bankier machen?';
  }

  @override
  String transferBody(String name) {
    return '$name wird Bankier und Gastgeber. Du verlierst die Bankier-Funktionen.';
  }

  @override
  String get transferAction => 'ÜBERTRAGEN';

  @override
  String transferDone(String name) {
    return '$name ist jetzt Bankier und Gastgeber.';
  }

  @override
  String get kickTitle => 'Spieler entfernen?';

  @override
  String kickBody(String name) {
    return 'Möchtest du $name wirklich aus der Runde entfernen?';
  }

  @override
  String get kickAction => 'ENTFERNEN';

  @override
  String kickDone(String name) {
    return '$name wurde aus der Runde entfernt.';
  }

  @override
  String get endTitle => 'Runde beenden?';

  @override
  String get endBody =>
      'Das Spiel endet für alle endgültig und die Zusammenfassung wird gezeigt.';

  @override
  String get endAction => 'BEENDEN';

  @override
  String get removedTitle => 'Aus dem Spiel entfernt';

  @override
  String get removedBody =>
      'Der Bankier hat dich aus dieser Runde entfernt. Du kannst über den Startbildschirm einer anderen beitreten.';

  @override
  String get summaryChampion => 'GROSSER SIEGER';

  @override
  String get summaryAnalytics => 'STATISTIK';

  @override
  String get summaryStandings => 'ENDSTAND';

  @override
  String get summaryMoneyInPlay => 'Geld im Spiel';

  @override
  String get summaryParticipants => 'Teilnehmer';

  @override
  String summaryPlayerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Spieler',
      one: '1 Spieler',
    );
    return '$_temp0';
  }

  @override
  String get summarySaveExit => 'SPEICHERN & BEENDEN';

  @override
  String get summaryVolume => 'Umsatz';

  @override
  String get summaryLength => 'Spieldauer';

  @override
  String summaryHoursMinutes(int hours, int minutes) {
    return '$hours Std. $minutes Min.';
  }

  @override
  String summaryMinutes(int minutes) {
    return '$minutes Min.';
  }

  @override
  String get summaryGoCollected => 'Los-Gehälter';

  @override
  String summaryTimes(int count) {
    return '$count×';
  }

  @override
  String get summaryBiggestEarner => 'Größter Gewinn';

  @override
  String get summaryBiggestSpender => 'Größte Ausgaben';

  @override
  String get summaryMostActive => 'Am aktivsten';

  @override
  String summaryMoves(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Züge',
      one: '1 Zug',
    );
    return '$name · $_temp0';
  }

  @override
  String get historyTitle => 'FRÜHERE SPIELE';

  @override
  String get historyLoadFailed =>
      'Spiele konnten nicht geladen werden. Zum Wiederholen tippen.';

  @override
  String get historyEmpty => 'Beendete Spiele erscheinen hier.';

  @override
  String get historyGames => 'SPIELE';

  @override
  String get historyWins => 'SIEGE';

  @override
  String get historyAsBanker => 'ALS BANKIER';

  @override
  String historyBankerTag(String name) {
    return '$name • BANKIER';
  }

  @override
  String get qrJoinCode => 'BEITRITTSCODE';

  @override
  String get qrCopyCode => 'CODE KOPIEREN';

  @override
  String get txTransferDone => 'Zahlung gesendet';

  @override
  String get txPaidBank => 'An die Bank gezahlt';

  @override
  String get txReceivedBank => 'Von der Bank erhalten';

  @override
  String get txReversed => 'Buchung storniert';

  @override
  String get goCollected => 'Los-Gehalt erhalten';

  @override
  String get goWaiting => 'Warten auf Zustimmung des Bankiers…';

  @override
  String get goApproved => 'Anfrage angenommen';

  @override
  String get goDeclined => 'Anfrage abgelehnt';

  @override
  String get errInsufficientFunds => 'Nicht genug Guthaben für diese Zahlung.';

  @override
  String get errSessionClosed => 'Diese Runde ist nicht mehr aktiv.';

  @override
  String get errNotInSession => 'Du bist kein aktives Mitglied dieser Runde.';

  @override
  String get errCannotPaySelf => 'Du kannst dir nicht selbst Geld zahlen.';

  @override
  String get errRecipientNotFound =>
      'Dieser Spieler ist nicht mehr in der Runde.';

  @override
  String get errAlreadyReversed => 'Diese Buchung wurde bereits storniert.';

  @override
  String get errCannotReverseReversal =>
      'Eine Stornierung kann nicht storniert werden.';

  @override
  String get errOnlyBanker => 'Das kann nur der Bankier.';

  @override
  String get errGoPending => 'Du hast bereits eine offene Anfrage.';

  @override
  String get errInvalidSession =>
      'Ungültiger Rundencode. Bitte prüfen und erneut versuchen.';

  @override
  String get errKicked =>
      'Du wurdest entfernt und kannst nicht erneut beitreten.';

  @override
  String get errRejoin => 'Wiederbeitritt nicht möglich.';

  @override
  String get errNetwork => 'Netzwerkfehler. Prüfe deine Verbindung.';

  @override
  String get errSessionNotFound =>
      'Runde nicht gefunden. Tritt über den Start erneut bei.';

  @override
  String get errGeneric =>
      'Etwas ist schiefgelaufen. Bitte versuche es erneut.';
}
