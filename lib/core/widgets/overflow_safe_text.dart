import 'package:flutter/material.dart';

/// Scales text down and keeps it centered when space is tight.
class OverflowSafeText extends StatelessWidget {
  final String text;
  final TextStyle style;
  final TextAlign textAlign;
  final int maxLines;
  final Alignment alignment;

  const OverflowSafeText(
    this.text, {
    super.key,
    required this.style,
    this.textAlign = TextAlign.center,
    this.maxLines = 1,
    this.alignment = Alignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: alignment,
        child: Text(
          text,
          textAlign: textAlign,
          maxLines: maxLines,
          style: style,
        ),
      ),
    );
  }
}

/// Trailing amount block for list rows: shrink-wraps and sits flush on the right.
class RowTrailingAmount extends StatelessWidget {
  final String primary;
  final TextStyle primaryStyle;
  final String? secondary;
  final TextStyle? secondaryStyle;
  final double maxWidth;

  const RowTrailingAmount({
    super.key,
    required this.primary,
    required this.primaryStyle,
    this.secondary,
    this.secondaryStyle,
    this.maxWidth = 128,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              primary,
              textAlign: TextAlign.right,
              style: primaryStyle,
            ),
          ),
        ),
        if (secondary != null) ...[
          const SizedBox(height: 3),
          Text(
            secondary!,
            textAlign: TextAlign.right,
            style: secondaryStyle,
          ),
        ],
      ],
    );
  }
}

/// Single-line trailing value, flush right (no extra flex gap).
class RowTrailingValue extends StatelessWidget {
  final String text;
  final TextStyle style;
  final double maxWidth;

  const RowTrailingValue({
    super.key,
    required this.text,
    required this.style,
    this.maxWidth = 128,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxWidth: maxWidth),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: Text(
          text,
          textAlign: TextAlign.right,
          style: style,
        ),
      ),
    );
  }
}
