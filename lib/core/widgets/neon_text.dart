import 'package:flutter/material.dart';

class NeonText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color color;
  final double blurRadius;

  const NeonText({
    super.key,
    required this.text,
    this.style,
    this.color = const Color(0xFF14F195),
    this.blurRadius = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: (style ?? const TextStyle()).copyWith(
        color: color,
        shadows: [
          Shadow(color: color.withValues(alpha: 0.8), blurRadius: blurRadius),
          Shadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: blurRadius * 2,
          ),
        ],
      ),
    );
  }
}
