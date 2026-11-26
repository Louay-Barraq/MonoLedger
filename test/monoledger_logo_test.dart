import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/widgets/monoledger_logo.dart';

void main() {
  test('mark is centred and fills most of its box', () {
    final bounds = MonoLedgerLogoPainter.markPath(100).getBounds();
    expect(bounds.longestSide, closeTo(84, 0.5));
    expect(bounds.center.dx, closeTo(50, 0.5));
    expect(bounds.center.dy, closeTo(50, 0.5));
  });

  test('pips, coin rim and the gap between them are real cut-outs', () {
    final path = MonoLedgerLogoPainter.markPath(100);
    // Design coordinates of the mark: the tilted die starts at 0.1532 and the
    // coin ends at 0.85; the painter fits that span into 84% of the box.
    const start = 0.1532, end = 0.85;
    const scale = 84 / (end - start);
    Offset at(double x, double y) => Offset(
      50 + (x - (start + end) / 2) * scale,
      50 + (y - (start + end) / 2) * scale,
    );

    expect(path.contains(at(0.45, 0.28)), isTrue, reason: 'die face');
    expect(path.contains(at(0.282, 0.322)), isFalse, reason: 'die pip');
    expect(path.contains(at(0.512, 0.512)), isFalse, reason: 'die/coin gap');
    expect(path.contains(at(0.66, 0.66)), isTrue, reason: 'coin centre');
    expect(path.contains(at(0.78, 0.66)), isFalse, reason: 'coin rim');
    expect(path.contains(at(0.83, 0.66)), isTrue, reason: 'coin edge');
  });

  testWidgets('logo renders at the requested size with a label', (
    tester,
  ) async {
    await tester.pumpWidget(
      const Directionality(
        textDirection: TextDirection.ltr,
        child: Center(child: MonoLedgerLogo(size: 64)),
      ),
    );
    expect(tester.getSize(find.byType(CustomPaint).last), const Size(64, 64));
    expect(find.bySemanticsLabel('MonoLedger'), findsOneWidget);
  });
}
