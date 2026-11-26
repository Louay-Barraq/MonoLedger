// Renders the launcher icon, store icon and the localized feature graphics from
// the MonoLedger mark.
// Run: flutter test tool/render_icon_test.dart, then dart run flutter_launcher_icons
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/widgets/monoledger_logo.dart';

const _green = Color(0xFF14F195);
const _background = Color(0xFF0B0D0F);

Future<void> _loadFont(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  final loader = FontLoader(family)
    ..addFont(Future.value(ByteData.view(bytes.buffer)));
  await loader.load();
}

Future<void> _render(
  WidgetTester tester,
  Widget child,
  String path, {
  Size size = const Size(1024, 1024),
  TextDirection direction = TextDirection.ltr,
}) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: direction,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox(width: size.width, height: size.height, child: child),
        ),
      ),
    ),
  );
  await tester.runAsync(() async {
    final boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final image = await boundary.toImage();
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    File(path).writeAsBytesSync(bytes!.buffer.asUint8List());
  });
}

/// Play listing language → feature graphic tagline.
const _taglines = {
  'en-US': 'Board-game money, on every phone.',
  'fr-FR': "L'argent de vos jeux, sur chaque mobile.",
  'es-ES': 'El dinero de tus juegos, en cada móvil.',
  'ar': 'أموال ألعابك على كل هاتف',
};

class _FeatureGraphic extends StatelessWidget {
  const _FeatureGraphic({required this.tagline, required this.family});

  final String tagline;
  final String family;

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: _background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 48),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const MonoLedgerLogo(size: 280, color: _green),
              const SizedBox(width: 40),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'Mono',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextSpan(
                          text: 'Ledger',
                          style: TextStyle(color: _green),
                        ),
                      ],
                    ),
                    textDirection: TextDirection.ltr,
                    style: TextStyle(
                      fontFamily: 'Latin',
                      fontSize: 96,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tagline,
                    style: TextStyle(
                      fontFamily: family,
                      fontSize: 34,
                      color: const Color(0xB3FFFFFF),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  testWidgets('render icons and feature graphics', (tester) async {
    tester.view.physicalSize = const Size(1024, 1024);
    tester.view.devicePixelRatio = 1;
    final sdk = Platform.environment['FLUTTER_ROOT']!;
    await tester.runAsync(() async {
      await _loadFont(
        'Latin',
        '$sdk/bin/cache/artifacts/material_fonts/Roboto-Bold.ttf',
      );
      // macOS system font with Arabic glyphs.
      await _loadFont(
        'Arabic',
        '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
      );
    });

    // Full icon (legacy launchers; the 512px store icons are resized from it).
    await _render(
      tester,
      const DecoratedBox(
        decoration: BoxDecoration(color: _background),
        child: Center(child: MonoLedgerLogo(size: 900, color: _green)),
      ),
      'assets/icon/icon.png',
    );
    // Adaptive foreground. flutter_launcher_icons insets it by 16%, which keeps
    // this size inside the safe circle of round launcher masks.
    await _render(
      tester,
      const Center(child: MonoLedgerLogo(size: 840, color: _green)),
      'assets/icon/icon_foreground.png',
    );

    // Play Store feature graphics (1024x500).
    tester.view.physicalSize = const Size(1024, 500);
    for (final entry in _taglines.entries) {
      final arabic = entry.key == 'ar';
      final images = Directory('fastlane/metadata/android/${entry.key}/images')
        ..createSync(recursive: true);
      await _render(
        tester,
        _FeatureGraphic(
          tagline: entry.value,
          family: arabic ? 'Arabic' : 'Latin',
        ),
        '${images.path}/featureGraphic.png',
        size: const Size(1024, 500),
        direction: arabic ? TextDirection.rtl : TextDirection.ltr,
      );
    }
  });
}
