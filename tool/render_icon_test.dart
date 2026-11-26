// Renders the launcher icon from the app's own logo (wallet glyph + brand colours).
// Run: flutter test tool/render_icon_test.dart   → writes assets/icon/*.png
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _green = Color(0xFF14F195);
const _background = Color(0xFF0B0D0F);

Future<void> _loadMaterialIcons() async {
  final sdk =
      Platform.environment['FLUTTER_ROOT'] ??
      File(
        Platform.resolvedExecutable,
      ).parent.parent.parent.parent.parent.parent.path;
  final font = File(
    '$sdk/bin/cache/artifacts/material_fonts/MaterialIcons-Regular.otf',
  );
  final loader = FontLoader('MaterialIcons')
    ..addFont(Future.value(ByteData.view(font.readAsBytesSync().buffer)));
  await loader.load();
}

Future<void> _loadRoboto() async {
  final sdk =
      Platform.environment['FLUTTER_ROOT'] ??
      File(
        Platform.resolvedExecutable,
      ).parent.parent.parent.parent.parent.parent.path;
  final font = File('$sdk/bin/cache/artifacts/material_fonts/Roboto-Bold.ttf');
  final loader = FontLoader('Roboto')
    ..addFont(Future.value(ByteData.view(font.readAsBytesSync().buffer)));
  await loader.load();
}

Future<void> _render(
  WidgetTester tester,
  Widget child,
  String path, {
  Size size = const Size(1024, 1024),
}) async {
  final key = GlobalKey();
  await tester.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
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

void main() {
  testWidgets('render launcher icon', (tester) async {
    tester.view.physicalSize = const Size(1024, 1024);
    tester.view.devicePixelRatio = 1;
    await tester.runAsync(_loadMaterialIcons);
    await tester.runAsync(_loadRoboto);

    const glyph = Icon(
      Icons.account_balance_wallet_rounded,
      color: _green,
      size: 560,
    );

    // Full icon (legacy launchers, Play listing 512px is resized from this).
    await _render(
      tester,
      const DecoratedBox(
        decoration: BoxDecoration(color: _background),
        child: Center(child: glyph),
      ),
      'assets/icon/icon.png',
    );
    // Adaptive foreground: glyph inside the 66% safe zone, transparent around it.
    await _render(
      tester,
      const Center(
        child: Icon(
          Icons.account_balance_wallet_rounded,
          color: _green,
          size: 440,
        ),
      ),
      'assets/icon/icon_foreground.png',
    );

    // Play Store feature graphic (1024x500).
    tester.view.physicalSize = const Size(1024, 500);
    await _render(
      tester,
      const DecoratedBox(
        decoration: BoxDecoration(color: _background),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.account_balance_wallet_rounded,
              color: _green,
              size: 200,
            ),
            SizedBox(width: 40),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
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
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 96,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  'Board-game money, on every phone.',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 34,
                    color: Color(0xB3FFFFFF),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      'store/feature-graphic.png',
      size: const Size(1024, 500),
    );
  });
}
