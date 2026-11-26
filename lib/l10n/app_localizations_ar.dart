// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appName => 'MonoLedger';

  @override
  String get brandMono => 'Mono';

  @override
  String get brandLedger => 'Ledger';

  @override
  String get commonCancel => 'إلغاء';

  @override
  String get commonConfirm => 'تأكيد';

  @override
  String get commonDelete => 'حذف';

  @override
  String get commonContinue => 'متابعة';

  @override
  String get commonRetry => 'إعادة المحاولة';

  @override
  String get commonPlayer => 'لاعب';

  @override
  String get commonUnknown => 'غير معروف';

  @override
  String get commonBanker => 'المصرفي';

  @override
  String get commonYou => 'أنت';

  @override
  String get commonTheBank => 'البنك';

  @override
  String get codeCopied => 'تم نسخ الرمز';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsLanguage => 'اللغة';

  @override
  String get settingsHelp => 'المساعدة والأسئلة الشائعة';

  @override
  String get settingsHelpSubtitle => 'أسئلة وأجوبة متكررة';

  @override
  String get settingsAbout => 'حول التطبيق';

  @override
  String get settingsAboutSubtitle => 'معلومات التطبيق والمطوّر';

  @override
  String get settingsHaptics => 'الاهتزاز';

  @override
  String get settingsHapticsSubtitle => 'اهتزاز عند السحب للدفع';

  @override
  String settingsVersion(String version) {
    return 'الإصدار $version';
  }

  @override
  String get settingsSectionGeneral => 'عام';

  @override
  String get settingsSectionSupport => 'الدعم';

  @override
  String get settingsSectionPrivacy => 'الخصوصية';

  @override
  String get settingsPrivacyPolicy => 'سياسة الخصوصية';

  @override
  String get settingsPrivacyPolicySubtitle => 'ما الذي يحفظه التطبيق ولماذا';

  @override
  String get settingsDeleteData => 'حذف بياناتي';

  @override
  String get settingsDeleteDataSubtitle => 'حذف حسابك وسجل ألعابك';

  @override
  String get settingsDeleting => 'جارٍ الحذف…';

  @override
  String get deleteDataTitle => 'حذف بياناتي؟';

  @override
  String get deleteDataBody =>
      'سيتم حذف حسابك في MonoLedger وملفك الشخصي وسجل ألعابك، وستغادر أي لعبة جارية. في الألعاب التي لعبتها مع آخرين تبقى عملياتك باسم «لاعب محذوف» حتى تظل حساباتهم صحيحة. لا يمكن التراجع عن هذا.';

  @override
  String get deleteDataFailed =>
      'تعذّر حذف بياناتك. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get authInitFailed =>
      'تعذّر تشغيل التطبيق. تحقق من الاتصال وحاول مرة أخرى.';

  @override
  String get helpTitle => 'المساعدة والأسئلة';

  @override
  String get helpIntro => 'إجابات سريعة عن الجلسات والمدفوعات والأدوار.';

  @override
  String get aboutTitle => 'حول التطبيق';

  @override
  String get aboutAppHeading => 'MonoLedger';

  @override
  String get aboutAppBody =>
      'يحوّل MonoLedger سهرات ألعاب الطاولة إلى دفتر حسابات رقمي. أنشئ جلسة أو انضم إليها، وتابع الأرصدة لحظيًا، وادفع للبنك أو للاعبين بالسحب، وراجع كل عملية في سجل مشترك.';

  @override
  String get aboutDeveloperHeading => 'المطوّر';

  @override
  String get aboutDeveloperBody =>
      'طوّر Louay Barraq تطبيق MonoLedger لسهرات لعب سريعة وبسيطة مع الأصدقاء والعائلة.';

  @override
  String get faqQ1 => 'ما هو MonoLedger؟';

  @override
  String get faqA1 =>
      'يدير MonoLedger المال في سهرات ألعاب الطاولة، فيستبدل الأوراق النقدية بأرصدة حية وسجل مشترك ودفع بالسحب.';

  @override
  String get faqQ2 => 'كيف أنشئ جلسة؟';

  @override
  String get faqA2 =>
      'من الشاشة الرئيسية اضغط «إنشاء جلسة»، وحدّد رأس المال الأولي ومكافأة الانطلاق، وأدخل اسمك، ثم شارك الرمز المكوّن من 6 خانات أو رمز QR مع أصدقائك.';

  @override
  String get faqQ3 => 'كيف أنضم إلى جلسة؟';

  @override
  String get faqA3 =>
      'اضغط «انضمام»، ثم أدخل الرمز أو امسح رمز QR الخاص بالمضيف. اكتب اسمك وأكّد.';

  @override
  String get faqQ4 => 'من هو المصرفي؟';

  @override
  String get faqA4 =>
      'المصرفي هو مضيف الجلسة. يمكنه إنهاء اللعبة وإخراج اللاعبين ونقل دوره والموافقة على مكافآت الانطلاق والصرف من البنك والتراجع عن دفعة خاطئة.';

  @override
  String get faqQ5 => 'كيف تعمل مكافأة الانطلاق؟';

  @override
  String get faqA5 =>
      'عند المرور بخانة الانطلاق اضغط «تحصيل المكافأة» في تبويب المحفظة. يرسل اللاعبون طلبًا يوافق عليه المصرفي أو يرفضه، أما المصرفي فيحصل عليها فورًا.';

  @override
  String get faqQ6 => 'هل يمكنني المغادرة ثم العودة؟';

  @override
  String get faqA6 =>
      'نعم. إذا غادرت يمكنك العودة إلى الجلسة نفسها برمزها وتحتفظ برصيدك كما كان.';

  @override
  String get faqQ7 => 'ماذا يحدث إذا أُخرجت من اللعبة؟';

  @override
  String get faqA7 =>
      'تُزال من قائمة اللاعبين ولا يمكنك العودة إلى تلك الجلسة. سيظهر لك إشعار وتعود إلى الشاشة الرئيسية.';

  @override
  String get faqQ8 => 'هل يمكن التراجع عن دفعة؟';

  @override
  String get faqA8 =>
      'نعم. يمكن للمصرفي الضغط مطولًا على أي عملية في السجل لعكسها مرة واحدة، وتظهر عملية العكس للجميع.';

  @override
  String get faqQ9 => 'هل تُحفظ بياناتي على الإنترنت؟';

  @override
  String get faqA9 =>
      'تُحفظ الجلسات والأرصدة والدفعات على الإنترنت ليراها كل اللاعبين لحظيًا. يمكنك حذف بياناتك في أي وقت من الإعدادات.';

  @override
  String get faqQ10 => 'ما الألعاب المناسبة؟';

  @override
  String get faqA10 =>
      'أي لعبة طاولة تستخدم أموالًا وهمية. القيم الافتراضية (1500 في البداية و200 عند المرور بالانطلاق) تناسب ألعاب شراء العقارات الكلاسيكية.';

  @override
  String get homeCreateSession => 'إنشاء جلسة';

  @override
  String get homeJoinSession => 'انضمام إلى جلسة';

  @override
  String get homeTagline => 'أموال رقمية لألعاب الطاولة';

  @override
  String get homeFooter =>
      'من 2 إلى 10 لاعبين.\nلأي لعبة طاولة\nتستخدم أموالًا وهمية.';

  @override
  String get homeCapacity => 'السعة';

  @override
  String get homeSyncing => 'المزامنة';

  @override
  String get homeCapacityValue => '2-10 لاعبين';

  @override
  String get homeSyncingValue => 'لحظية';

  @override
  String get homePastGames => 'الألعاب السابقة';

  @override
  String get onboardingTitle1 => 'مرحبًا بك في\nMONOLEDGER';

  @override
  String get onboardingBody1 =>
      'أموال ألعاب الطاولة المفضلة لديك على هاتف كل لاعب.';

  @override
  String get onboardingTitle2 => 'مزامنة\nلحظية';

  @override
  String get onboardingBody2 =>
      'يبقى كل اللاعبين على اطلاع بالتحديثات المباشرة. لا مزيد من الحسابات اليدوية وفوضى الأوراق.';

  @override
  String get onboardingTitle3 => 'آمن\nوخاص';

  @override
  String get onboardingBody3 =>
      'تمر المدفوعات عبر اتصالات مشفّرة. ركّز على اللعب، ونحن نتولى الأرقام.';

  @override
  String get onboardingStart => 'ابدأ الآن';

  @override
  String get createHeader => 'الإعداد الأولي';

  @override
  String get createTitle => 'إنشاء جلسة';

  @override
  String get createSubtitle => 'حدّد قواعد المال في لعبتك.';

  @override
  String get createYourName => 'اسمك';

  @override
  String get createNameHint => 'اسم المصرفي';

  @override
  String get createCurrency => 'رمز العملة';

  @override
  String get createStartingCapital => 'رأس المال الأولي';

  @override
  String get createPresetStandard => 'بداية قياسية';

  @override
  String get createPresetPro => 'مستوى المحترفين';

  @override
  String get createPresetCapitalist => 'رأسمالي';

  @override
  String get createPresetWhale => 'وضع الأثرياء';

  @override
  String get createEnterAmount => 'أدخل المبلغ';

  @override
  String get createCustomAmount => 'مبلغ مخصص';

  @override
  String get createGoAmount => 'مكافأة الانطلاق';

  @override
  String get createNameRequired => 'أدخل اسمك للمتابعة.';

  @override
  String get createCapitalInvalid => 'يجب أن يكون رأس المال الأولي أكبر من 0.';

  @override
  String get createGoInvalid => 'لا يمكن أن تكون مكافأة الانطلاق سالبة.';

  @override
  String get createSubmit => 'أنشئ وابدأ';

  @override
  String get joinHeader => 'الاتصال';

  @override
  String get joinTitle => 'الانضمام إلى جلسة';

  @override
  String get joinSubtitle => 'أدخل رمز الجلسة أو امسح رمز QR الخاص بالمضيف.';

  @override
  String get joinEnterCode => 'إدخال الرمز';

  @override
  String get joinEnterCodeSubtitle => 'اكتب الرمز المكوّن من 6 خانات';

  @override
  String get joinScanQr => 'مسح رمز QR';

  @override
  String get joinScanQrSubtitle => 'استخدم الكاميرا للمسح';

  @override
  String get joinCodeHeader => 'رمز الجلسة';

  @override
  String get joinCodeTitle => 'أدخل الرمز';

  @override
  String get joinCodeSubtitle =>
      'أدخل الرمز المكوّن من 6 خانات واسمك للانضمام.';

  @override
  String get joinCodeLabel => 'رمز الجلسة';

  @override
  String get joinNameLabel => 'اسمك';

  @override
  String get joinNameHint => 'الاسم';

  @override
  String get joinCodeInvalid => 'أدخل رمزًا صالحًا من 6 خانات.';

  @override
  String get joinNameRequired => 'أدخل اسمك.';

  @override
  String get joinConfirm => 'تأكيد الانضمام';

  @override
  String get scanTitle => 'مسح الرمز';

  @override
  String get scanHint => 'وجّه الكاميرا نحو رمز QR الخاص بجلسة المضيف';

  @override
  String get dashboardRoomCode => 'رمز الغرفة';

  @override
  String get navWallet => 'المحفظة';

  @override
  String get navLedger => 'السجل';

  @override
  String get navPlayers => 'اللاعبون';

  @override
  String get leaveTitle => 'مغادرة الجلسة؟';

  @override
  String get leaveBodyBanker =>
      'بمغادرتك وأنت المصرفي ينتقل الدور والاستضافة إلى لاعب آخر عشوائيًا. هل تتابع؟';

  @override
  String get leaveBodyLast =>
      'أنت اللاعب الوحيد، ومغادرتك ستنهي الجلسة للجميع. هل تتابع؟';

  @override
  String get leaveBody =>
      'ستغادر هذه الجلسة وتعود إلى الشاشة الرئيسية. هل تتابع؟';

  @override
  String get leaveAction => 'مغادرة';

  @override
  String get walletCurrentBalance => 'الرصيد الحالي';

  @override
  String walletVsStart(String change) {
    return '$change% مقارنة بالبداية';
  }

  @override
  String get walletGo => 'الانطلاق';

  @override
  String get walletCollectSalary => 'تحصيل المكافأة';

  @override
  String get walletAwaitingBanker => 'بانتظار المصرفي';

  @override
  String get walletPayBank => 'الدفع للبنك';

  @override
  String get walletFromBank => 'استلام من البنك';

  @override
  String get walletPlayers => 'اللاعبون';

  @override
  String walletActiveCount(int count) {
    return 'النشطون: $count';
  }

  @override
  String get walletNoPlayers => 'لا يوجد لاعبون في الجلسة بعد';

  @override
  String get walletTapToPay => 'اضغط للدفع';

  @override
  String walletRank(int rank) {
    return 'المرتبة $rank';
  }

  @override
  String get ledgerTitle => 'السجل';

  @override
  String get ledgerSubtitle => 'جميع عمليات الجلسة';

  @override
  String get ledgerEmpty => 'لا توجد عمليات بعد';

  @override
  String get ledgerFromBank => 'من البنك';

  @override
  String get ledgerToBank => 'إلى البنك';

  @override
  String get ledgerReversed => 'معكوسة';

  @override
  String get ledgerJustNow => 'الآن';

  @override
  String ledgerMinutesAgo(int minutes) {
    return 'قبل $minutes د';
  }

  @override
  String ledgerHoursAgo(int hours) {
    return 'قبل $hours س';
  }

  @override
  String ledgerDaysAgo(int days) {
    return 'قبل $days ي';
  }

  @override
  String get memoPassedGo => 'المرور بالانطلاق';

  @override
  String get memoFromBank => 'من البنك';

  @override
  String get memoPayBank => 'دفع للبنك';

  @override
  String get memoTransfer => 'تحويل';

  @override
  String get memoPayment => 'دفعة';

  @override
  String get memoReversal => 'عكس العملية';

  @override
  String get reverseTitle => 'عكس العملية؟';

  @override
  String reverseBody(String title, String amount) {
    return 'سيتم إلغاء $title ($amount) بإضافة عملية معاكسة إلى السجل. يمكن فعل ذلك مرة واحدة فقط.';
  }

  @override
  String get reverseAction => 'عكس';

  @override
  String get playersTitle => 'اللاعبون';

  @override
  String get playersNone => 'لا يوجد لاعبون نشطون';

  @override
  String get playersBankCard => 'البنك';

  @override
  String playersBankerName(String name) {
    return 'المصرفي: $name';
  }

  @override
  String get padPayingTo => 'الدفع إلى';

  @override
  String get padReceivingFrom => 'الاستلام من';

  @override
  String get padSlideToPay => 'اسحب للدفع';

  @override
  String get padSlideToReceive => 'اسحب للاستلام';

  @override
  String get padProcessing => 'جارٍ التنفيذ...';

  @override
  String get padLargePayoutTitle => 'صرف كبير من البنك';

  @override
  String padLargePayoutBody(String amount) {
    return 'هذا المبلغ ($amount) يتجاوز نصف كل الأموال في اللعبة. أكّد للمتابعة.';
  }

  @override
  String get goPassed => 'مرّ بالانطلاق';

  @override
  String get goDecline => 'رفض';

  @override
  String get goApprove => 'موافقة';

  @override
  String get settingsGameTitle => 'إعدادات اللعبة';

  @override
  String get settingsGameRules => 'قواعد المال';

  @override
  String get settingsGamePlayers => 'اللاعبون النشطون';

  @override
  String get settingsGameManagement => 'إدارة اللعبة';

  @override
  String get settingsGameExit => 'الخروج';

  @override
  String get settingsGameSessionCode => 'رمز الجلسة';

  @override
  String get settingsGameStartingCapital => 'رأس المال الأولي';

  @override
  String get settingsGameGoBonus => 'مكافأة الانطلاق';

  @override
  String get settingsGameTransferTooltip => 'تعيين مصرفيًا';

  @override
  String get settingsGameKickTooltip => 'إخراج اللاعب';

  @override
  String get settingsGameLeave => 'مغادرة الجلسة';

  @override
  String get settingsGameEnd => 'إنهاء الجلسة';

  @override
  String transferTitle(String name) {
    return 'تعيين $name مصرفيًا؟';
  }

  @override
  String transferBody(String name) {
    return 'سيصبح $name المصرفي ومضيف الجلسة، وستفقد صلاحيات المصرفي.';
  }

  @override
  String get transferAction => 'نقل';

  @override
  String transferDone(String name) {
    return 'أصبح $name المصرفي ومضيف الجلسة.';
  }

  @override
  String get kickTitle => 'إخراج اللاعب؟';

  @override
  String kickBody(String name) {
    return 'هل تريد فعلًا إخراج $name من الجلسة؟';
  }

  @override
  String get kickAction => 'إخراج';

  @override
  String kickDone(String name) {
    return 'تم إخراج $name من الجلسة.';
  }

  @override
  String get endTitle => 'إنهاء الجلسة؟';

  @override
  String get endBody => 'ستنتهي اللعبة نهائيًا للجميع وتظهر شاشة الملخص.';

  @override
  String get endAction => 'إنهاء اللعبة';

  @override
  String get removedTitle => 'تم إخراجك من اللعبة';

  @override
  String get removedBody =>
      'أخرجك المصرفي من هذه الجلسة. يمكنك الانضمام إلى لعبة أخرى من الشاشة الرئيسية.';

  @override
  String get summaryChampion => 'البطل الأكبر';

  @override
  String get summaryAnalytics => 'إحصاءات الجلسة';

  @override
  String get summaryStandings => 'الترتيب النهائي';

  @override
  String get summaryMoneyInPlay => 'الأموال في اللعبة';

  @override
  String get summaryParticipants => 'المشاركون';

  @override
  String summaryPlayerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count لاعب',
      many: '$count لاعبًا',
      few: '$count لاعبين',
      two: 'لاعبان',
      one: 'لاعب واحد',
    );
    return '$_temp0';
  }

  @override
  String get summarySaveExit => 'حفظ وخروج';

  @override
  String get summaryVolume => 'إجمالي التداول';

  @override
  String get summaryLength => 'مدة اللعبة';

  @override
  String summaryHoursMinutes(int hours, int minutes) {
    return '$hours س $minutes د';
  }

  @override
  String summaryMinutes(int minutes) {
    return '$minutes د';
  }

  @override
  String get summaryGoCollected => 'مكافآت الانطلاق';

  @override
  String summaryTimes(int count) {
    return '$count×';
  }

  @override
  String get summaryBiggestEarner => 'الأكثر ربحًا';

  @override
  String get summaryBiggestSpender => 'الأكثر إنفاقًا';

  @override
  String get summaryMostActive => 'الأكثر نشاطًا';

  @override
  String summaryMoves(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count عملية',
      many: '$count عملية',
      few: '$count عمليات',
      two: 'عمليتان',
      one: 'عملية واحدة',
    );
    return '$name · $_temp0';
  }

  @override
  String get historyTitle => 'الألعاب السابقة';

  @override
  String get historyLoadFailed => 'تعذّر تحميل ألعابك. اضغط لإعادة المحاولة.';

  @override
  String get historyEmpty => 'ستظهر الألعاب المنتهية هنا.';

  @override
  String get historyGames => 'الألعاب';

  @override
  String get historyWins => 'الانتصارات';

  @override
  String get historyAsBanker => 'كمصرفي';

  @override
  String historyBankerTag(String name) {
    return '$name • المصرفي';
  }

  @override
  String get qrJoinCode => 'رمز الانضمام';

  @override
  String get qrCopyCode => 'نسخ الرمز';

  @override
  String get txTransferDone => 'تم إرسال الدفعة';

  @override
  String get txPaidBank => 'تم الدفع للبنك';

  @override
  String get txReceivedBank => 'تم الاستلام من البنك';

  @override
  String get txReversed => 'تم عكس العملية';

  @override
  String get goCollected => 'تم تحصيل مكافأة الانطلاق';

  @override
  String get goWaiting => 'بانتظار موافقة المصرفي…';

  @override
  String get goApproved => 'تمت الموافقة على الطلب';

  @override
  String get goDeclined => 'تم رفض الطلب';

  @override
  String get errInsufficientFunds => 'رصيدك لا يكفي لهذه الدفعة.';

  @override
  String get errSessionClosed => 'هذه الجلسة لم تعد نشطة.';

  @override
  String get errNotInSession => 'لست عضوًا نشطًا في هذه الجلسة.';

  @override
  String get errCannotPaySelf => 'لا يمكنك الدفع لنفسك.';

  @override
  String get errRecipientNotFound => 'هذا اللاعب لم يعد في الجلسة.';

  @override
  String get errAlreadyReversed => 'سبق عكس هذه العملية.';

  @override
  String get errCannotReverseReversal => 'لا يمكن عكس عملية عكس.';

  @override
  String get errOnlyBanker => 'المصرفي وحده يستطيع فعل ذلك.';

  @override
  String get errGoPending => 'لديك طلب قيد الانتظار.';

  @override
  String get errInvalidSession =>
      'رمز الجلسة غير صالح. تحقق منه وحاول مرة أخرى.';

  @override
  String get errKicked => 'تم إخراجك من هذه الجلسة ولا يمكنك العودة إليها.';

  @override
  String get errRejoin => 'تعذّرت العودة إلى الجلسة.';

  @override
  String get errNetwork => 'خطأ في الشبكة. تحقق من اتصالك.';

  @override
  String get errSessionNotFound =>
      'لم يتم العثور على الجلسة. انضم مجددًا من الشاشة الرئيسية.';

  @override
  String get errGeneric => 'حدث خطأ ما. حاول مرة أخرى.';
}
