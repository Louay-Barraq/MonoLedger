// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'MonoLedger';

  @override
  String get brandMono => 'Mono';

  @override
  String get brandLedger => 'Ledger';

  @override
  String get commonCancel => 'ANNULER';

  @override
  String get commonConfirm => 'CONFIRMER';

  @override
  String get commonDelete => 'SUPPRIMER';

  @override
  String get commonContinue => 'CONTINUER';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonPlayer => 'Joueur';

  @override
  String get commonUnknown => 'Inconnu';

  @override
  String get commonBanker => 'BANQUIER';

  @override
  String get commonYou => 'VOUS';

  @override
  String get commonTheBank => 'La Banque';

  @override
  String get codeCopied => 'Code copié dans le presse-papiers';

  @override
  String get settingsTitle => 'PARAMÈTRES';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsHelp => 'Aide et FAQ';

  @override
  String get settingsHelpSubtitle => 'Questions fréquentes';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsAboutSubtitle => 'L\'application et son développeur';

  @override
  String get settingsHaptics => 'Retour haptique';

  @override
  String get settingsHapticsSubtitle => 'Vibration au glissement pour payer';

  @override
  String settingsVersion(String version) {
    return 'Version $version';
  }

  @override
  String get settingsSectionGeneral => 'GÉNÉRAL';

  @override
  String get settingsSectionSupport => 'ASSISTANCE';

  @override
  String get settingsSectionPrivacy => 'CONFIDENTIALITÉ';

  @override
  String get settingsPrivacyPolicy => 'Politique de confidentialité';

  @override
  String get settingsPrivacyPolicySubtitle =>
      'Ce que MonoLedger conserve et pourquoi';

  @override
  String get settingsDeleteData => 'Supprimer mes données';

  @override
  String get settingsDeleteDataSubtitle =>
      'Supprimer votre compte et votre historique';

  @override
  String get settingsDeleting => 'Suppression…';

  @override
  String get deleteDataTitle => 'Supprimer mes données ?';

  @override
  String get deleteDataBody =>
      'Cela supprime votre compte MonoLedger, votre profil et votre historique de parties. Vous quittez toute partie en cours. Dans les parties jouées avec d\'autres, vos entrées restent sous le nom « Joueur supprimé » pour que leurs comptes restent justes. Cette action est irréversible.';

  @override
  String get deleteDataFailed =>
      'Impossible de supprimer vos données. Vérifiez votre connexion et réessayez.';

  @override
  String get authInitFailed =>
      'Impossible de démarrer MonoLedger. Vérifiez votre connexion et réessayez.';

  @override
  String get helpTitle => 'AIDE ET FAQ';

  @override
  String get helpIntro =>
      'Réponses rapides sur les parties, les paiements et les rôles.';

  @override
  String get aboutTitle => 'À PROPOS';

  @override
  String get aboutAppHeading => 'MonoLedger';

  @override
  String get aboutAppBody =>
      'MonoLedger transforme vos soirées jeux en un livre de comptes numérique. Créez ou rejoignez une partie, suivez les soldes en temps réel, payez la banque ou les autres joueurs d\'un geste et consultez chaque mouvement dans un historique partagé.';

  @override
  String get aboutDeveloperHeading => 'Développeur';

  @override
  String get aboutDeveloperBody =>
      'MonoLedger a été créé par Louay Barraq, pour des soirées jeux simples et rapides entre amis et en famille.';

  @override
  String get faqQ1 => 'Qu\'est-ce que MonoLedger ?';

  @override
  String get faqA1 =>
      'MonoLedger gère l\'argent de vos soirées jeux de société. Il remplace les billets par des soldes en direct, un historique partagé et des paiements par glissement.';

  @override
  String get faqQ2 => 'Comment créer une partie ?';

  @override
  String get faqA2 =>
      'Sur l\'écran d\'accueil, touchez Créer une partie, choisissez le capital de départ et le montant du Départ, saisissez votre nom puis partagez le code à 6 caractères ou le QR code.';

  @override
  String get faqQ3 => 'Comment rejoindre une partie ?';

  @override
  String get faqA3 =>
      'Touchez Rejoindre, puis saisissez le code ou scannez le QR code de l\'hôte. Entrez votre nom et confirmez.';

  @override
  String get faqQ4 => 'Qui est le Banquier ?';

  @override
  String get faqA4 =>
      'Le Banquier héberge la partie. Il peut la terminer, retirer des joueurs, transmettre son rôle, approuver les salaires du Départ, verser de l\'argent de la banque et annuler un paiement erroné.';

  @override
  String get faqQ5 => 'Comment fonctionne le salaire du Départ ?';

  @override
  String get faqA5 =>
      'Quand vous passez par la case Départ, touchez Toucher le salaire dans l\'onglet Portefeuille. Les joueurs envoient une demande que le Banquier accepte ou refuse ; le Banquier l\'encaisse immédiatement.';

  @override
  String get faqQ6 => 'Puis-je quitter puis revenir ?';

  @override
  String get faqA6 =>
      'Oui. Si vous quittez la partie, vous pouvez la rejoindre avec son code et vous retrouvez le solde que vous aviez.';

  @override
  String get faqQ7 => 'Que se passe-t-il si je suis retiré ?';

  @override
  String get faqA7 =>
      'Vous quittez la liste des joueurs et ne pouvez plus rejoindre cette partie. Un message vous informe et vous revenez à l\'accueil.';

  @override
  String get faqQ8 => 'Peut-on annuler un paiement ?';

  @override
  String get faqA8 =>
      'Oui. Le Banquier peut appuyer longuement sur une opération de l\'historique pour l\'annuler une fois. L\'annulation apparaît comme une ligne visible par tous.';

  @override
  String get faqQ9 => 'Mes données sont-elles stockées en ligne ?';

  @override
  String get faqA9 =>
      'Les parties, soldes et paiements sont stockés en ligne pour que chaque joueur les voie en direct. Vous pouvez supprimer vos données à tout moment dans les Paramètres.';

  @override
  String get faqQ10 => 'Pour quels jeux ?';

  @override
  String get faqA10 =>
      'Tout jeu de société avec de l\'argent fictif. Les valeurs par défaut (1 500 au départ, 200 au Départ) conviennent aux grands classiques d\'achat de propriétés.';

  @override
  String get homeCreateSession => 'CRÉER UNE PARTIE';

  @override
  String get homeJoinSession => 'REJOINDRE';

  @override
  String get homeTagline => 'L\'ARGENT DE VOS JEUX DE SOCIÉTÉ';

  @override
  String get homeFooter =>
      'De 2 à 10 joueurs.\nPour tout jeu de société\navec de l\'argent fictif.';

  @override
  String get homeCapacity => 'CAPACITÉ';

  @override
  String get homeSyncing => 'SYNCHRO';

  @override
  String get homeCapacityValue => '2-10 JOUEURS';

  @override
  String get homeSyncingValue => 'EN DIRECT';

  @override
  String get homePastGames => 'Parties passées';

  @override
  String get onboardingTitle1 => 'BIENVENUE SUR\nMONOLEDGER';

  @override
  String get onboardingBody1 =>
      'L\'argent de vos jeux de société préférés, sur le téléphone de chaque joueur.';

  @override
  String get onboardingTitle2 => 'SYNCHRO\nEN DIRECT';

  @override
  String get onboardingBody2 =>
      'Tous les joueurs restent à jour en temps réel. Fini les calculs à la main et le désordre des billets.';

  @override
  String get onboardingTitle3 => 'SÛR ET\nPRIVÉ';

  @override
  String get onboardingBody3 =>
      'Les paiements passent par des connexions chiffrées. Concentrez-vous sur le jeu, nous gérons les chiffres.';

  @override
  String get onboardingStart => 'C\'EST PARTI';

  @override
  String get createHeader => 'CONFIGURATION';

  @override
  String get createTitle => 'Créer une partie';

  @override
  String get createSubtitle => 'Fixez les règles de l\'argent de votre partie.';

  @override
  String get createYourName => 'VOTRE NOM';

  @override
  String get createNameHint => 'Nom du banquier';

  @override
  String get createCurrency => 'SYMBOLE MONÉTAIRE';

  @override
  String get createStartingCapital => 'CAPITAL DE DÉPART';

  @override
  String get createPresetStandard => 'CLASSIQUE';

  @override
  String get createPresetPro => 'NIVEAU PRO';

  @override
  String get createPresetCapitalist => 'CAPITALISTE';

  @override
  String get createPresetWhale => 'GRAND LUXE';

  @override
  String get createEnterAmount => 'SAISIR UN MONTANT';

  @override
  String get createCustomAmount => 'AUTRE MONTANT';

  @override
  String get createGoAmount => 'SALAIRE DU DÉPART';

  @override
  String get createNameRequired => 'Saisissez votre nom pour continuer.';

  @override
  String get createCapitalInvalid =>
      'Le capital de départ doit être supérieur à 0.';

  @override
  String get createGoInvalid =>
      'Le salaire du Départ ne peut pas être négatif.';

  @override
  String get createSubmit => 'CRÉER ET JOUER';

  @override
  String get joinHeader => 'CONNEXION';

  @override
  String get joinTitle => 'Rejoindre une partie';

  @override
  String get joinSubtitle =>
      'Saisissez le code de la partie ou scannez le QR code de l\'hôte.';

  @override
  String get joinEnterCode => 'SAISIR LE CODE';

  @override
  String get joinEnterCodeSubtitle => 'Tapez le code à 6 caractères';

  @override
  String get joinScanQr => 'SCANNER LE QR CODE';

  @override
  String get joinScanQrSubtitle => 'Utilisez votre appareil photo';

  @override
  String get joinCodeHeader => 'CODE DE PARTIE';

  @override
  String get joinCodeTitle => 'Saisir le code';

  @override
  String get joinCodeSubtitle =>
      'Saisissez le code à 6 caractères et votre nom pour rejoindre.';

  @override
  String get joinCodeLabel => 'CODE DE PARTIE';

  @override
  String get joinNameLabel => 'VOTRE NOM';

  @override
  String get joinNameHint => 'Nom';

  @override
  String get joinCodeInvalid => 'Saisissez un code valide à 6 caractères.';

  @override
  String get joinNameRequired => 'Saisissez votre nom.';

  @override
  String get joinConfirm => 'REJOINDRE';

  @override
  String get scanTitle => 'SCANNER';

  @override
  String get scanHint => 'Visez le QR code de la partie affiché par l\'hôte';

  @override
  String get dashboardRoomCode => 'CODE DE PARTIE';

  @override
  String get navWallet => 'PORTEFEUILLE';

  @override
  String get navLedger => 'HISTORIQUE';

  @override
  String get navPlayers => 'JOUEURS';

  @override
  String get leaveTitle => 'Quitter la partie ?';

  @override
  String get leaveBodyBanker =>
      'Si vous quittez en tant que Banquier, le rôle et la partie passent à un autre joueur au hasard. Continuer ?';

  @override
  String get leaveBodyLast =>
      'Vous êtes le seul joueur. Quitter mettra fin à la partie pour tout le monde. Continuer ?';

  @override
  String get leaveBody =>
      'Vous allez quitter cette partie et revenir à l\'accueil. Continuer ?';

  @override
  String get leaveAction => 'QUITTER';

  @override
  String get walletCurrentBalance => 'SOLDE ACTUEL';

  @override
  String walletVsStart(String change) {
    return '$change% depuis le début';
  }

  @override
  String get walletGo => 'DÉPART';

  @override
  String get walletCollectSalary => 'TOUCHER LE SALAIRE';

  @override
  String get walletAwaitingBanker => 'EN ATTENTE DU BANQUIER';

  @override
  String get walletPayBank => 'PAYER LA BANQUE';

  @override
  String get walletFromBank => 'RECEVOIR DE LA BANQUE';

  @override
  String get walletPlayers => 'Joueurs';

  @override
  String walletActiveCount(int count) {
    return '$count ACTIFS';
  }

  @override
  String get walletNoPlayers => 'Aucun joueur dans la partie';

  @override
  String get walletTapToPay => 'TOUCHER POUR PAYER';

  @override
  String walletRank(int rank) {
    return 'RANG N° $rank';
  }

  @override
  String get ledgerTitle => 'Historique';

  @override
  String get ledgerSubtitle => 'Toutes les opérations de la partie';

  @override
  String get ledgerEmpty => 'Aucune opération pour l\'instant';

  @override
  String get ledgerFromBank => 'De la banque';

  @override
  String get ledgerToBank => 'Vers la banque';

  @override
  String get ledgerReversed => 'ANNULÉ';

  @override
  String get ledgerJustNow => 'À l\'instant';

  @override
  String ledgerMinutesAgo(int minutes) {
    return 'il y a $minutes min';
  }

  @override
  String ledgerHoursAgo(int hours) {
    return 'il y a $hours h';
  }

  @override
  String ledgerDaysAgo(int days) {
    return 'il y a $days j';
  }

  @override
  String get memoPassedGo => 'DÉPART PASSÉ';

  @override
  String get memoFromBank => 'DE LA BANQUE';

  @override
  String get memoPayBank => 'À LA BANQUE';

  @override
  String get memoTransfer => 'VIREMENT';

  @override
  String get memoPayment => 'PAIEMENT';

  @override
  String get memoReversal => 'ANNULATION';

  @override
  String get reverseTitle => 'Annuler l\'opération ?';

  @override
  String reverseBody(String title, String amount) {
    return '$title ($amount) sera annulé par une opération inverse dans l\'historique. Cela n\'est possible qu\'une fois.';
  }

  @override
  String get reverseAction => 'ANNULER L\'OPÉRATION';

  @override
  String get playersTitle => 'JOUEURS';

  @override
  String get playersNone => 'Aucun joueur actif';

  @override
  String get playersBankCard => 'LA BANQUE';

  @override
  String playersBankerName(String name) {
    return 'Banquier : $name';
  }

  @override
  String get padPayingTo => 'PAIEMENT À';

  @override
  String get padReceivingFrom => 'REÇU DE';

  @override
  String get padSlideToPay => 'GLISSER POUR PAYER';

  @override
  String get padSlideToReceive => 'GLISSER POUR RECEVOIR';

  @override
  String get padProcessing => 'EN COURS...';

  @override
  String get padLargePayoutTitle => 'Gros versement de la banque';

  @override
  String padLargePayoutBody(String amount) {
    return 'Ce versement ($amount) dépasse la moitié de tout l\'argent en jeu. Confirmez pour continuer.';
  }

  @override
  String get goPassed => 'DÉPART PASSÉ';

  @override
  String get goDecline => 'REFUSER';

  @override
  String get goApprove => 'ACCEPTER';

  @override
  String get settingsGameTitle => 'RÉGLAGES DE PARTIE';

  @override
  String get settingsGameRules => 'RÈGLES MONÉTAIRES';

  @override
  String get settingsGamePlayers => 'JOUEURS ACTIFS';

  @override
  String get settingsGameManagement => 'GESTION DE LA PARTIE';

  @override
  String get settingsGameExit => 'SORTIE';

  @override
  String get settingsGameSessionCode => 'CODE DE PARTIE';

  @override
  String get settingsGameStartingCapital => 'Capital de départ';

  @override
  String get settingsGameGoBonus => 'Prime Départ';

  @override
  String get settingsGameTransferTooltip => 'Nommer Banquier';

  @override
  String get settingsGameKickTooltip => 'Retirer le joueur';

  @override
  String get settingsGameLeave => 'QUITTER LA PARTIE';

  @override
  String get settingsGameEnd => 'TERMINER LA PARTIE';

  @override
  String transferTitle(String name) {
    return 'Nommer $name Banquier ?';
  }

  @override
  String transferBody(String name) {
    return '$name devient Banquier et hôte de la partie. Vous perdez les commandes du Banquier.';
  }

  @override
  String get transferAction => 'TRANSFÉRER';

  @override
  String transferDone(String name) {
    return '$name est maintenant Banquier et hôte de la partie.';
  }

  @override
  String get kickTitle => 'Retirer le joueur ?';

  @override
  String kickBody(String name) {
    return 'Voulez-vous vraiment retirer $name de la partie ?';
  }

  @override
  String get kickAction => 'RETIRER';

  @override
  String kickDone(String name) {
    return '$name a été retiré de la partie.';
  }

  @override
  String get endTitle => 'Terminer la partie ?';

  @override
  String get endBody =>
      'La partie se terminera définitivement pour tout le monde et le résumé s\'affichera.';

  @override
  String get endAction => 'TERMINER';

  @override
  String get removedTitle => 'Retiré de la partie';

  @override
  String get removedBody =>
      'Le Banquier vous a retiré de cette partie. Vous pouvez en rejoindre une autre depuis l\'accueil.';

  @override
  String get summaryChampion => 'GRAND VAINQUEUR';

  @override
  String get summaryAnalytics => 'STATISTIQUES';

  @override
  String get summaryStandings => 'CLASSEMENT FINAL';

  @override
  String get summaryMoneyInPlay => 'Argent en jeu';

  @override
  String get summaryParticipants => 'Participants';

  @override
  String summaryPlayerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count joueurs',
      one: '1 joueur',
    );
    return '$_temp0';
  }

  @override
  String get summarySaveExit => 'ENREGISTRER ET QUITTER';

  @override
  String get summaryVolume => 'Volume échangé';

  @override
  String get summaryLength => 'Durée';

  @override
  String summaryHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String summaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get summaryGoCollected => 'Salaires Départ';

  @override
  String summaryTimes(int count) {
    return '$count×';
  }

  @override
  String get summaryBiggestEarner => 'Plus gros gain';

  @override
  String get summaryBiggestSpender => 'Plus grosse dépense';

  @override
  String get summaryMostActive => 'Le plus actif';

  @override
  String summaryMoves(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count actions',
      one: '1 action',
    );
    return '$name · $_temp0';
  }

  @override
  String get historyTitle => 'PARTIES PASSÉES';

  @override
  String get historyLoadFailed =>
      'Impossible de charger vos parties. Touchez pour réessayer.';

  @override
  String get historyEmpty => 'Les parties terminées apparaîtront ici.';

  @override
  String get historyGames => 'PARTIES';

  @override
  String get historyWins => 'VICTOIRES';

  @override
  String get historyAsBanker => 'BANQUIER';

  @override
  String historyBankerTag(String name) {
    return '$name • BANQUIER';
  }

  @override
  String get qrJoinCode => 'CODE DE PARTIE';

  @override
  String get qrCopyCode => 'COPIER LE CODE';

  @override
  String get txTransferDone => 'Paiement envoyé';

  @override
  String get txPaidBank => 'Payé à la banque';

  @override
  String get txReceivedBank => 'Reçu de la banque';

  @override
  String get txReversed => 'Opération annulée';

  @override
  String get goCollected => 'Salaire du Départ encaissé';

  @override
  String get goWaiting => 'En attente de l\'accord du Banquier…';

  @override
  String get goApproved => 'Demande acceptée';

  @override
  String get goDeclined => 'Demande refusée';

  @override
  String get errInsufficientFunds => 'Fonds insuffisants pour ce paiement.';

  @override
  String get errSessionClosed => 'Cette partie n\'est plus active.';

  @override
  String get errNotInSession =>
      'Vous n\'êtes pas un membre actif de cette partie.';

  @override
  String get errCannotPaySelf => 'Vous ne pouvez pas vous payer vous-même.';

  @override
  String get errRecipientNotFound => 'Ce joueur n\'est plus dans la partie.';

  @override
  String get errAlreadyReversed => 'Cette opération a déjà été annulée.';

  @override
  String get errCannotReverseReversal =>
      'Une annulation ne peut pas être annulée.';

  @override
  String get errOnlyBanker => 'Seul le Banquier peut faire cela.';

  @override
  String get errGoPending => 'Vous avez déjà une demande en attente.';

  @override
  String get errInvalidSession =>
      'Code de partie invalide. Vérifiez et réessayez.';

  @override
  String get errKicked =>
      'Vous avez été retiré de cette partie et ne pouvez pas la rejoindre.';

  @override
  String get errRejoin => 'Impossible de rejoindre cette partie.';

  @override
  String get errNetwork => 'Erreur réseau. Vérifiez votre connexion.';

  @override
  String get errSessionNotFound =>
      'Partie introuvable. Rejoignez-la depuis l\'accueil.';

  @override
  String get errGeneric => 'Une erreur est survenue. Veuillez réessayer.';
}
