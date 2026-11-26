// Logo round 2: literal "board-game money on your phone" directions.
// Run: flutter test tool/logo_round2_test.dart → design/logo-round2/*.png + sheet.png
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

const mint = Color(0xFF14F195);
const bg = Color(0xFF0B0D0F);

Paint fill(Color c) => Paint()
  ..color = c
  ..isAntiAlias = true;
Paint stroke(Color c, double w) => Paint()
  ..color = c
  ..style = PaintingStyle.stroke
  ..strokeWidth = w
  ..strokeCap = StrokeCap.round
  ..strokeJoin = StrokeJoin.round
  ..isAntiAlias = true;
RRect rr(double l, double t, double r, double b, double rad) =>
    RRect.fromLTRBR(l, t, r, b, Radius.circular(rad));

/// Classic game pawn standing on [base], [h] tall, centred on [cx].
Path pawn(double cx, double base, double h) {
  final r = h * 0.17;
  final head = Path()
    ..addOval(Rect.fromCircle(center: Offset(cx, base - h + r), radius: r));
  final collar = Path()
    ..addRRect(
      rr(
        cx - h * 0.21,
        base - h * 0.63,
        cx + h * 0.21,
        base - h * 0.53,
        h * 0.04,
      ),
    );
  final body = Path()
    ..moveTo(cx - h * 0.12, base - h * 0.58)
    ..quadraticBezierTo(
      cx - h * 0.15,
      base - h * 0.25,
      cx - h * 0.32,
      base - h * 0.1,
    )
    ..lineTo(cx + h * 0.32, base - h * 0.1)
    ..quadraticBezierTo(
      cx + h * 0.15,
      base - h * 0.25,
      cx + h * 0.12,
      base - h * 0.58,
    )
    ..close();
  final foot = Path()
    ..addRRect(
      rr(cx - h * 0.38, base - h * 0.16, cx + h * 0.38, base, h * 0.05),
    );
  return [
    collar,
    body,
    foot,
  ].fold(head, (a, b) => Path.combine(PathOperation.union, a, b));
}

/// Bold geometric M inside the box l..r × t..b (stroke weight w).
Path letterM(double l, double t, double r, double b, double w) {
  final mid = (l + r) / 2;
  return Path()
    ..moveTo(l, b)
    ..lineTo(l, t)
    ..lineTo(l + w, t)
    ..lineTo(mid, t + (b - t) * 0.5)
    ..lineTo(r - w, t)
    ..lineTo(r, t)
    ..lineTo(r, b)
    ..lineTo(r - w, b)
    ..lineTo(r - w, t + (b - t) * 0.33)
    ..lineTo(mid, t + (b - t) * 0.78)
    ..lineTo(l + w, t + (b - t) * 0.33)
    ..lineTo(l + w, b)
    ..close();
}

/// A banknote: rounded rect with a centre medallion and corner dots cut out.
void banknote(Canvas c, Rect r, {bool medallion = true}) {
  final s = r.shortestSide;
  final note = Path()
    ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(s * 0.14)));
  final cut = Path();
  if (medallion) {
    cut.addOval(Rect.fromCircle(center: r.center, radius: s * 0.24));
  }
  for (final o in [
    r.topLeft + Offset(s * .2, s * .2),
    r.bottomRight - Offset(s * .2, s * .2),
  ]) {
    cut.addOval(Rect.fromCircle(center: o, radius: s * 0.07));
  }
  c.drawPath(Path.combine(PathOperation.difference, note, cut), fill(mint));
}

typedef Mark = void Function(Canvas c, double s);

// 01 Note into phone: a banknote sliding into a phone.
void noteToPhone(Canvas c, double s) {
  c.drawRRect(
    rr(s * .46, s * .14, s * .8, s * .86, s * .08),
    stroke(mint, s * .055),
  );
  c.drawLine(
    Offset(s * .58, s * .78),
    Offset(s * .68, s * .78),
    stroke(mint, s * .04),
  );
  final note = Rect.fromLTRB(s * .14, s * .37, s * .64, s * .63);
  c.drawRRect(
    RRect.fromRectAndRadius(note.inflate(s * .03), Radius.circular(s * .06)),
    fill(bg),
  );
  banknote(c, note);
}

