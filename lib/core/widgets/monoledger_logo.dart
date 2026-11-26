import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:monoledger/core/theme/app_theme.dart';

/// The MonoLedger mark: a hex game token with ledger rows and a cursor cut out.
/// Construction notes: design/logo-variants.md (variant 08).
class MonoLedgerLogo extends StatelessWidget {
  final double size;
  final Color color;

  const MonoLedgerLogo({
    super.key,
    this.size = 40,
    this.color = AppTheme.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'MonoLedger',
      image: true,
      child: CustomPaint(
        size: Size.square(size),
        painter: MonoLedgerLogoPainter(color),
      ),
    );
  }
}

class MonoLedgerLogoPainter extends CustomPainter {
  final Color color;

  const MonoLedgerLogoPainter(this.color);

  /// The mark as a path in an [s]×[s] box (also used to render icons).
  static Path markPath(double s) {
    final token = _hexagon(s, s * 0.4, s * 0.07);
    final rowHeight = s * 0.07;
    final left = s * 0.31;
    const widths = [0.38, 0.28, 0.16];
    final cut = Path();
    for (var i = 0; i < widths.length; i++) {
      cut.addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            left,
            s * 0.355 + i * s * 0.115,
            s * widths[i],
            rowHeight,
          ),
          Radius.circular(rowHeight / 2),
        ),
      );
    }
    cut.addRect(Rect.fromLTWH(left + s * 0.2, s * 0.585, s * 0.06, rowHeight));
    return Path.combine(PathOperation.difference, token, cut);
  }

  static Path _hexagon(double s, double radius, double corner) {
    final c = Offset(s / 2, s / 2);
    final points = [
      for (var i = 0; i < 6; i++)
        c + Offset.fromDirection(math.pi / 3 * i - math.pi / 2, radius),
    ];
    final path = Path();
    for (var i = 0; i < 6; i++) {
      final prev = points[(i + 5) % 6],
          cur = points[i],
          next = points[(i + 1) % 6];
      final a = cur + (prev - cur) * (corner / (prev - cur).distance);
      final b = cur + (next - cur) * (corner / (next - cur).distance);
      if (i == 0) {
        path.moveTo(a.dx, a.dy);
      } else {
        path.lineTo(a.dx, a.dy);
      }
      path.quadraticBezierTo(cur.dx, cur.dy, b.dx, b.dy);
    }
    return path..close();
  }

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawPath(
      markPath(size.shortestSide),
      Paint()
        ..color = color
        ..isAntiAlias = true,
    );
  }

  @override
  bool shouldRepaint(MonoLedgerLogoPainter oldDelegate) =>
      oldDelegate.color != color;
}
