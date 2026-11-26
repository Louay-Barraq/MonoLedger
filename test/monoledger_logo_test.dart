import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:monoledger/core/widgets/monoledger_logo.dart';

void main() {
  test('mark is a hexagon with the ledger rows cut out', () {
    final path = MonoLedgerLogoPainter.markPath(100);
    final bounds = path.getBounds();
    // Hexagon radius 40% of the box: 80% tall, centred.
    expect(bounds.height, closeTo(80, 1));
    expect(bounds.center.dx, closeTo(50, 1));
    expect(path.contains(const Offset(50, 15)), isTrue, reason: 'token body');
    expect(
      path.contains(const Offset(40, 39)),
      isFalse,
      reason: 'top ledger row is cut out',
    );
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