// 02 Pawn coin: a game pawn inside a coin.
void pawnCoin(Canvas c, double s) {
  c.drawCircle(Offset(s / 2, s / 2), s * .36, stroke(mint, s * .065));
  c.drawPath(pawn(s / 2, s * .72, s * .46), fill(mint));
}

// 03 Die and coin: a die leaning on a coin.
void dieCoin(Canvas c, double s) {
  c.save();
  c.translate(s * .4, s * .4);
  c.rotate(-0.2);
  final die = Path()
    ..addRRect(rr(-s * .22, -s * .22, s * .22, s * .22, s * .07));
  final pips = Path();
  for (final o in [const Offset(-.1, -.1), Offset.zero, const Offset(.1, .1)]) {
    pips.addOval(Rect.fromCircle(center: o * s, radius: s * .04));
  }
  c.drawPath(Path.combine(PathOperation.difference, die, pips), fill(mint));
  c.restore();
  final cc = Offset(s * .66, s * .66);
  c.drawCircle(cc, s * .23, fill(bg));
  c.drawCircle(cc, s * .19, fill(mint));
  c.drawCircle(cc, s * .12, stroke(bg, s * .03));
}

// 04 Banknote M: a bill with an M where the portrait would be.
void noteM(Canvas c, double s) {
  final r = Rect.fromLTRB(s * .1, s * .26, s * .9, s * .74);
  final note = Path()
    ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(s * .07)));
  final cut = Path()
    ..addPath(
      letterM(s * .36, s * .37, s * .64, s * .63, s * .075),
      Offset.zero,
    )
    ..addOval(Rect.fromCircle(center: Offset(s * .2, s * .5), radius: s * .035))
    ..addOval(
      Rect.fromCircle(center: Offset(s * .8, s * .5), radius: s * .035),
    );
  c.drawPath(Path.combine(PathOperation.difference, note, cut), fill(mint));
}

// 05 Coin exchange: money passing between two players.
void coinExchange(Canvas c, double s) {
  void coin(Offset o) {
    c.drawCircle(o, s * .14, fill(mint));
    c.drawCircle(o, s * .085, stroke(bg, s * .026));
  }

  final l = Offset(s * .24, s * .5), r = Offset(s * .76, s * .5);
  coin(l);
  coin(r);
  final a = stroke(mint, s * .05);
  // top arc: left → right; bottom arc: right → left
  final top = Path()
    ..moveTo(s * .28, s * .3)
    ..quadraticBezierTo(s * .5, s * .1, s * .66, s * .27);
  final bottom = Path()
    ..moveTo(s * .72, s * .7)
    ..quadraticBezierTo(s * .5, s * .9, s * .34, s * .73);
  c.drawPath(top, a);
  c.drawPath(bottom, a);
  Path head(Offset tip, double ang) => Path()
    ..moveTo(tip.dx, tip.dy)
    ..lineTo(
      tip.dx - math.cos(ang - .5) * s * .1,
      tip.dy - math.sin(ang - .5) * s * .1,
    )
    ..lineTo(
      tip.dx - math.cos(ang + .5) * s * .1,
      tip.dy - math.sin(ang + .5) * s * .1,
    )
    ..close();
  c.drawPath(head(Offset(s * .7, s * .31), 0.85), fill(mint));
  c.drawPath(head(Offset(s * .3, s * .69), 0.85 + math.pi), fill(mint));
}

// 06 Coin M: a minted coin stamped with an M.
void coinM(Canvas c, double s) {
  final coin = Path()
    ..addOval(Rect.fromCircle(center: Offset(s / 2, s / 2), radius: s * .38));
  final cut = Path()
    ..addPath(
      letterM(s * .33, s * .34, s * .67, s * .66, s * .085),
      Offset.zero,
    );
  c.drawPath(Path.combine(PathOperation.difference, coin, cut), fill(mint));
  c.drawCircle(Offset(s / 2, s / 2), s * .31, stroke(bg, s * .025));
}

// 07 Fanned notes: a hand of play money, held like cards.
void fannedNotes(Canvas c, double s) {
  final pivot = Offset(s * .5, s * .8);
  for (final ang in [-0.42, 0.42, 0.0]) {
    c.save();
    c.translate(pivot.dx, pivot.dy);
    c.rotate(ang);
    final r = Rect.fromLTRB(-s * .14, -s * .62, s * .14, -s * .1);
    c.drawRRect(
      RRect.fromRectAndRadius(r.inflate(s * .025), Radius.circular(s * .06)),
      fill(bg),
    );
    final note = Path()
      ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(s * .045)));
    final cut = Path()
      ..addOval(
        Rect.fromCircle(
          center: r.center.translate(0, -s * .06),
          radius: s * .07,
        ),
      );
    c.drawPath(
      ang == 0 ? Path.combine(PathOperation.difference, note, cut) : note,
      fill(mint),
    );
    c.restore();
  }
}

