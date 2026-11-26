import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'MonoLedger'**
  String get appName;

  /// No description provided for @brandMono.
  ///
  /// In en, this message translates to:
  /// **'Mono'**
  String get brandMono;

  /// No description provided for @brandLedger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get brandLedger;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM'**
  String get commonConfirm;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'DELETE'**
  String get commonDelete;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'CONTINUE'**
  String get commonContinue;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonPlayer.
  ///
  /// In en, this message translates to:
  /// **'Player'**
  String get commonPlayer;

  /// No description provided for @commonUnknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get commonUnknown;

  /// No description provided for @commonBanker.
  ///
  /// In en, this message translates to:
  /// **'BANKER'**
  String get commonBanker;

  /// No description provided for @commonYou.
  ///
  /// In en, this message translates to:
  /// **'YOU'**
  String get commonYou;

  /// No description provided for @commonTheBank.
  ///
  /// In en, this message translates to:
  /// **'The Bank'**
  String get commonTheBank;

  /// No description provided for @codeCopied.
  ///
  /// In en, this message translates to:
  /// **'Code copied to clipboard'**
  String get codeCopied;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'SETTINGS'**
  String get settingsTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & FAQ'**
  String get settingsHelp;

  /// No description provided for @settingsHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Common questions and answers'**
  String get settingsHelpSubtitle;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsAboutSubtitle.
  ///
  /// In en, this message translates to:
  /// **'App info and developer'**
  String get settingsAboutSubtitle;

  /// No description provided for @settingsHaptics.
  ///
  /// In en, this message translates to:
  /// **'Haptic feedback'**
  String get settingsHaptics;

  /// No description provided for @settingsHapticsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Vibration on slide-to-pay'**
  String get settingsHapticsSubtitle;

  /// No description provided for @settingsVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String settingsVersion(String version);

  /// No description provided for @settingsSectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'GENERAL'**
  String get settingsSectionGeneral;

  /// No description provided for @settingsSectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get settingsSectionSupport;

  /// No description provided for @settingsSectionPrivacy.
  ///
  /// In en, this message translates to:
  /// **'PRIVACY'**
  String get settingsSectionPrivacy;

  /// No description provided for @settingsPrivacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get settingsPrivacyPolicy;

  /// No description provided for @settingsPrivacyPolicySubtitle.
  ///
  /// In en, this message translates to:
  /// **'What MonoLedger stores and why'**
  String get settingsPrivacyPolicySubtitle;

  /// No description provided for @settingsDeleteData.
  ///
  /// In en, this message translates to:
  /// **'Delete my data'**
  String get settingsDeleteData;

  /// No description provided for @settingsDeleteDataSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Delete your account and game history'**
  String get settingsDeleteDataSubtitle;

  /// No description provided for @settingsDeleting.
  ///
  /// In en, this message translates to:
  /// **'Deleting…'**
  String get settingsDeleting;

  /// No description provided for @deleteDataTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete my data?'**
  String get deleteDataTitle;

  /// No description provided for @deleteDataBody.
  ///
  /// In en, this message translates to:
  /// **'This deletes your MonoLedger account, your profile and your game history. You leave any game you are in. In games other people played with you, your entries stay as \"Deleted player\" so their ledgers still add up. This cannot be undone.'**
  String get deleteDataBody;

  /// No description provided for @deleteDataFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not delete your data. Check your connection and try again.'**
  String get deleteDataFailed;

  /// No description provided for @authInitFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not start MonoLedger. Check your connection and try again.'**
  String get authInitFailed;

  /// No description provided for @helpTitle.
  ///
  /// In en, this message translates to:
  /// **'HELP & FAQ'**
  String get helpTitle;

  /// No description provided for @helpIntro.
  ///
  /// In en, this message translates to:
  /// **'Quick answers about sessions, payments, and roles.'**
  String get helpIntro;

  /// No description provided for @aboutTitle.
  ///
  /// In en, this message translates to:
  /// **'ABOUT'**
  String get aboutTitle;

  /// No description provided for @aboutAppHeading.
  ///
  /// In en, this message translates to:
  /// **'MonoLedger'**
  String get aboutAppHeading;

  /// No description provided for @aboutAppBody.
  ///
  /// In en, this message translates to:
  /// **'MonoLedger turns board-game night into a seamless digital ledger. Host or join a session, track balances in real time, pay the bank or other players with a tactile slide-to-confirm flow, and review every move in a shared transaction history.'**
  String get aboutAppBody;

  /// No description provided for @aboutDeveloperHeading.
  ///
  /// In en, this message translates to:
  /// **'Developer'**
  String get aboutDeveloperHeading;

  /// No description provided for @aboutDeveloperBody.
  ///
  /// In en, this message translates to:
  /// **'MonoLedger was created by Louay Barraq — focused on clean, fast tooling for game nights with friends and family.'**
  String get aboutDeveloperBody;

  /// No description provided for @faqQ1.
  ///
  /// In en, this message translates to:
  /// **'What is MonoLedger?'**
  String get faqQ1;

  /// No description provided for @faqA1.
  ///
  /// In en, this message translates to:
  /// **'MonoLedger is a digital cash manager for board-game nights. It replaces physical bills with live balances, a shared ledger, and slide-to-pay transfers.'**
  String get faqA1;

  /// No description provided for @faqQ2.
  ///
  /// In en, this message translates to:
  /// **'How do I create a session?'**
  String get faqQ2;

  /// No description provided for @faqA2.
  ///
  /// In en, this message translates to:
  /// **'From the home screen, tap Create Session, set the starting capital and GO amount, enter your name, and share the 6-character code or QR code with friends.'**
  String get faqA2;

  /// No description provided for @faqQ3.
  ///
  /// In en, this message translates to:
  /// **'How do I join a session?'**
  String get faqQ3;

  /// No description provided for @faqA3.
  ///
  /// In en, this message translates to:
  /// **'Tap Join Session, then enter the code or scan the host\'s QR code. Enter your display name and confirm.'**
  String get faqA3;

  /// No description provided for @faqQ4.
  ///
  /// In en, this message translates to:
  /// **'What is the Banker?'**
  String get faqQ4;

  /// No description provided for @faqA4.
  ///
  /// In en, this message translates to:
  /// **'The Banker hosts the session. They can end the game, remove players, pass the Banker role on, approve GO salary requests, pay out from the bank and undo a mistaken payment.'**
  String get faqA4;

  /// No description provided for @faqQ5.
  ///
  /// In en, this message translates to:
  /// **'How does GO salary work?'**
  String get faqQ5;

  /// No description provided for @faqA5.
  ///
  /// In en, this message translates to:
  /// **'When you pass GO, tap Collect Salary on the wallet tab. Other players send a request that the Banker approves or declines; the Banker collects instantly.'**
  String get faqA5;

  /// No description provided for @faqQ6.
  ///
  /// In en, this message translates to:
  /// **'Can I leave and rejoin?'**
  String get faqQ6;

  /// No description provided for @faqA6.
  ///
  /// In en, this message translates to:
  /// **'Yes. If you leave, you can rejoin the same session with its code and you keep the balance you had when you left.'**
  String get faqA6;

  /// No description provided for @faqQ7.
  ///
  /// In en, this message translates to:
  /// **'What happens if I am removed?'**
  String get faqQ7;

  /// No description provided for @faqA7.
  ///
  /// In en, this message translates to:
  /// **'You leave the player list and cannot rejoin that session. You\'ll see a notice and return to the home screen.'**
  String get faqA7;

  /// No description provided for @faqQ8.
  ///
  /// In en, this message translates to:
  /// **'Can a payment be undone?'**
  String get faqQ8;

  /// No description provided for @faqA8.
  ///
  /// In en, this message translates to:
  /// **'Yes. The Banker can long-press any entry in the ledger to reverse it once. The reversal appears as its own entry so everyone can see it.'**
  String get faqA8;

  /// No description provided for @faqQ9.
  ///
  /// In en, this message translates to:
  /// **'Is my data stored online?'**
  String get faqQ9;

  /// No description provided for @faqA9.
  ///
  /// In en, this message translates to:
  /// **'Sessions, balances and payments are stored online so every player sees them in real time. You can delete your data at any time in Settings.'**
  String get faqA9;

  /// No description provided for @faqQ10.
  ///
  /// In en, this message translates to:
  /// **'Which games is it for?'**
  String get faqQ10;

  /// No description provided for @faqA10.
  ///
  /// In en, this message translates to:
  /// **'Any board game that uses play money. The defaults (1,500 to start, 200 for passing GO) suit classic property-trading games.'**
  String get faqA10;

  /// No description provided for @homeCreateSession.
  ///
  /// In en, this message translates to:
  /// **'CREATE SESSION'**
  String get homeCreateSession;

  /// No description provided for @homeJoinSession.
  ///
  /// In en, this message translates to:
  /// **'JOIN SESSION'**
  String get homeJoinSession;

  /// No description provided for @homeTagline.
  ///
  /// In en, this message translates to:
  /// **'DIGITAL CURRENCY FOR BOARD GAMES'**
  String get homeTagline;

  /// No description provided for @homeFooter.
  ///
  /// In en, this message translates to:
  /// **'Supports 2-10 players.\nFor any board game\nthat uses play money.'**
  String get homeFooter;

  /// No description provided for @homeCapacity.
  ///
  /// In en, this message translates to:
  /// **'CAPACITY'**
  String get homeCapacity;

  /// No description provided for @homeSyncing.
  ///
  /// In en, this message translates to:
  /// **'SYNCING'**
  String get homeSyncing;

  /// No description provided for @homeCapacityValue.
  ///
  /// In en, this message translates to:
  /// **'2-10 PLAYERS'**
  String get homeCapacityValue;

  /// No description provided for @homeSyncingValue.
  ///
  /// In en, this message translates to:
  /// **'REAL-TIME'**
  String get homeSyncingValue;

  /// No description provided for @homePastGames.
  ///
  /// In en, this message translates to:
  /// **'Past games'**
  String get homePastGames;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'WELCOME TO\nMONOLEDGER'**
  String get onboardingTitle1;

  /// No description provided for @onboardingBody1.
  ///
  /// In en, this message translates to:
  /// **'Play money for your favorite board games, on every player\'s phone.'**
  String get onboardingBody1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'REAL-TIME\nSYNCING'**
  String get onboardingTitle2;

  /// No description provided for @onboardingBody2.
  ///
  /// In en, this message translates to:
  /// **'Every player stays in sync with live updates. No more manual calculations or paper money chaos.'**
  String get onboardingBody2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'SECURE &\nPRIVATE'**
  String get onboardingTitle3;

  /// No description provided for @onboardingBody3.
  ///
  /// In en, this message translates to:
  /// **'Payments go through secure, encrypted connections. Focus on the game, we\'ll handle the numbers.'**
  String get onboardingBody3;

  /// No description provided for @onboardingStart.
  ///
  /// In en, this message translates to:
  /// **'START EXPERIENCE'**
  String get onboardingStart;

  /// No description provided for @createHeader.
  ///
  /// In en, this message translates to:
  /// **'INITIAL SETUP'**
  String get createHeader;

  /// No description provided for @createTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Session'**
  String get createTitle;

  /// No description provided for @createSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set the rules for your game\'s money.'**
  String get createSubtitle;

  /// No description provided for @createYourName.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get createYourName;

  /// No description provided for @createNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter banker name'**
  String get createNameHint;

  /// No description provided for @createCurrency.
  ///
  /// In en, this message translates to:
  /// **'CURRENCY SYMBOL'**
  String get createCurrency;

  /// No description provided for @createStartingCapital.
  ///
  /// In en, this message translates to:
  /// **'STARTING CAPITAL'**
  String get createStartingCapital;

  /// No description provided for @createPresetStandard.
  ///
  /// In en, this message translates to:
  /// **'STANDARD START'**
  String get createPresetStandard;

  /// No description provided for @createPresetPro.
  ///
  /// In en, this message translates to:
  /// **'PRO TIER'**
  String get createPresetPro;

  /// No description provided for @createPresetCapitalist.
  ///
  /// In en, this message translates to:
  /// **'CAPITALIST'**
  String get createPresetCapitalist;

  /// No description provided for @createPresetWhale.
  ///
  /// In en, this message translates to:
  /// **'WHALE MODE'**
  String get createPresetWhale;

  /// No description provided for @createEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'ENTER AMOUNT'**
  String get createEnterAmount;

  /// No description provided for @createCustomAmount.
  ///
  /// In en, this message translates to:
  /// **'CUSTOM AMOUNT'**
  String get createCustomAmount;

  /// No description provided for @createGoAmount.
  ///
  /// In en, this message translates to:
  /// **'GO AMOUNT'**
  String get createGoAmount;

  /// No description provided for @createNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name to continue.'**
  String get createNameRequired;

  /// No description provided for @createCapitalInvalid.
  ///
  /// In en, this message translates to:
  /// **'Starting capital must be greater than 0.'**
  String get createCapitalInvalid;

  /// No description provided for @createGoInvalid.
  ///
  /// In en, this message translates to:
  /// **'GO amount cannot be negative.'**
  String get createGoInvalid;

  /// No description provided for @createSubmit.
  ///
  /// In en, this message translates to:
  /// **'CREATE & START'**
  String get createSubmit;

  /// No description provided for @joinHeader.
  ///
  /// In en, this message translates to:
  /// **'CONNECTION'**
  String get joinHeader;

  /// No description provided for @joinTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Session'**
  String get joinTitle;

  /// No description provided for @joinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the session code or scan the host\'s QR code.'**
  String get joinSubtitle;

  /// No description provided for @joinEnterCode.
  ///
  /// In en, this message translates to:
  /// **'ENTER CODE'**
  String get joinEnterCode;

  /// No description provided for @joinEnterCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Type the 6-character code'**
  String get joinEnterCodeSubtitle;

  /// No description provided for @joinScanQr.
  ///
  /// In en, this message translates to:
  /// **'SCAN QR CODE'**
  String get joinScanQr;

  /// No description provided for @joinScanQrSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Use your camera to scan'**
  String get joinScanQrSubtitle;

  /// No description provided for @joinCodeHeader.
  ///
  /// In en, this message translates to:
  /// **'SESSION CODE'**
  String get joinCodeHeader;

  /// No description provided for @joinCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter Code'**
  String get joinCodeTitle;

  /// No description provided for @joinCodeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the 6-character code and your name to join.'**
  String get joinCodeSubtitle;

  /// No description provided for @joinCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'SESSION CODE'**
  String get joinCodeLabel;

  /// No description provided for @joinNameLabel.
  ///
  /// In en, this message translates to:
  /// **'YOUR NAME'**
  String get joinNameLabel;

  /// No description provided for @joinNameHint.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get joinNameHint;

  /// No description provided for @joinCodeInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid 6-character code.'**
  String get joinCodeInvalid;

  /// No description provided for @joinNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name.'**
  String get joinNameRequired;

  /// No description provided for @joinConfirm.
  ///
  /// In en, this message translates to:
  /// **'CONFIRM JOIN'**
  String get joinConfirm;

  /// No description provided for @scanTitle.
  ///
  /// In en, this message translates to:
  /// **'SCAN QR'**
  String get scanTitle;

  /// No description provided for @scanHint.
  ///
  /// In en, this message translates to:
  /// **'Point your camera at the host\'s session QR code'**
  String get scanHint;

  /// No description provided for @dashboardRoomCode.
  ///
  /// In en, this message translates to:
  /// **'ROOM CODE'**
  String get dashboardRoomCode;

  /// No description provided for @navWallet.
  ///
  /// In en, this message translates to:
  /// **'WALLET'**
  String get navWallet;

  /// No description provided for @navLedger.
  ///
  /// In en, this message translates to:
  /// **'LEDGER'**
  String get navLedger;

  /// No description provided for @navPlayers.
  ///
  /// In en, this message translates to:
  /// **'PLAYERS'**
  String get navPlayers;

  /// No description provided for @leaveTitle.
  ///
  /// In en, this message translates to:
  /// **'Leave session?'**
  String get leaveTitle;

  /// No description provided for @leaveBodyBanker.
  ///
  /// In en, this message translates to:
  /// **'As the Banker, leaving passes the Banker role and hosting to another player at random. Continue?'**
  String get leaveBodyBanker;

  /// No description provided for @leaveBodyLast.
  ///
  /// In en, this message translates to:
  /// **'You are the only player. Leaving will end the session for everyone. Continue?'**
  String get leaveBodyLast;

  /// No description provided for @leaveBody.
  ///
  /// In en, this message translates to:
  /// **'You will leave this session and return to the home screen. Continue?'**
  String get leaveBody;

  /// No description provided for @leaveAction.
  ///
  /// In en, this message translates to:
  /// **'LEAVE'**
  String get leaveAction;

  /// No description provided for @walletCurrentBalance.
  ///
  /// In en, this message translates to:
  /// **'CURRENT BALANCE'**
  String get walletCurrentBalance;

  /// No description provided for @walletVsStart.
  ///
  /// In en, this message translates to:
  /// **'{change}% vs START'**
  String walletVsStart(String change);

  /// No description provided for @walletGo.
  ///
  /// In en, this message translates to:
  /// **'GO'**
  String get walletGo;

  /// No description provided for @walletCollectSalary.
  ///
  /// In en, this message translates to:
  /// **'COLLECT SALARY'**
  String get walletCollectSalary;

  /// No description provided for @walletAwaitingBanker.
  ///
  /// In en, this message translates to:
  /// **'AWAITING BANKER'**
  String get walletAwaitingBanker;

  /// No description provided for @walletPayBank.
  ///
  /// In en, this message translates to:
  /// **'PAY BANK'**
  String get walletPayBank;

  /// No description provided for @walletFromBank.
  ///
  /// In en, this message translates to:
  /// **'FROM BANK'**
  String get walletFromBank;

  /// No description provided for @walletPlayers.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get walletPlayers;

  /// No description provided for @walletActiveCount.
  ///
  /// In en, this message translates to:
  /// **'{count} ACTIVE'**
  String walletActiveCount(int count);

  /// No description provided for @walletNoPlayers.
  ///
  /// In en, this message translates to:
  /// **'No players in session yet'**
  String get walletNoPlayers;

  /// No description provided for @walletTapToPay.
  ///
  /// In en, this message translates to:
  /// **'TAP TO PAY'**
  String get walletTapToPay;

  /// No description provided for @walletRank.
  ///
  /// In en, this message translates to:
  /// **'RANK #{rank}'**
  String walletRank(int rank);

  /// No description provided for @ledgerTitle.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledgerTitle;

  /// No description provided for @ledgerSubtitle.
  ///
  /// In en, this message translates to:
  /// **'All session transactions'**
  String get ledgerSubtitle;

  /// No description provided for @ledgerEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get ledgerEmpty;

  /// No description provided for @ledgerFromBank.
  ///
  /// In en, this message translates to:
  /// **'From The Bank'**
  String get ledgerFromBank;

  /// No description provided for @ledgerToBank.
  ///
  /// In en, this message translates to:
  /// **'To The Bank'**
  String get ledgerToBank;

  /// No description provided for @ledgerReversed.
  ///
  /// In en, this message translates to:
  /// **'REVERSED'**
  String get ledgerReversed;

  /// No description provided for @ledgerJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get ledgerJustNow;

  /// No description provided for @ledgerMinutesAgo.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min ago'**
  String ledgerMinutesAgo(int minutes);

  /// No description provided for @ledgerHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{hours} h ago'**
  String ledgerHoursAgo(int hours);

  /// No description provided for @ledgerDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'{days} d ago'**
  String ledgerDaysAgo(int days);

  /// No description provided for @memoPassedGo.
  ///
  /// In en, this message translates to:
  /// **'PASSED GO'**
  String get memoPassedGo;

  /// No description provided for @memoFromBank.
  ///
  /// In en, this message translates to:
  /// **'FROM BANK'**
  String get memoFromBank;

  /// No description provided for @memoPayBank.
  ///
  /// In en, this message translates to:
  /// **'PAY BANK'**
  String get memoPayBank;

  /// No description provided for @memoTransfer.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER'**
  String get memoTransfer;

  /// No description provided for @memoPayment.
  ///
  /// In en, this message translates to:
  /// **'PAYMENT'**
  String get memoPayment;

  /// No description provided for @memoReversal.
  ///
  /// In en, this message translates to:
  /// **'REVERSAL'**
  String get memoReversal;

  /// No description provided for @reverseTitle.
  ///
  /// In en, this message translates to:
  /// **'Reverse transaction?'**
  String get reverseTitle;

  /// No description provided for @reverseBody.
  ///
  /// In en, this message translates to:
  /// **'{title} ({amount}) will be undone with an opposite entry in the ledger. This can only be done once.'**
  String reverseBody(String title, String amount);

  /// No description provided for @reverseAction.
  ///
  /// In en, this message translates to:
  /// **'REVERSE'**
  String get reverseAction;

  /// No description provided for @playersTitle.
  ///
  /// In en, this message translates to:
  /// **'PLAYERS'**
  String get playersTitle;

  /// No description provided for @playersNone.
  ///
  /// In en, this message translates to:
  /// **'No active players'**
  String get playersNone;

  /// No description provided for @playersBankCard.
  ///
  /// In en, this message translates to:
  /// **'THE BANK'**
  String get playersBankCard;

  /// No description provided for @playersBankerName.
  ///
  /// In en, this message translates to:
  /// **'Banker: {name}'**
  String playersBankerName(String name);

  /// No description provided for @padPayingTo.
  ///
  /// In en, this message translates to:
  /// **'PAYING TO'**
  String get padPayingTo;

  /// No description provided for @padReceivingFrom.
  ///
  /// In en, this message translates to:
  /// **'RECEIVING FROM'**
  String get padReceivingFrom;

  /// No description provided for @padSlideToPay.
  ///
  /// In en, this message translates to:
  /// **'SLIDE TO PAY'**
  String get padSlideToPay;

  /// No description provided for @padSlideToReceive.
  ///
  /// In en, this message translates to:
  /// **'SLIDE TO RECEIVE'**
  String get padSlideToReceive;

  /// No description provided for @padProcessing.
  ///
  /// In en, this message translates to:
  /// **'PROCESSING...'**
  String get padProcessing;

  /// No description provided for @padLargePayoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Large bank payout'**
  String get padLargePayoutTitle;

  /// No description provided for @padLargePayoutBody.
  ///
  /// In en, this message translates to:
  /// **'This payout ({amount}) is more than half of all the money in play. Confirm to proceed.'**
  String padLargePayoutBody(String amount);

  /// No description provided for @goPassed.
  ///
  /// In en, this message translates to:
  /// **'PASSED GO'**
  String get goPassed;

  /// No description provided for @goDecline.
  ///
  /// In en, this message translates to:
  /// **'DECLINE'**
  String get goDecline;

  /// No description provided for @goApprove.
  ///
  /// In en, this message translates to:
  /// **'APPROVE'**
  String get goApprove;

  /// No description provided for @settingsGameTitle.
  ///
  /// In en, this message translates to:
  /// **'GAME SETTINGS'**
  String get settingsGameTitle;

  /// No description provided for @settingsGameRules.
  ///
  /// In en, this message translates to:
  /// **'FISCAL RULES'**
  String get settingsGameRules;

  /// No description provided for @settingsGamePlayers.
  ///
  /// In en, this message translates to:
  /// **'ACTIVE PLAYERS'**
  String get settingsGamePlayers;

  /// No description provided for @settingsGameManagement.
  ///
  /// In en, this message translates to:
  /// **'GAME MANAGEMENT'**
  String get settingsGameManagement;

  /// No description provided for @settingsGameExit.
  ///
  /// In en, this message translates to:
  /// **'EXIT'**
  String get settingsGameExit;

  /// No description provided for @settingsGameSessionCode.
  ///
  /// In en, this message translates to:
  /// **'SESSION CODE'**
  String get settingsGameSessionCode;

  /// No description provided for @settingsGameStartingCapital.
  ///
  /// In en, this message translates to:
  /// **'Starting Capital'**
  String get settingsGameStartingCapital;

  /// No description provided for @settingsGameGoBonus.
  ///
  /// In en, this message translates to:
  /// **'GO Bonus'**
  String get settingsGameGoBonus;

  /// No description provided for @settingsGameTransferTooltip.
  ///
  /// In en, this message translates to:
  /// **'Make Banker'**
  String get settingsGameTransferTooltip;

  /// No description provided for @settingsGameKickTooltip.
  ///
  /// In en, this message translates to:
  /// **'Remove player'**
  String get settingsGameKickTooltip;

  /// No description provided for @settingsGameLeave.
  ///
  /// In en, this message translates to:
  /// **'LEAVE SESSION'**
  String get settingsGameLeave;

  /// No description provided for @settingsGameEnd.
  ///
  /// In en, this message translates to:
  /// **'END SESSION'**
  String get settingsGameEnd;

  /// No description provided for @transferTitle.
  ///
  /// In en, this message translates to:
  /// **'Make {name} the Banker?'**
  String transferTitle(String name);

  /// No description provided for @transferBody.
  ///
  /// In en, this message translates to:
  /// **'{name} becomes the Banker and session host. You lose Banker controls.'**
  String transferBody(String name);

  /// No description provided for @transferAction.
  ///
  /// In en, this message translates to:
  /// **'TRANSFER'**
  String get transferAction;

  /// No description provided for @transferDone.
  ///
  /// In en, this message translates to:
  /// **'{name} is now the Banker and session host.'**
  String transferDone(String name);

  /// No description provided for @kickTitle.
  ///
  /// In en, this message translates to:
  /// **'Remove player?'**
  String get kickTitle;

  /// No description provided for @kickBody.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove {name} from the session?'**
  String kickBody(String name);

  /// No description provided for @kickAction.
  ///
  /// In en, this message translates to:
  /// **'REMOVE'**
  String get kickAction;

  /// No description provided for @kickDone.
  ///
  /// In en, this message translates to:
  /// **'{name} was removed from the session.'**
  String kickDone(String name);

  /// No description provided for @endTitle.
  ///
  /// In en, this message translates to:
  /// **'End session?'**
  String get endTitle;

  /// No description provided for @endBody.
  ///
  /// In en, this message translates to:
  /// **'This will permanently end the game for everyone and move to the summary screen.'**
  String get endBody;

  /// No description provided for @endAction.
  ///
  /// In en, this message translates to:
  /// **'END GAME'**
  String get endAction;

  /// No description provided for @removedTitle.
  ///
  /// In en, this message translates to:
  /// **'Removed from game'**
  String get removedTitle;

  /// No description provided for @removedBody.
  ///
  /// In en, this message translates to:
  /// **'The Banker removed you from this session. You can join another game from the home screen.'**
  String get removedBody;

  /// No description provided for @summaryChampion.
  ///
  /// In en, this message translates to:
  /// **'GRAND CHAMPION'**
  String get summaryChampion;

  /// No description provided for @summaryAnalytics.
  ///
  /// In en, this message translates to:
  /// **'SESSION ANALYTICS'**
  String get summaryAnalytics;

  /// No description provided for @summaryStandings.
  ///
  /// In en, this message translates to:
  /// **'FINAL STANDINGS'**
  String get summaryStandings;

  /// No description provided for @summaryMoneyInPlay.
  ///
  /// In en, this message translates to:
  /// **'Money in play'**
  String get summaryMoneyInPlay;

  /// No description provided for @summaryParticipants.
  ///
  /// In en, this message translates to:
  /// **'Participants'**
  String get summaryParticipants;

  /// No description provided for @summaryPlayerCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 Player} other{{count} Players}}'**
  String summaryPlayerCount(int count);

  /// No description provided for @summarySaveExit.
  ///
  /// In en, this message translates to:
  /// **'SAVE & EXIT'**
  String get summarySaveExit;

  /// No description provided for @summaryVolume.
  ///
  /// In en, this message translates to:
  /// **'Volume traded'**
  String get summaryVolume;

  /// No description provided for @summaryLength.
  ///
  /// In en, this message translates to:
  /// **'Game length'**
  String get summaryLength;

  /// No description provided for @summaryHoursMinutes.
  ///
  /// In en, this message translates to:
  /// **'{hours} h {minutes} min'**
  String summaryHoursMinutes(int hours, int minutes);

  /// No description provided for @summaryMinutes.
  ///
  /// In en, this message translates to:
  /// **'{minutes} min'**
  String summaryMinutes(int minutes);

  /// No description provided for @summaryGoCollected.
  ///
  /// In en, this message translates to:
  /// **'GO collected'**
  String get summaryGoCollected;

  /// No description provided for @summaryTimes.
  ///
  /// In en, this message translates to:
  /// **'{count}×'**
  String summaryTimes(int count);

  /// No description provided for @summaryBiggestEarner.
  ///
  /// In en, this message translates to:
  /// **'Biggest earner'**
  String get summaryBiggestEarner;

  /// No description provided for @summaryBiggestSpender.
  ///
  /// In en, this message translates to:
  /// **'Biggest spender'**
  String get summaryBiggestSpender;

  /// No description provided for @summaryMostActive.
  ///
  /// In en, this message translates to:
  /// **'Most active'**
  String get summaryMostActive;

  /// No description provided for @summaryMoves.
  ///
  /// In en, this message translates to:
  /// **'{name} · {count, plural, =1{1 move} other{{count} moves}}'**
  String summaryMoves(String name, int count);

  /// No description provided for @historyTitle.
  ///
  /// In en, this message translates to:
  /// **'PAST GAMES'**
  String get historyTitle;

  /// No description provided for @historyLoadFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not load your games. Tap to retry.'**
  String get historyLoadFailed;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'Finished games will show up here.'**
  String get historyEmpty;

  /// No description provided for @historyGames.
  ///
  /// In en, this message translates to:
  /// **'GAMES'**
  String get historyGames;

  /// No description provided for @historyWins.
  ///
  /// In en, this message translates to:
  /// **'WINS'**
  String get historyWins;

  /// No description provided for @historyAsBanker.
  ///
  /// In en, this message translates to:
  /// **'AS BANKER'**
  String get historyAsBanker;

  /// No description provided for @historyBankerTag.
  ///
  /// In en, this message translates to:
  /// **'{name} • BANKER'**
  String historyBankerTag(String name);

  /// No description provided for @qrJoinCode.
  ///
  /// In en, this message translates to:
  /// **'JOIN CODE'**
  String get qrJoinCode;

  /// No description provided for @qrCopyCode.
  ///
  /// In en, this message translates to:
  /// **'COPY CODE'**
  String get qrCopyCode;

  /// No description provided for @txTransferDone.
  ///
  /// In en, this message translates to:
  /// **'Payment sent'**
  String get txTransferDone;

  /// No description provided for @txPaidBank.
  ///
  /// In en, this message translates to:
  /// **'Paid to the Bank'**
  String get txPaidBank;

  /// No description provided for @txReceivedBank.
  ///
  /// In en, this message translates to:
  /// **'Received from the Bank'**
  String get txReceivedBank;

  /// No description provided for @txReversed.
  ///
  /// In en, this message translates to:
  /// **'Transaction reversed'**
  String get txReversed;

  /// No description provided for @goCollected.
  ///
  /// In en, this message translates to:
  /// **'GO salary collected'**
  String get goCollected;

  /// No description provided for @goWaiting.
  ///
  /// In en, this message translates to:
  /// **'Waiting for Banker approval…'**
  String get goWaiting;

  /// No description provided for @goApproved.
  ///
  /// In en, this message translates to:
  /// **'GO request approved'**
  String get goApproved;

  /// No description provided for @goDeclined.
  ///
  /// In en, this message translates to:
  /// **'GO request declined'**
  String get goDeclined;

  /// No description provided for @errInsufficientFunds.
  ///
  /// In en, this message translates to:
  /// **'Insufficient funds for this payment.'**
  String get errInsufficientFunds;

  /// No description provided for @errSessionClosed.
  ///
  /// In en, this message translates to:
  /// **'This session is no longer active.'**
  String get errSessionClosed;

  /// No description provided for @errNotInSession.
  ///
  /// In en, this message translates to:
  /// **'You are not an active member of this session.'**
  String get errNotInSession;

  /// No description provided for @errCannotPaySelf.
  ///
  /// In en, this message translates to:
  /// **'You cannot pay yourself.'**
  String get errCannotPaySelf;

  /// No description provided for @errRecipientNotFound.
  ///
  /// In en, this message translates to:
  /// **'That player is no longer in the session.'**
  String get errRecipientNotFound;

  /// No description provided for @errAlreadyReversed.
  ///
  /// In en, this message translates to:
  /// **'This transaction was already reversed.'**
  String get errAlreadyReversed;

  /// No description provided for @errCannotReverseReversal.
  ///
  /// In en, this message translates to:
  /// **'A reversal cannot be reversed.'**
  String get errCannotReverseReversal;

  /// No description provided for @errOnlyBanker.
  ///
  /// In en, this message translates to:
  /// **'Only the Banker can do this.'**
  String get errOnlyBanker;

  /// No description provided for @errGoPending.
  ///
  /// In en, this message translates to:
  /// **'You already have a pending GO request.'**
  String get errGoPending;

  /// No description provided for @errInvalidSession.
  ///
  /// In en, this message translates to:
  /// **'Invalid session code. Please check and try again.'**
  String get errInvalidSession;

  /// No description provided for @errKicked.
  ///
  /// In en, this message translates to:
  /// **'You were removed from this session and cannot rejoin.'**
  String get errKicked;

  /// No description provided for @errRejoin.
  ///
  /// In en, this message translates to:
  /// **'Unable to rejoin this session.'**
  String get errRejoin;

  /// No description provided for @errNetwork.
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get errNetwork;

  /// No description provided for @errSessionNotFound.
  ///
  /// In en, this message translates to:
  /// **'Session not found. Join again from the home screen.'**
  String get errSessionNotFound;

  /// No description provided for @errGeneric.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errGeneric;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
