/// Keys for [GoRouter] `extra` when navigating to `/payment-pad`.
class PaymentPadRoute {
  static const String targetName = 'targetName';
  static const String isPaying = 'isPaying';
  static const String sessionId = 'sessionId';
  static const String currency = 'currency';
  static const String recipientPlayerId = 'recipientPlayerId';
  static const String isBankTarget = 'isBankTarget';

  static Map<String, dynamic> bank({
    required String sessionId,
    required String currency,
    required bool isPaying,
  }) {
    return {
      PaymentPadRoute.targetName: 'The Bank',
      PaymentPadRoute.isPaying: isPaying,
      PaymentPadRoute.sessionId: sessionId,
      PaymentPadRoute.currency: currency,
      PaymentPadRoute.recipientPlayerId: null,
      PaymentPadRoute.isBankTarget: true,
    };
  }

  static Map<String, dynamic> player({
    required String sessionId,
    required String currency,
    required String targetName,
    required String recipientPlayerId,
    required bool isPaying,
  }) {
    return {
      PaymentPadRoute.targetName: targetName,
      PaymentPadRoute.isPaying: isPaying,
      PaymentPadRoute.sessionId: sessionId,
      PaymentPadRoute.currency: currency,
      PaymentPadRoute.recipientPlayerId: recipientPlayerId,
      PaymentPadRoute.isBankTarget: false,
    };
  }
}
