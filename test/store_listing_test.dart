// Google Play limits and metadata rules for fastlane/metadata/android.
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  const root = 'fastlane/metadata/android';
  const locales = ['en-US', 'fr-FR', 'es-ES', 'ar'];
  const limits = {
    'title.txt': 30,
    'short_description.txt': 80,
    'full_description.txt': 4000,
    'changelogs/1.txt': 500,
  };
  // Other publishers' trademarks, and ranking or price claims Play rejects.
  final banned = RegExp(
    r'monopoly|monopolio|مونوبولي|hasbro|#1\b|\bbest\b|\bmeilleur|\bmejor\b',
    caseSensitive: false,
  );

  for (final locale in locales) {
    test('$locale listing is within Play limits', () {
      for (final MapEntry(key: file, value: limit) in limits.entries) {
        final text = File('$root/$locale/$file').readAsStringSync().trim();
        expect(text, isNotEmpty, reason: '$locale/$file');
        expect(
          text.runes.length,
          lessThanOrEqualTo(limit),
          reason: '$locale/$file',
        );
        expect(
          banned.firstMatch(text)?.group(0),
          isNull,
          reason: '$locale/$file',
        );
      }
    });

    test('$locale has an icon and a feature graphic', () {
      for (final name in ['icon.png', 'featureGraphic.png']) {
        expect(File('$root/$locale/images/$name').existsSync(), isTrue);
      }
    });

    test('$locale has 2 to 8 phone screenshots', () {
      final shots = Directory(
        '$root/$locale/images/phoneScreenshots',
      ).listSync().where((f) => f.path.endsWith('.png'));
      expect(shots.length, inInclusiveRange(2, 8));
    });
  }
}
