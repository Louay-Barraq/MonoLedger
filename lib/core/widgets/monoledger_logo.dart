import 'package:flutter/material.dart';
import 'package:monoledger/core/theme/app_theme.dart';

/// The MonoLedger mark: a die with a coin resting on it (board-game money).
/// One colour, with real cut-outs, so it sits on any background.
/// Chosen in design/logo-round2.md (variant 03).
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

  /// Share of the box covered by the mark's longer side.
  static const _fill = 0.84;

  /// The mark as a path centred in an [s]×[s] box (also used to render icons).
  static Path markPath(double s) {
    // Built on a unit square, then centred and scaled to fit.
    const dieCentre = Offset(0.40, 0.40);
    const coinCentre = Offset(0.66, 0.66);

    Path circle(Offset centre, double radius) =>
        Path()..addOval(Rect.fromCircle(center: centre, radius: radius));
    Path minus(Path a, Path b) => Path.combine(PathOperation.difference, a, b);

    // Die: a rounded square, tilted, with three pips on the diagonal.
    var die = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromCircle(center: Offset.zero, radius: 0.22),
          const Radius.circular(0.07),
        ),
      );
    for (final pip in const [-0.1, 0.0, 0.1]) {
      die = minus(die, circle(Offset(pip, pip), 0.04));
    }
    final tilt = Matrix4.translationValues(dieCentre.dx, dieCentre.dy, 0)
      ..rotateZ(-0.2);
    die = die.transform(tilt.storage);
    // A gap separates the die from the coin in front of it.
    die = minus(die, circle(coinCentre, 0.23));

    // Coin: a disc with an inner rim.
    final rim = minus(circle(coinCentre, 0.135), circle(coinCentre, 0.105));
    final coin = minus(circle(coinCentre, 0.19), rim);

    final mark = Path.combine(PathOperation.union, die, coin);
    final bounds = mark.getBounds();
    final scale = s * _fill / bounds.longestSide;
    final fit = Matrix4.translationValues(s / 2, s / 2, 0)
      ..multiply(Matrix4.diagonal3Values(scale, scale, 1))
      ..multiply(
        Matrix4.translationValues(-bounds.center.dx, -bounds.center.dy, 0),
      );
    return mark.transform(fit.storage);
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
