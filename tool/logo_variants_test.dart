// Logo exploration: renders each candidate mark at 512px and at 48px (launcher size).
// Run: flutter test tool/logo_variants_test.dart  → design/logo-variants/*.png
import 'dart:io';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

const mint = Color(0xFF14F195);
const bg = Color(0xFF0B0D0F);

typedef MarkPainter = void Function(Canvas c, double s, Paint p);

/// 01 Coin-stack M: three columns of coins, tall-short-tall, reads as an M and as stacks of money.
void coinStackM(Canvas c, double s, Paint p) {
  final coinH = s * 0.085, gap = s * 0.035, colW = s * 0.2, colGap = s * 0.06;
  final totalW = colW * 3 + colGap * 2;
  final left = (s - totalW) / 2, bottom = s * 0.76;
  final counts = [5, 3, 5];
  for (var col = 0; col < 3; col++) {
    for (var i = 0; i < counts[col]; i++) {
      final x = left + col * (colW + colGap);
      final y = bottom - (i + 1) * coinH - i * gap;
      c.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, colW, coinH),
          Radius.circular(coinH / 2),
        ),
        p,
      );
    }
  }
}

/// 02 Token ledger: a game token (ring) holding three ledger rows and a terminal cursor.
void tokenLedger(Canvas c, double s, Paint p) {
  final ring = Paint()
    ..color = p.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = s * 0.07;
  c.drawCircle(Offset(s / 2, s / 2), s * 0.34, ring);
  final h = s * 0.065, x = s * 0.33;
  final widths = [0.34, 0.26, 0.16];
  for (var i = 0; i < 3; i++) {
    final y = s * 0.37 + i * s * 0.11;
    c.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, y, s * widths[i], h),
        Radius.circular(h / 2),
      ),
      p,
    );
  }
  c.drawRect(
    Rect.fromLTWH(x + s * 0.2, s * 0.59, s * 0.05, h),
    p,
  ); // cursor block
}

/// 03 Exchange coin: one coin split into two halves sliding past each other (a transfer).
void exchangeCoin(Canvas c, double s, Paint p) {
  final r = s * 0.3, o = s * 0.05;
  final top = Path()
    ..addArc(
      Rect.fromCircle(center: Offset(s / 2 - o, s / 2 - o * 0.4), radius: r),
      math.pi,
      math.pi,
    )
    ..close();
  final bottom = Path()
    ..addArc(
      Rect.fromCircle(center: Offset(s / 2 + o, s / 2 + o * 1.4), radius: r),
      0,
      math.pi,
    )
    ..close();
  c.drawPath(top, p);
  c.drawPath(bottom, p);
}

/// 04 ML monogram: a monoline M whose last stroke runs on into the foot of an L.
void mlMonogram(Canvas c, double s, Paint p) {
  final st = Paint()
    ..color = p.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = s * 0.09
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final path = Path()
    ..moveTo(s * 0.22, s * 0.74)
    ..lineTo(s * 0.22, s * 0.28)
    ..lineTo(s * 0.42, s * 0.54)
    ..lineTo(s * 0.62, s * 0.28)
    ..lineTo(s * 0.62, s * 0.74)
    ..lineTo(s * 0.8, s * 0.74);
  c.drawPath(path, st);
}

/// 05 Die ledger: a die face whose middle pips became a ledger row.
void dieLedger(Canvas c, double s, Paint p) {
  final st = Paint()
    ..color = p.color
    ..style = PaintingStyle.stroke
    ..strokeWidth = s * 0.06;
  c.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.2, s * 0.2, s * 0.6, s * 0.6),
      Radius.circular(s * 0.14),
    ),
    st,
  );
  final pr = s * 0.055;
  c.drawCircle(Offset(s * 0.35, s * 0.35), pr, p);
  c.drawCircle(Offset(s * 0.65, s * 0.65), pr, p);
  c.drawRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(s * 0.3, s * 0.47, s * 0.4, s * 0.06),
      Radius.circular(s * 0.03),
    ),
    p,
  );
}

