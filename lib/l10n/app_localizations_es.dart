// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appName => 'MonoLedger';

  @override
  String get brandMono => 'Mono';

  @override
  String get brandLedger => 'Ledger';

  @override
  String get commonCancel => 'CANCELAR';

  @override
  String get commonConfirm => 'CONFIRMAR';

  @override
  String get commonDelete => 'ELIMINAR';

  @override
  String get commonContinue => 'CONTINUAR';

  @override
  String get commonRetry => 'Reintentar';

  @override
  String get commonPlayer => 'Jugador';

  @override
  String get commonUnknown => 'Desconocido';

  @override
  String get commonBanker => 'BANQUERO';

  @override
  String get commonYou => 'TÚ';

  @override
  String get commonTheBank => 'La Banca';

  @override
  String get codeCopied => 'Código copiado al portapapeles';

  @override
  String get settingsTitle => 'AJUSTES';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsHelp => 'Ayuda y preguntas';

  @override
  String get settingsHelpSubtitle => 'Preguntas frecuentes';

  @override
  String get settingsAbout => 'Acerca de';

  @override
  String get settingsAboutSubtitle => 'La app y su desarrollador';

  @override
  String get settingsHaptics => 'Vibración';

  @override
  String get settingsHapticsSubtitle => 'Vibrar al deslizar para pagar';

  @override
  String settingsVersion(String version) {
    return 'Versión $version';
  }

  @override
  String get settingsSectionGeneral => 'GENERAL';

  @override
  String get settingsSectionSupport => 'SOPORTE';

  @override
  String get settingsSectionPrivacy => 'PRIVACIDAD';

  @override
  String get settingsPrivacyPolicy => 'Política de privacidad';

  @override
  String get settingsPrivacyPolicySubtitle => 'Qué guarda MonoLedger y por qué';

  @override
  String get settingsDeleteData => 'Eliminar mis datos';

  @override
  String get settingsDeleteDataSubtitle =>
      'Elimina tu cuenta e historial de partidas';

  @override
  String get settingsDeleting => 'Eliminando…';

  @override
  String get deleteDataTitle => '¿Eliminar mis datos?';

  @override
  String get deleteDataBody =>
      'Se eliminarán tu cuenta de MonoLedger, tu perfil y tu historial de partidas. Saldrás de cualquier partida en curso. En las partidas jugadas con otras personas, tus movimientos quedarán como «Jugador eliminado» para que sus cuentas sigan cuadrando. No se puede deshacer.';

  @override
  String get deleteDataFailed =>
      'No se pudieron eliminar tus datos. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get authInitFailed =>
      'No se pudo iniciar MonoLedger. Revisa tu conexión e inténtalo de nuevo.';

  @override
  String get helpTitle => 'AYUDA Y PREGUNTAS';

  @override
  String get helpIntro => 'Respuestas rápidas sobre partidas, pagos y roles.';

  @override
  String get aboutTitle => 'ACERCA DE';

  @override
  String get aboutAppHeading => 'MonoLedger';

  @override
  String get aboutAppBody =>
      'MonoLedger convierte tus noches de juegos en un libro de cuentas digital. Crea o únete a una partida, sigue los saldos en tiempo real, paga a la banca o a otros jugadores deslizando y revisa cada movimiento en un historial compartido.';

  @override
  String get aboutDeveloperHeading => 'Desarrollador';

  @override
  String get aboutDeveloperBody =>
      'MonoLedger fue creado por Louay Barraq, pensado para noches de juegos rápidas y sencillas con amigos y familia.';

  @override
  String get faqQ1 => '¿Qué es MonoLedger?';

  @override
  String get faqA1 =>
      'MonoLedger gestiona el dinero de tus noches de juegos de mesa. Sustituye los billetes por saldos en vivo, un historial compartido y pagos deslizando.';

  @override
  String get faqQ2 => '¿Cómo creo una partida?';

  @override
  String get faqA2 =>
      'En la pantalla de inicio, toca Crear partida, elige el dinero inicial y el sueldo de la Salida, escribe tu nombre y comparte el código de 6 caracteres o el código QR.';

  @override
  String get faqQ3 => '¿Cómo me uno a una partida?';

  @override
  String get faqA3 =>
      'Toca Unirse a partida y escribe el código o escanea el QR del anfitrión. Pon tu nombre y confirma.';

  @override
  String get faqQ4 => '¿Qué es el Banquero?';

  @override
  String get faqA4 =>
      'El Banquero organiza la partida. Puede terminarla, expulsar jugadores, pasar su rol, aprobar los sueldos de la Salida, pagar desde la banca y deshacer un pago erróneo.';

  @override
  String get faqQ5 => '¿Cómo funciona el sueldo de la Salida?';

  @override
  String get faqA5 =>
      'Cuando pases por la Salida, toca Cobrar sueldo en la pestaña Cartera. Los demás envían una solicitud que el Banquero aprueba o rechaza; el Banquero cobra al instante.';

  @override
  String get faqQ6 => '¿Puedo salir y volver?';

  @override
  String get faqA6 =>
      'Sí. Si sales, puedes volver a la misma partida con su código y conservas el saldo que tenías.';

  @override
  String get faqQ7 => '¿Qué pasa si me expulsan?';

  @override
  String get faqA7 =>
      'Sales de la lista de jugadores y no puedes volver a esa partida. Verás un aviso y volverás al inicio.';

  @override
  String get faqQ8 => '¿Se puede deshacer un pago?';

  @override
  String get faqA8 =>
      'Sí. El Banquero puede mantener pulsado un movimiento del historial para anularlo una vez. La anulación aparece como una línea que todos ven.';

  @override
  String get faqQ9 => '¿Mis datos se guardan en internet?';

  @override
  String get faqA9 =>
      'Las partidas, saldos y pagos se guardan en línea para que todos los vean al instante. Puedes eliminar tus datos cuando quieras en Ajustes.';

  @override
  String get faqQ10 => '¿Para qué juegos sirve?';

  @override
  String get faqA10 =>
      'Para cualquier juego de mesa con dinero ficticio. Los valores iniciales (1500 al empezar, 200 por pasar por la Salida) encajan con los clásicos de compra de propiedades.';

  @override
  String get homeCreateSession => 'CREAR PARTIDA';

  @override
  String get homeJoinSession => 'UNIRSE A PARTIDA';

  @override
  String get homeTagline => 'DINERO DIGITAL PARA JUEGOS DE MESA';

  @override
  String get homeFooter =>
      'De 2 a 10 jugadores.\nPara cualquier juego\ncon dinero ficticio.';

  @override
  String get homeCapacity => 'CAPACIDAD';

  @override
  String get homeSyncing => 'SINCRONÍA';

  @override
  String get homeCapacityValue => '2-10 JUGADORES';

  @override
  String get homeSyncingValue => 'EN VIVO';

  @override
  String get homePastGames => 'Partidas anteriores';

  @override
  String get onboardingTitle1 => 'BIENVENIDO A\nMONOLEDGER';

  @override
  String get onboardingBody1 =>
      'El dinero de tus juegos de mesa favoritos, en el móvil de cada jugador.';

  @override
  String get onboardingTitle2 => 'SINCRONÍA\nEN VIVO';

  @override
  String get onboardingBody2 =>
      'Todos los jugadores se actualizan al instante. Se acabaron las cuentas a mano y el caos de billetes.';

  @override
  String get onboardingTitle3 => 'SEGURO Y\nPRIVADO';

  @override
  String get onboardingBody3 =>
      'Los pagos viajan por conexiones cifradas. Concéntrate en jugar, nosotros llevamos las cuentas.';

  @override
  String get onboardingStart => 'EMPEZAR';

  @override
  String get createHeader => 'CONFIGURACIÓN';

  @override
  String get createTitle => 'Crear partida';

  @override
  String get createSubtitle => 'Define las reglas del dinero de tu partida.';

  @override
  String get createYourName => 'TU NOMBRE';

  @override
  String get createNameHint => 'Nombre del banquero';

  @override
  String get createCurrency => 'SÍMBOLO DE MONEDA';

  @override
  String get createStartingCapital => 'DINERO INICIAL';

  @override
  String get createPresetStandard => 'CLÁSICO';

  @override
  String get createPresetPro => 'NIVEL PRO';

  @override
  String get createPresetCapitalist => 'CAPITALISTA';

  @override
  String get createPresetWhale => 'MAGNATE';

  @override
  String get createEnterAmount => 'ESCRIBE LA CANTIDAD';

  @override
  String get createCustomAmount => 'OTRA CANTIDAD';

  @override
  String get createGoAmount => 'SUELDO DE SALIDA';

  @override
  String get createNameRequired => 'Escribe tu nombre para continuar.';

  @override
  String get createCapitalInvalid => 'El dinero inicial debe ser mayor que 0.';

  @override
  String get createGoInvalid => 'El sueldo de salida no puede ser negativo.';

  @override
  String get createSubmit => 'CREAR Y JUGAR';

  @override
  String get joinHeader => 'CONEXIÓN';

  @override
  String get joinTitle => 'Unirse a partida';

  @override
  String get joinSubtitle =>
      'Escribe el código de la partida o escanea el QR del anfitrión.';

  @override
  String get joinEnterCode => 'ESCRIBIR CÓDIGO';

  @override
  String get joinEnterCodeSubtitle => 'Teclea el código de 6 caracteres';

  @override
  String get joinScanQr => 'ESCANEAR QR';

  @override
  String get joinScanQrSubtitle => 'Usa la cámara para escanear';

  @override
  String get joinCodeHeader => 'CÓDIGO DE PARTIDA';

  @override
  String get joinCodeTitle => 'Escribe el código';

  @override
  String get joinCodeSubtitle =>
      'Escribe el código de 6 caracteres y tu nombre para unirte.';

  @override
  String get joinCodeLabel => 'CÓDIGO DE PARTIDA';

  @override
  String get joinNameLabel => 'TU NOMBRE';

  @override
  String get joinNameHint => 'Nombre';

  @override
  String get joinCodeInvalid => 'Escribe un código válido de 6 caracteres.';

  @override
  String get joinNameRequired => 'Escribe tu nombre.';

  @override
  String get joinConfirm => 'UNIRME';

  @override
  String get scanTitle => 'ESCANEAR QR';

  @override
  String get scanHint =>
      'Apunta la cámara al código QR de la partida del anfitrión';

  @override
  String get dashboardRoomCode => 'CÓDIGO DE SALA';

  @override
  String get navWallet => 'CARTERA';

  @override
  String get navLedger => 'HISTORIAL';

  @override
  String get navPlayers => 'JUGADORES';

  @override
  String get leaveTitle => '¿Salir de la partida?';

  @override
  String get leaveBodyBanker =>
      'Si sales siendo Banquero, el rol y la partida pasan a otro jugador al azar. ¿Continuar?';

  @override
  String get leaveBodyLast =>
      'Eres el único jugador. Si sales, la partida terminará para todos. ¿Continuar?';

  @override
  String get leaveBody =>
      'Saldrás de esta partida y volverás al inicio. ¿Continuar?';

  @override
  String get leaveAction => 'SALIR';

  @override
  String get walletCurrentBalance => 'SALDO ACTUAL';

  @override
  String walletVsStart(String change) {
    return '$change% desde el inicio';
  }

  @override
  String get walletGo => 'SALIDA';

  @override
  String get walletCollectSalary => 'COBRAR SUELDO';

  @override
  String get walletAwaitingBanker => 'ESPERANDO AL BANQUERO';

  @override
  String get walletPayBank => 'PAGAR A LA BANCA';

  @override
  String get walletFromBank => 'COBRAR DE LA BANCA';

  @override
  String get walletPlayers => 'Jugadores';

  @override
  String walletActiveCount(int count) {
    return '$count ACTIVOS';
  }

  @override
  String get walletNoPlayers => 'Aún no hay jugadores';

  @override
  String get walletTapToPay => 'TOCA PARA PAGAR';

  @override
  String walletRank(int rank) {
    return 'PUESTO $rank';
  }

  @override
  String get ledgerTitle => 'Historial';

  @override
  String get ledgerSubtitle => 'Todos los movimientos de la partida';

  @override
  String get ledgerEmpty => 'Aún no hay movimientos';

  @override
  String get ledgerFromBank => 'De la banca';

  @override
  String get ledgerToBank => 'A la banca';

  @override
  String get ledgerReversed => 'ANULADO';

  @override
  String get ledgerJustNow => 'Ahora mismo';

  @override
  String ledgerMinutesAgo(int minutes) {
    return 'hace $minutes min';
  }

  @override
  String ledgerHoursAgo(int hours) {
    return 'hace $hours h';
  }

  @override
  String ledgerDaysAgo(int days) {
    return 'hace $days d';
  }

  @override
  String get memoPassedGo => 'PASÓ POR SALIDA';

  @override
  String get memoFromBank => 'DE LA BANCA';

  @override
  String get memoPayBank => 'A LA BANCA';

  @override
  String get memoTransfer => 'TRANSFERENCIA';

  @override
  String get memoPayment => 'PAGO';

  @override
  String get memoReversal => 'ANULACIÓN';

  @override
  String get reverseTitle => '¿Anular movimiento?';

  @override
  String reverseBody(String title, String amount) {
    return '$title ($amount) se anulará con un movimiento inverso en el historial. Solo se puede hacer una vez.';
  }

  @override
  String get reverseAction => 'ANULAR';

  @override
  String get playersTitle => 'JUGADORES';

  @override
  String get playersNone => 'No hay jugadores activos';

  @override
  String get playersBankCard => 'LA BANCA';

  @override
  String playersBankerName(String name) {
    return 'Banquero: $name';
  }

  @override
  String get padPayingTo => 'PAGANDO A';

  @override
  String get padReceivingFrom => 'RECIBIENDO DE';

  @override
  String get padSlideToPay => 'DESLIZA PARA PAGAR';

  @override
  String get padSlideToReceive => 'DESLIZA PARA COBRAR';

  @override
  String get padProcessing => 'PROCESANDO...';

  @override
  String get padLargePayoutTitle => 'Gran pago de la banca';

  @override
  String padLargePayoutBody(String amount) {
    return 'Este pago ($amount) supera la mitad de todo el dinero en juego. Confirma para continuar.';
  }

  @override
  String get goPassed => 'PASÓ POR SALIDA';

  @override
  String get goDecline => 'RECHAZAR';

  @override
  String get goApprove => 'APROBAR';

  @override
  String get settingsGameTitle => 'AJUSTES DE PARTIDA';

  @override
  String get settingsGameRules => 'REGLAS DEL DINERO';

  @override
  String get settingsGamePlayers => 'JUGADORES ACTIVOS';

  @override
  String get settingsGameManagement => 'GESTIÓN DE PARTIDA';

  @override
  String get settingsGameExit => 'SALIR';

  @override
  String get settingsGameSessionCode => 'CÓDIGO DE PARTIDA';

  @override
  String get settingsGameStartingCapital => 'Dinero inicial';

  @override
  String get settingsGameGoBonus => 'Premio de salida';

  @override
  String get settingsGameTransferTooltip => 'Hacer Banquero';

  @override
  String get settingsGameKickTooltip => 'Expulsar jugador';

  @override
  String get settingsGameLeave => 'SALIR DE LA PARTIDA';

  @override
  String get settingsGameEnd => 'TERMINAR PARTIDA';

  @override
  String transferTitle(String name) {
    return '¿Hacer Banquero a $name?';
  }

  @override
  String transferBody(String name) {
    return '$name será el Banquero y anfitrión. Perderás los controles de Banquero.';
  }

  @override
  String get transferAction => 'TRANSFERIR';

  @override
  String transferDone(String name) {
    return '$name es ahora Banquero y anfitrión.';
  }

  @override
  String get kickTitle => '¿Expulsar jugador?';

  @override
  String kickBody(String name) {
    return '¿Seguro que quieres expulsar a $name de la partida?';
  }

  @override
  String get kickAction => 'EXPULSAR';

  @override
  String kickDone(String name) {
    return '$name fue expulsado de la partida.';
  }

  @override
  String get endTitle => '¿Terminar partida?';

  @override
  String get endBody =>
      'La partida terminará definitivamente para todos y se mostrará el resumen.';

  @override
  String get endAction => 'TERMINAR';

  @override
  String get removedTitle => 'Expulsado de la partida';

  @override
  String get removedBody =>
      'El Banquero te expulsó de esta partida. Puedes unirte a otra desde el inicio.';

  @override
  String get summaryChampion => 'GRAN CAMPEÓN';

  @override
  String get summaryAnalytics => 'ESTADÍSTICAS';

  @override
  String get summaryStandings => 'CLASIFICACIÓN FINAL';

  @override
  String get summaryMoneyInPlay => 'Dinero en juego';

  @override
  String get summaryParticipants => 'Participantes';

  @override
  String summaryPlayerCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadores',
      one: '1 jugador',
    );
    return '$_temp0';
  }

  @override
  String get summarySaveExit => 'GUARDAR Y SALIR';

  @override
  String get summaryVolume => 'Volumen movido';

  @override
  String get summaryLength => 'Duración';

  @override
  String summaryHoursMinutes(int hours, int minutes) {
    return '$hours h $minutes min';
  }

  @override
  String summaryMinutes(int minutes) {
    return '$minutes min';
  }

  @override
  String get summaryGoCollected => 'Sueldos cobrados';

  @override
  String summaryTimes(int count) {
    return '$count×';
  }

  @override
  String get summaryBiggestEarner => 'Quien más ganó';

  @override
  String get summaryBiggestSpender => 'Quien más gastó';

  @override
  String get summaryMostActive => 'Más activo';

  @override
  String summaryMoves(String name, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jugadas',
      one: '1 jugada',
    );
    return '$name · $_temp0';
  }

  @override
  String get historyTitle => 'PARTIDAS ANTERIORES';

  @override
  String get historyLoadFailed =>
      'No se pudieron cargar tus partidas. Toca para reintentar.';

  @override
  String get historyEmpty => 'Las partidas terminadas aparecerán aquí.';

  @override
  String get historyGames => 'PARTIDAS';

  @override
  String get historyWins => 'VICTORIAS';

  @override
  String get historyAsBanker => 'DE BANQUERO';

  @override
  String historyBankerTag(String name) {
    return '$name • BANQUERO';
  }

  @override
  String get qrJoinCode => 'CÓDIGO PARA UNIRSE';

  @override
  String get qrCopyCode => 'COPIAR CÓDIGO';

  @override
  String get txTransferDone => 'Pago enviado';

  @override
  String get txPaidBank => 'Pagado a la banca';

  @override
  String get txReceivedBank => 'Recibido de la banca';

  @override
  String get txReversed => 'Movimiento anulado';

  @override
  String get goCollected => 'Sueldo de salida cobrado';

  @override
  String get goWaiting => 'Esperando la aprobación del Banquero…';

  @override
  String get goApproved => 'Solicitud aprobada';

  @override
  String get goDeclined => 'Solicitud rechazada';

  @override
  String get errInsufficientFunds =>
      'No tienes fondos suficientes para este pago.';

  @override
  String get errSessionClosed => 'Esta partida ya no está activa.';

  @override
  String get errNotInSession => 'No eres un miembro activo de esta partida.';

  @override
  String get errCannotPaySelf => 'No puedes pagarte a ti mismo.';

  @override
  String get errRecipientNotFound => 'Ese jugador ya no está en la partida.';

  @override
  String get errAlreadyReversed => 'Este movimiento ya se anuló.';

  @override
  String get errCannotReverseReversal => 'Una anulación no se puede anular.';

  @override
  String get errOnlyBanker => 'Solo el Banquero puede hacer esto.';

  @override
  String get errGoPending => 'Ya tienes una solicitud pendiente.';

  @override
  String get errInvalidSession =>
      'Código de partida no válido. Revísalo e inténtalo de nuevo.';

  @override
  String get errKicked => 'Te expulsaron de esta partida y no puedes volver.';

  @override
  String get errRejoin => 'No se pudo volver a la partida.';

  @override
  String get errNetwork => 'Error de red. Revisa tu conexión.';

  @override
  String get errSessionNotFound =>
      'Partida no encontrada. Únete de nuevo desde el inicio.';

  @override
  String get errGeneric => 'Algo salió mal. Inténtalo de nuevo.';
}
