// Composes localized Play Store screenshots (headline + app screen, 1080x1920).
// Raw 1080x2400 captures named store-<lang>-<screen>.png are read from RAW_DIR:
//   flutter test tool/store_screenshots_test.dart --dart-define=RAW_DIR=/path
import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const _rawDir = String.fromEnvironment('RAW_DIR');
const _mint = Color(0xFF14F195);

const _screens = ['wallet', 'pad', 'ledger', 'go', 'summary', 'create'];

const _locales = {'en': 'en-US', 'fr': 'fr-FR', 'es': 'es-ES', 'ar': 'ar'};

/// Headline and sub-headline per screen, in the order of [_screens].
const _captions = {
  'en': [
    ('Every balance, live', 'Play money on every phone'),
    ('Pay in seconds', 'Slide to send. No paper bills.'),
    ('Every payment recorded', 'Settle disputes in a tap'),
    ('The Banker is in charge', 'Approve salaries with one tap'),
    ('Crown the winner', 'Final standings and game stats'),
    ('Your game, your rules', 'Currency, starting cash, salary'),
  ],
  'fr': [
    ('Tous les soldes en direct', 'La banque sur chaque téléphone'),
    ('Payez en un geste', 'Glissez. Fini les billets.'),
    ('Chaque paiement noté', 'Plus de disputes sur les comptes'),
    ('Le Banquier décide', 'Salaires validés en un toucher'),
    ('Sacrez le vainqueur', 'Classement et statistiques'),
    ('Vos règles du jeu', 'Monnaie, capital et salaire'),
  ],
  'es': [
    ('Saldos en tiempo real', 'El dinero del juego en cada móvil'),
    ('Paga en segundos', 'Desliza y listo. Sin billetes.'),
    ('Cada pago registrado', 'Se acabaron las discusiones'),
    ('El Banquero manda', 'Aprueba sueldos con un toque'),
    ('Corona al ganador', 'Clasificación y estadísticas'),
    ('Tus propias reglas', 'Moneda, dinero inicial y sueldo'),
  ],
  'ar': [
    ('كل الأرصدة لحظيًا', 'أموال اللعبة على كل هاتف'),
    ('ادفع في ثوانٍ', 'اسحب وأرسل دون أوراق نقدية'),
    ('كل دفعة مسجّلة', 'لا خلافات على الحسابات'),
    ('المصرفي صاحب القرار', 'وافق على المكافآت بلمسة'),
    ('توّج الفائز', 'الترتيب النهائي وإحصاءات اللعبة'),
    ('قواعدك أنت', 'العملة ورأس المال والمكافأة'),
  ],
};

Future<void> _font(String family, String path) async {
  final bytes = File(path).readAsBytesSync();
  await (FontLoader(
    family,
  )..addFont(Future.value(ByteData.view(bytes.buffer)))).load();
}

void main() {
  testWidgets('compose store screenshots', (tester) async {
    tester.view.physicalSize = const Size(1080, 1920);
    tester.view.devicePixelRatio = 1;
    final sdk = Platform.environment['FLUTTER_ROOT']!;
    await tester.runAsync(() async {
      await _font(
        'Latin',
        '$sdk/bin/cache/artifacts/material_fonts/Roboto-Bold.ttf',
      );
      // macOS system font with Arabic glyphs.
      await _font(
        'Arabic',
        '/System/Library/Fonts/Supplemental/Arial Bold.ttf',
      );
    });

    for (final entry in _locales.entries) {
      final lang = entry.key;
      final family = lang == 'ar' ? 'Arabic' : 'Latin';
      final out = Directory(
        'fastlane/metadata/android/${entry.value}/images/phoneScreenshots',
      )..createSync(recursive: true);
      for (var i = 0; i < _screens.length; i++) {
        late ui.Image shot;
        await tester.runAsync(() async {
          final bytes = File(
            '$_rawDir/store-$lang-${_screens[i]}.png',
          ).readAsBytesSync();
          shot = (await (await ui.instantiateImageCodec(
            bytes,
          )).getNextFrame()).image;
        });
        final key = GlobalKey();
        final (title, subtitle) = _captions[lang]![i];
        await tester.pumpWidget(
          Directionality(
            textDirection: lang == 'ar' ? TextDirection.rtl : TextDirection.ltr,
            child: RepaintBoundary(
              key: key,
              child: _Frame(
                shot: shot,
                title: title,
                subtitle: subtitle,
                family: family,
              ),
            ),
          ),
        );
        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage();
          final png = await image.toByteData(format: ui.ImageByteFormat.png);
          File(
            '${out.path}/${i + 1}_${_screens[i]}.png',
          ).writeAsBytesSync(png!.buffer.asUint8List());
        });
      }
    }
  }, skip: _rawDir.isEmpty);
}

class _Frame extends StatelessWidget {
  const _Frame({
    required this.shot,
    required this.title,
    required this.subtitle,
    required this.family,
  });

  final ui.Image shot;
  final String title;
  final String subtitle;
  final String family;

  /// Height of the Android status bar cropped from each capture.
  static const _statusBar = 132.0;
  static const _screenHeight = 1500.0;

  @override
  Widget build(BuildContext context) {
    final scale = _screenHeight / (shot.height - _statusBar);
    return ColoredBox(
      color: const Color(0xFF0F2A20),
      child: Column(
        children: [
          SizedBox(
            height: 360,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 56),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      title,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: family,
                        fontSize: 84,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      subtitle,
                      maxLines: 1,
                      style: TextStyle(
                        fontFamily: family,
                        fontSize: 46,
                        color: _mint,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              border: Border.all(
                color: _mint.withValues(alpha: 0.45),
                width: 4,
              ),
            ),
            padding: const EdgeInsets.all(4),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(42),
              child: SizedBox(
                width: shot.width * scale,
                height: _screenHeight,
                child: OverflowBox(
                  alignment: Alignment.bottomCenter,
                  maxHeight: shot.height * scale,
                  child: RawImage(
                    image: shot,
                    width: shot.width * scale,
                    height: shot.height * scale,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
