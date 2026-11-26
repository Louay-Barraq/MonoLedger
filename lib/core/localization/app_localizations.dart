import 'package:monoledger/l10n/app_localizations.dart';

export 'package:monoledger/l10n/app_localizations.dart';

class FaqEntry {
  final String question;
  final String answer;

  const FaqEntry({required this.question, required this.answer});
}

/// Codes that blocs and data sources emit instead of English text, so every
/// message is translated in the UI.
abstract final class MessageCode {
  static const txTransferDone = 'txTransferDone';
  static const txPaidBank = 'txPaidBank';
  static const txReceivedBank = 'txReceivedBank';
  static const txReversed = 'txReversed';
  static const goCollected = 'goCollected';
  static const goWaiting = 'goWaiting';
  static const goApproved = 'goApproved';
  static const goDeclined = 'goDeclined';
  static const insufficientFunds = 'insufficientFunds';
  static const sessionClosed = 'sessionClosed';
  static const notInSession = 'notInSession';
  static const cannotPaySelf = 'cannotPaySelf';
  static const recipientNotFound = 'recipientNotFound';
  static const alreadyReversed = 'alreadyReversed';
  static const cannotReverseReversal = 'cannotReverseReversal';
  static const onlyBanker = 'onlyBanker';
  static const goPending = 'goPending';
  static const invalidSession = 'invalidSession';
  static const kicked = 'kicked';
  static const rejoin = 'rejoin';
  static const network = 'network';
  static const sessionNotFound = 'sessionNotFound';
  static const authInitFailed = 'authInitFailed';
  static const deleteDataFailed = 'deleteDataFailed';
  static const generic = 'generic';
}

extension AppLocalizationsX on AppLocalizations {
  List<FaqEntry> get faqEntries => [
    FaqEntry(question: faqQ1, answer: faqA1),
    FaqEntry(question: faqQ2, answer: faqA2),
    FaqEntry(question: faqQ3, answer: faqA3),
    FaqEntry(question: faqQ4, answer: faqA4),
    FaqEntry(question: faqQ5, answer: faqA5),
    FaqEntry(question: faqQ6, answer: faqA6),
    FaqEntry(question: faqQ7, answer: faqA7),
    FaqEntry(question: faqQ8, answer: faqA8),
    FaqEntry(question: faqQ9, answer: faqA9),
    FaqEntry(question: faqQ10, answer: faqA10),
  ];

  /// Translates a [MessageCode]. Unknown codes fall back to a generic error.
  String message(String code) => switch (code) {
    MessageCode.txTransferDone => txTransferDone,
    MessageCode.txPaidBank => txPaidBank,
    MessageCode.txReceivedBank => txReceivedBank,
    MessageCode.txReversed => txReversed,
    MessageCode.goCollected => goCollected,
    MessageCode.goWaiting => goWaiting,
    MessageCode.goApproved => goApproved,
    MessageCode.goDeclined => goDeclined,
    MessageCode.insufficientFunds => errInsufficientFunds,
    MessageCode.sessionClosed => errSessionClosed,
    MessageCode.notInSession => errNotInSession,
    MessageCode.cannotPaySelf => errCannotPaySelf,
    MessageCode.recipientNotFound => errRecipientNotFound,
    MessageCode.alreadyReversed => errAlreadyReversed,
    MessageCode.cannotReverseReversal => errCannotReverseReversal,
    MessageCode.onlyBanker => errOnlyBanker,
    MessageCode.goPending => errGoPending,
    MessageCode.invalidSession => errInvalidSession,
    MessageCode.kicked => errKicked,
    MessageCode.rejoin => errRejoin,
    MessageCode.network => errNetwork,
    MessageCode.sessionNotFound => errSessionNotFound,
    MessageCode.authInitFailed => authInitFailed,
    MessageCode.deleteDataFailed => deleteDataFailed,
    _ => errGeneric,
  };

  /// System memos stored with transactions, shown in the reader's language.
  String memo(String? raw, String fallback) =>
      switch ((raw ?? fallback).toUpperCase()) {
        'PASSED GO' => memoPassedGo,
        'FROM BANK' => memoFromBank,
        'PAY BANK' => memoPayBank,
        'TRANSFER' => memoTransfer,
        'PAYMENT' => memoPayment,
        'REVERSAL' => memoReversal,
        final other => other,
      };
}