// 08 Pawn banknote: a bill whose portrait is a game pawn.
void pawnNote(Canvas c, double s) {
  final r = Rect.fromLTRB(s * .08, s * .24, s * .92, s * .76);
  final note = Path()
    ..addRRect(RRect.fromRectAndRadius(r, Radius.circular(s * .07)));
  final oval = Path()
    ..addOval(
      Rect.fromCenter(
        center: Offset(s * .5, s * .5),
        width: s * .36,
        height: s * .42,
      ),
    );
  final dots = Path()
    ..addOval(Rect.fromCircle(center: Offset(s * .18, s * .5), radius: s * .04))
    ..addOval(
      Rect.fromCircle(center: Offset(s * .82, s * .5), radius: s * .04),
    );
  c.drawPath(
    Path.combine(
      PathOperation.difference,
      note,
      Path.combine(PathOperation.union, oval, dots),
    ),
    fill(mint),
  );
  c.drawPath(pawn(s * .5, s * .66, s * .32), fill(mint));
}

final variants = <String, (String, Mark)>{
  '01': ('Note into phone', noteToPhone),
  '02': ('Pawn coin', pawnCoin),
  '03': ('Die and coin', dieCoin),
  '04': ('Banknote M', noteM),
  '05': ('Coin exchange', coinExchange),
  '06': ('Coin M', coinM),
  '07': ('Fanned notes', fannedNotes),
  '08': ('Pawn banknote', pawnNote),
};

class _Paint extends CustomPainter {
  _Paint(this.mark);
  final Mark mark;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, fill(bg));
    mark(canvas, size.width);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> _loadRoboto() async {
  final sdk = Platform.environment['FLUTTER_ROOT']!;
  final f = File('$sdk/bin/cache/artifacts/material_fonts/Roboto-Bold.ttf');
  await (FontLoader(
    'Roboto',
  )..addFont(Future.value(ByteData.view(f.readAsBytesSync().buffer)))).load();
}

Future<void> _save(WidgetTester t, Widget w, Size size, String path) async {
  final key = GlobalKey();
  await t.pumpWidget(
    Directionality(
      textDirection: TextDirection.ltr,
      child: Center(
        child: RepaintBoundary(
          key: key,
          child: SizedBox.fromSize(size: size, child: w),
        ),
      ),
    ),
  );
  await t.runAsync(() async {
    final img =
        await (key.currentContext!.findRenderObject()! as RenderRepaintBoundary)
            .toImage();
    File(path).writeAsBytesSync(
      (await img.toByteData(
        format: ui.ImageByteFormat.png,
      ))!.buffer.asUint8List(),
    );
  });
}

void main() {
  testWidgets('render round 2', (t) async {
    t.view.physicalSize = const Size(2000, 1200);
    t.view.devicePixelRatio = 1;
    await t.runAsync(_loadRoboto);
    for (final e in variants.entries) {
      await _save(
        t,
        CustomPaint(painter: _Paint(e.value.$2)),
        const Size.square(512),
        'design/logo-round2/${e.key}.png',
      );
    }
    // Comparison sheet: each mark big, plus its 48px launcher-size preview.
    Widget tile(String id, String name, Mark m) => Container(
      width: 480,
      height: 560,
      color: const Color(0xFF14181F),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          SizedBox.square(
            dimension: 400,
            child: CustomPaint(painter: _Paint(m)),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              SizedBox.square(
                dimension: 48,
                child: CustomPaint(painter: _Paint(m)),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  '$id  $name',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
    await _save(
      t,
      Container(
        color: bg,
        padding: const EdgeInsets.all(16),
        child: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final e in variants.entries)
              tile(e.key, e.value.$1, e.value.$2),
          ],
        ),
      ),
      const Size(4 * 480 + 5 * 16, 2 * 560 + 3 * 16),
      'design/logo-round2/sheet.png',
    );
  });
}
