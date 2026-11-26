// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'MonoLedger';

  @override
  String get brandMono => 'Mono';

  @override
  String get brandLedger => 'Ledger';

  @override
  String get commonCancel => 'CANCEL';

  @override
  String get commonConfirm => 'CONFIRM';

  @override
  String get commonDelete => 'DELETE';

  @override
  String get commonContinue => 'CONTINUE';

  @override
  String get commonRetry => 'Retry';

  @override
  String get commonPlayer => 'Player';

  @override
  String get commonUnknown => 'Unknown';

  @override
  String get commonBanker => 'BANKER';

  @override
  String get commonYou => 'YOU';

  @override
  String get commonTheBank => 'The Bank';

  @override
  String get codeCopied => 'Code copied to clipboard';

  @override
  String get settingsTitle => 'SETTINGS';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsHelp => 'Help & FAQ';

  @override
  String get settingsHelpSubtitle => 'Common questions and answers';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsAboutSubtitle => 'App info and developer';

  @override
  String get settingsHaptics => 'Haptic feedback';

  @override
  String get settingsHapticsSubtitle => 'Vibration on slide-to-pay';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsSectionGeneral => 'GENERAL';

  @override
  String get settingsSectionSupport => 'SUPPORT';

  @override
  String get settingsSectionPrivacy => 'PRIVACY';

  @override
  String get settingsPrivacyPolicy => 'Privacy policy';

  @override
  String get settingsPrivacyPolicySubtitle => 'What MonoLedger stores and why';

  @override
  String get settingsDeleteData => 'Delete my data';

  @override
  String get settingsDeleteDataSubtitle =>
      'Delete your account and game history';

  @override
  String get settingsDeleting => 'Deleting…';

  @override
  String get deleteDataTitle => 'Delete my data?';

  @override
  String get deleteDataBody =>
      'This deletes your MonoLedger account, your profile and your game history. You leave any game you are in. In games other people played with you, your entries stay as \"Deleted player\" so their ledgers still add up. This cannot be undone.';

  @override
  String get deleteDataFailed =>
      'Could not delete your data. Check your connection and try again.';

  @override
  String get authInitFailed =>
      'Could not start MonoLedger. Check your connection and try again.';

  @override
  String get helpTitle => 'HELP & FAQ';

  @override
  String get helpIntro => 'Quick answers about sessions, payments, and roles.';

  @override
  String get aboutTitle => 'ABOUT';

  @override
  String get aboutAppHeading => 'MonoLedger';

  @override
  String get aboutAppBody =>
      'MonoLedger turns board-game night into a seamless digital ledger. Host or join a session, track balances in real time, pay the bank or other players with a tactile slide-to-confirm flow, and review every move in a shared transaction history.';

  @override
  String get aboutDeveloperHeading => 'Developer';

  @override
  String get aboutDeveloperBody =>
      'MonoLedger was created by Louay Barraq — focused on clean, fast tooling for game nights with friends and family.';

  @override
  String get faqQ1 => 'What is MonoLedger?';

  @override
  String get faqA1 =>
      'MonoLedger is a digital cash manager for board-game nights. It replaces physical bills with live balances, a shared ledger, and slide-to-pay transfers.';

  @override
  String get faqQ2 => 'How do I create a session?';

  @override
  String get faqA2 =>
      'From the home screen, tap Create Session, set the starting capital and GO amount, enter your name, and share the 6-character code or QR code with friends.';

  @override
  String get faqQ3 => 'How do I join a session?';

  @override
  String get faqA3 =>
      'Tap Join Session, then enter the code or scan the host\'s QR code. Enter your display name and confirm.';

  @override
  String get faqQ4 => 'What is the Banker?';

  @override
  String get faqA4 =>
      'The Banker hosts the session. They can end the game, remove players, pass the Banker role on, approve GO salary requests, pay out from the bank and undo a mistaken payment.';

  @override
  String get faqQ5 => 'How does GO salary work?';

  @override
  String get faqA5 =>
      'When you pass GO, tap Collect Salary on the wallet tab. Other players send a request that the Banker approves or declines; the Banker collects instantly.';

  @override
  String get faqQ6 => 'Can I leave and rejoin?';

  @override
  String get faqA6 =>
      'Yes. If you leave, you can rejoin the same session with its code and you keep the balance you had when you left.';

  @override
  String get faqQ7 => 'What happens if I am removed?';

  @override
  String get faqA7 =>
      'You leave the player list and cannot rejoin that session. You\'ll see a notice and return to the home screen.';

  @override
  String get faqQ8 => 'Can a payment be undone?';

  @override
  String get faqA8 =>
      'Yes. The Banker can long-press any entry in the ledger to reverse it once. The reversal appears as its own entry so everyone can see it.';

  @override
  String get faqQ9 => 'Is my data stored online?';

  @override
  String get faqA9 =>
      'Sessions, balances and payments are stored online so every player sees them in real time. You can delete your data at any time in Settings.';

  @override
  String get faqQ10 => 'Which games is it for?';

  @override
  String get faqA10 =>
      'Any board game that uses play money. The defaults (1,500 to start, 200 for passing GO) suit classic property-trading games.';

  @override
  String get homeCreateSession => 'CREATE SESSION';

  @override
  String get homeJoinSession => 'JOIN SESSION';

  @override
  String get homeTagline => 'DIGITAL CURRENCY FOR BOARD GAMES';

  @override
  String get homeFooter =>
      'Supports 2-10 players.\nFor any board game\nthat uses play money.';

  @override
  String get homeCapacity => 'CAPACITY';

  @override
  String get homeSyncing => 'SYNCING';

  @override
  String get homeCapacityValue => '2-10 PLAYERS';

  @override
  String get homeSyncingValue => 'REAL-TIME';

  @override
  String get homePastGames => 'Past games';

  @override
  String get onboardingTitle1 => 'WELCOME TO\nMONOLEDGER';

  @override
  String get onboardingBody1 =>
      'Play money for your favorite board games, on every player\'s phone.';

  @override
  String get onboardingTitle2 => 'REAL-TIME\nSYNCING';

  @override
  String get onboardingBody2 =>
      'Every player stays in sync with live updates. No more manual calculations or paper money chaos.';

  @override
  String get onboardingTitle3 => 'SECURE &\nPRIVATE';

  @override
  String get onboardingBody3 =>
      'Payments go through secure, encrypted connections. Focus on the game, we\'ll handle the numbers.';

  @override
  String get onboardingStart => 'START EXPERIENCE';

  @override
  String get createHeader => 'INITIAL SETUP';

  @override
  String get createTitle => 'Create Session';

  @override
  String get createSubtitle => 'Set the rules for your game\'s money.';

  @override
  String get createYourName => 'YOUR NAME';

  @override
  String get createNameHint => 'Enter banker name';

  @override
  String get createCurrency => 'CURRENCY SYMBOL';

  @override
  String get createStartingCapital => 'STARTING CAPITAL';

  @override
  String get createPresetStandard => 'STANDARD START';

  @override
  String get createPresetPro => 'PRO TIER';

  @override
  String get createPresetCapitalist => 'CAPITALIST';

  @override
  String get createPresetWhale => 'WHALE MODE';

  @override
  String get createEnterAmount => 'ENTER AMOUNT';

  @override
  String get createCustomAmount => 'CUSTOM AMOUNT';

  @override
  String get createGoAmount => 'GO AMOUNT';

  @override
  String get createNameRequired => 'Please enter your name to continue.';

  @override
  String get createCapitalInvalid => 'Starting capital must be greater than 0.';

  @override
  String get createGoInvalid => 'GO amount cannot be negative.';

  @override
  String get createSubmit => 'CREATE & START';

  @override
  String get joinHeader => 'CONNECTION';

  @override
  String get joinTitle => 'Join Session';

  @override
  String get joinSubtitle =>
      'Enter the session code or scan the host\'s QR code.';

  @override
  String get joinEnterCode => 'ENTER CODE';

  @override
  String get joinEnterCodeSubtitle => 'Type the 6-character code';

  @override
  String get joinScanQr => 'SCAN QR CODE';

  @override
  String get joinScanQrSubtitle => 'Use your camera to scan';

  @override
  String get joinCodeHeader => 'SESSION CODE';

  @override
  String get joinCodeTitle => 'Enter Code';

  @override
  String get joinCodeSubtitle =>
      'Enter the 6-character code and your name to join.';

  @override
  String get joinCodeLabel => 'SESSION CODE';

  @override
  String get joinNameLabel => 'YOUR NAME';

  @override
  String get joinNameHint => 'Name';

  @override
  String get joinCodeInvalid => 'Please enter a valid 6-character code.';

  @override
  String get joinNameRequired => 'Please enter your name.';

  @override
  String get joinConfirm => 'CONFIRM JOIN';

  @override
  String get scanTitle => 'SCAN QR';

  @override
  String get scanHint => 'Point your camera at the host\'s session QR code';

  @override
  String get dashboardRoomCode => 'ROOM CODE';

  @override
  String get navWallet => 'WALLET';

  @override
  String get navLedger => 'LEDGER';

  @override
  String get navPlayers => 'PLAYERS';

  @override
  String get leaveTitle => 'Leave session?';

  @override
  String get leaveBodyBanker =>
      'As the Banker, leaving passes the Banker role and hosting to another player at random. Continue?';

  @override
  String get leaveBodyLast =>
      'You are the only player. Leaving will end the session for everyone. Continue?';

  @override
  String get leaveBody =>
      'You will leave this session and return to the home screen. Continue?';

  @override
  String get leaveAction => 'LEAVE';

  @override
  String get walletCurrentBalance => 'CURRENT BALANCE';

  @override
  String walletVsStart(String change) {
    return '$change% vs START';
  }

  @override
  String get walletGo => 'GO';

  @override
  String get walletCollectSalary => 'COLLECT SALARY';

  @override
  String get walletAwaitingBanker => 'AWAITING BANKER';

  @override
  String get walletPayBank => 'PAY BANK';

  @override
  String get walletFromBank => 'FROM BANK';

  @override
  String get walletPlayers => 'Players';

  @override
  String walletActiveCount(int count) {
    return '$count ACTIVE';
  }

  @override
  String get walletNoPlayers => 'No players in session yet';

  @override
  String get walletTapToPay => 'TAP TO PAY';

  @override
  String walletRank(int rank) {
    return 'RANK #$rank';
  }

  @override
  String get ledgerTitle => 'Ledger';

  @override
  String get ledgerSubtitle => 'All session transactions';

  @override
  String get ledgerEmpty => 'No transactions yet';

  @override
  String get ledgerFromBank => 'From The Bank';

  @override
  String get ledgerToBank => 'To The Bank';

  @override
  String get ledgerReversed => 'REVERSED';

  @override
  String get ledgerJustNow => 'Just now';

  @override
  String ledgerMinutesAgo(int minutes) {
    return '$minutes min ago';
  }

  @override
  String ledgerHoursAgo(int hours) {
    return '$hours h ago';
  }

  @override
  String ledgerDaysAgo(int days) {
    return '$days d ago';
  }

  @override
  String get memoPassedGo => 'PASSED GO';

  @override
  String get memoFromBank => 'FROM BANK';

  @override
  String get memoPayBank => 'PAY BANK';

  @override
  String get memoTransfer => 'TRANSFER';

  @override
  String get memoPayment => 'PAYMENT';

  @override
  String get memoReversal => 'REVERSAL';

  @override
  String get reverseTitle => 'Reverse transaction?';

  @override
  String reverseBody(String title, String amount) {
    return '$title ($amount) will be undone with an opposite entry in the ledger. This can only be done once.';
  }

  @override
  String get reverseAction => 'REVERSE';

  @override
  String get playersTitle => 'PLAYERS';

  @override
  String get playersNone => 'No active players';

  @override
  String get playersBankCard => 'THE BANK';

  @override
  String playersBankerName(String name) {
    return 'Banker: $name';
  }

  @override
  String get padPayingTo => 'PAYING TO';

  @override
  String get padReceivingFrom => 'RECEIVING FROM';

  @override
  String get padSlideToPay => 'SLIDE TO PAY';

  @override
  String get padSlideToReceive => 'SLIDE TO RECEIVE';

  @override
  String get padProcessing => 'PROCESSING...';

  @override
  String get padLargePayoutTitle => 'Large bank payout';

  @override
  String padLargePayoutBody(String amount) {
    return 'This payout ($amount) is more than half of all the money in play. Confirm to proceed.';
  }

  @override
  String get goPassed => 'PASSED GO';

  @override
  String get goDecline => 'DECLINE';

  @override
  String get goApprove => 'APPROVE';

  @override
  String get settingsGameTitle => 'GAME SETTINGS';

  @override
  String get settingsGameRules => 'FISCAL RULES';

  @override
  String get settingsGamePlayers => 'ACTIVE PLAYERS';

  @override
  String get settingsGameManagement => 'GAME MANAGEMENT';

  @override
  String get settingsGameExit => 'EXIT';

  @override
  String get settingsGameSessionCode => 'SESSION CODE';

  @override
  String get settingsGameStartingCapital => 'Starting Capital';

  @override
  String get settingsGameGoBonus => 'GO Bonus';

  @override
  String get settingsGameTransferTooltip => 'Make Banker';

  @override
  String get settingsGameKickTooltip => 'Remove player';

  @override
  String get settingsGameLeave => 'LEAVE SESSION';

  @override
  String get settingsGameEnd => 'END SESSION';

  @override
  String transferTitle(String name) {
    return 'Make $name the Banker?';
  }

  @override
  String transferBody(String name) {
    return '$name becomes the Banker and session host. You lose Banker controls.';
  }

  @override
  String get transferAction => 'TRANSFER';

  @override
  String transferDone(String name) {
    return '$name is now the Banker and session host.';
  }

  @override
  String get kickTitle => 'Remove player?';

  @override
  String kickBody(String name) {
    return 'Are you sure you want to remove $name from the session?';
  }

  @override
  String get kickAction => 'REMOVE';

  @override
  String kickDone(String name) {
    return '$name was removed from the session.';
  }

  @override
  String get endTitle => 'End session?';

  @override
  String get endBody =>
      'This will permanently end the game for everyone and move to the summary screen.';

  @override
  String get endAction => 'END GAME';

  @override
  String get removedTitle => 'Removed from game';

  @override
  String get removedBody =>
      'The Banker removed you from this session. You can join another game from the home screen.';

  @override
  String get summaryChampion => 'GRAND CHAMPION';

  @override
  String get summaryAnalytics => 'SESSION ANALYTICS';

  @override
  String get summaryStandings => 'FINAL STANDINGS';

  @override
  String get summaryMoneyInPlay => 'Money in play';

  @override
  String get summaryParticipants => 'Participants';

  @override
  String summaryPlayerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Players',
      one: '1 Player',
    );
    return '$_temp0';
  }

  @override
  String get summarySaveExit => 'SAVE & EXIT';

  @override
  String get summaryVolume => 'Volume traded';

  @override
  String get summaryLength => 'Game length';

  @override
  String summaryHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String summaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get summaryGoCollected => 'GO collected';

  @override
  String summaryTimes(int count) {
    return '$count×';
  }

  @override
  String get summaryBiggestEarner => 'Biggest earner';

  @override
  String get summaryBiggestSpender => 'Biggest spender';

  @override
  String get summaryMostActive => 'Most active';

  @override
  String summaryMoves(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count moves',
      one: '1 move',
    );
    return '$name · $_temp0';
  }

  @override
  String get historyTitle => 'PAST GAMES';

  @override
  String get historyLoadFailed => 'Could not load your games. Tap to retry.';

  @override
  String get historyEmpty => 'Finished games will show up here.';

  @override
  String get historyGames => 'GAMES';

  @override
  String get historyWins => 'WINS';

  @override
  String get historyAsBanker => 'AS BANKER';

  @override
  String historyBankerTag(String name) {
    return '$name • BANKER';
  }

  @override
  String get qrJoinCode => 'JOIN CODE';

  @override
  String get qrCopyCode => 'COPY CODE';

  @override
  String get txTransferDone => 'Payment sent';

  @override
  String get txPaidBank => 'Paid to the Bank';

  @override
  String get txReceivedBank => 'Received from the Bank';

  @override
  String get txReversed => 'Transaction reversed';

  @override
  String get goCollected => 'GO salary collected';

  @override
  String get goWaiting => 'Waiting for Banker approval…';

  @override
  String get goApproved => 'GO request approved';

  @override
  String get goDeclined => 'GO request declined';

  @override
  String get errInsufficientFunds => 'Insufficient funds for this payment.';

  @override
  String get errSessionClosed => 'This session is no longer active.';

  @override
  String get errNotInSession => 'You are not an active member of this session.';

  @override
  String get errCannotPaySelf => 'You cannot pay yourself.';

  @override
  String get errRecipientNotFound => 'That player is no longer in the session.';

  @override
  String get errAlreadyReversed => 'This transaction was already reversed.';

  @override
  String get errCannotReverseReversal => 'A reversal cannot be reversed.';

  @override
  String get errOnlyBanker => 'Only the Banker can do this.';

  @override
  String get errGoPending => 'You already have a pending GO request.';

  @override
  String get errInvalidSession =>
      'Invalid session code. Please check and try again.';

  @override
  String get errKicked =>
      'You were removed from this session and cannot rejoin.';

  @override
  String get errRejoin => 'Unable to rejoin this session.';

  @override
  String get errNetwork => 'Network error. Please check your connection.';

  @override
  String get errSessionNotFound =>
      'Session not found. Join again from the home screen.';

  @override
  String get errGeneric => 'Something went wrong. Please try again.';
}
