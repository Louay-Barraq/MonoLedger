/// Parses session join codes from manual entry or QR payloads.
class JoinCodeParser {
  static const String joinUriPrefix = 'monoledger://join';

  /// Builds the QR payload for a session code.
  static String encodeForQr(String sessionCode) {
    return '$joinUriPrefix?code=${sessionCode.trim().toUpperCase()}';
  }

  /// Returns a normalized 6-character code, or null if invalid.
  static String? parse(String raw) {
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return null;

    final upper = trimmed.toUpperCase();

    if (upper.startsWith('MONOLEDGER://JOIN')) {
      final uri = Uri.tryParse(upper.replaceFirst('MONOLEDGER://', 'monoledger://'));
      final code = uri?.queryParameters['code'];
      if (code != null) return _normalizeCode(code);
    }

    if (upper.contains('CODE=')) {
      final match = RegExp(r'code=([A-Za-z0-9]{6})', caseSensitive: false).firstMatch(upper);
      if (match != null) return _normalizeCode(match.group(1)!);
    }

    return _normalizeCode(upper);
  }

  static String? _normalizeCode(String value) {
    final code = value.replaceAll(RegExp(r'[^A-Za-z0-9]'), '').toUpperCase();
    if (code.length != 6) return null;
    return code;
  }
}