/// 06 Pip M: five dice pips arranged into an M.
void pipM(Canvas c, double s, Paint p) {
  final r = s * 0.07;
  for (final o in const [
    Offset(.26, .7),
    Offset(.26, .32),
    Offset(.5, .5),
    Offset(.74, .32),
    Offset(.74, .7),
  ]) {
    c.drawCircle(Offset(o.dx * s, o.dy * s), r, p);
  }
}

/// 07 Ledger coin (refined 02): a solid coin with ledger rows and a cursor cut out of it.
void ledgerCoin(Canvas c, double s, Paint p) {
  final coin = Path()
    ..addOval(Rect.fromCircle(center: Offset(s / 2, s / 2), radius: s * 0.36));
  final h = s * 0.07, x = s * 0.3;
  final cut = Path();
  const widths = [0.4, 0.3, 0.17];
  for (var i = 0; i < 3; i++) {
    cut.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, s * 0.355 + i * s * 0.115, s * widths[i], h),
        Radius.circular(h / 2),
      ),
    );
  }
  cut.addRect(Rect.fromLTWH(x + s * 0.21, s * 0.585, s * 0.06, h)); // cursor
  c.drawPath(Path.combine(PathOperation.difference, coin, cut), p);
}

/// Rounded hexagon (pointy-top) centred in an s×s box.
Path hexagon(double s, double r, double corner) {
  final cx = s / 2, cy = s / 2;
  final pts = [
    for (var i = 0; i < 6; i++)
      Offset(
        cx + r * math.cos(math.pi / 3 * i - math.pi / 2),
        cy + r * math.sin(math.pi / 3 * i - math.pi / 2),
      ),
  ];
  final path = Path();
  for (var i = 0; i < 6; i++) {
    final prev = pts[(i + 5) % 6], cur = pts[i], next = pts[(i + 1) % 6];
    final a = cur + (prev - cur) * (corner / (prev - cur).distance);
    final b = cur + (next - cur) * (corner / (next - cur).distance);
    i == 0 ? path.moveTo(a.dx, a.dy) : path.lineTo(a.dx, a.dy);
    path.quadraticBezierTo(cur.dx, cur.dy, b.dx, b.dy);
  }
  return path..close();
}

/// 08 Hex ledger token: a hex game token with ledger rows and a cursor cut out.
void hexLedger(Canvas c, double s, Paint p) {
  final token = hexagon(s, s * 0.4, s * 0.07);
  final h = s * 0.07, x = s * 0.31;
  final cut = Path();
  const widths = [0.38, 0.28, 0.16];
  for (var i = 0; i < 3; i++) {
    cut.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(x, s * 0.355 + i * s * 0.115, s * widths[i], h),
        Radius.circular(h / 2),
      ),
    );
  }
  cut.addRect(Rect.fromLTWH(x + s * 0.2, s * 0.585, s * 0.06, h));
  c.drawPath(Path.combine(PathOperation.difference, token, cut), p);
}

class _Mark extends CustomPainter {
  _Mark(this.draw);
  final MarkPainter draw;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(Offset.zero & size, Paint()..color = bg);
    draw(
      canvas,
      size.width,
      Paint()
        ..color = mint
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Future<void> _save(
  WidgetTester t,
  MarkPainter draw,
  double size,
  String path,
) async {
  final key = GlobalKey();
  await t.pumpWidget(
    Center(
      child: RepaintBoundary(
        key: key,
        child: CustomPaint(size: Size.square(size), painter: _Mark(draw)),
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
  testWidgets('render logo variants', (t) async {
    t.view.physicalSize = const Size(600, 600);
    t.view.devicePixelRatio = 1;
    final variants = {
      '01-coin-stack-m': coinStackM,
      '02-token-ledger': tokenLedger,
      '03-exchange-coin': exchangeCoin,
      '04-ml-monogram': mlMonogram,
      '05-die-ledger': dieLedger,
      '06-pip-m': pipM,
      '07-ledger-coin': ledgerCoin,
      '08-hex-ledger': hexLedger,
    };
    for (final e in variants.entries) {
      await _save(t, e.value, 512, 'design/logo-variants/${e.key}.png');
      await _save(t, e.value, 48, 'design/logo-variants/${e.key}-48.png');
    }
  });
}
