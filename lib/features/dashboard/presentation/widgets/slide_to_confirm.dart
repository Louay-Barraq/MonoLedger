import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/localization/app_localizations.dart';
import 'package:monoledger/core/theme/app_theme.dart';

class SlideToConfirm extends StatefulWidget {
  final VoidCallback? onConfirm;
  final Future<bool> Function()? onConfirmAsync;
  final String text;
  final Color baseColor;
  final Color containerColor;
  final bool enabled;

  /// Follows the Haptic feedback setting.
  final bool haptics;

  const SlideToConfirm({
    super.key,
    this.onConfirm,
    this.onConfirmAsync,
    this.text = 'SLIDE TO CONFIRM',
    this.baseColor = AppTheme.primaryColor,
    this.containerColor = const Color(0xFF14181F),
    this.enabled = true,
    this.haptics = true,
  }) : assert(onConfirm != null || onConfirmAsync != null);

  @override
  State<SlideToConfirm> createState() => SlideToConfirmState();
}

class SlideToConfirmState extends State<SlideToConfirm>
    with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;
  bool _isConfirmed = false;
  bool _isProcessing = false;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Snap the handle back after a failed or cancelled payment.
  void reset() {
    if (!mounted) return;
    setState(() {
      _isConfirmed = false;
      _isProcessing = false;
      _dragValue = 0.0;
    });
    _controller.reset();
  }

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isConfirmed || _isProcessing || !widget.enabled) return;

    // In right-to-left languages the handle starts on the right.
    final direction = Directionality.of(context) == TextDirection.rtl ? -1 : 1;

    setState(() {
      _dragValue += direction * details.primaryDelta! / (maxWidth - 64);
      _dragValue = _dragValue.clamp(0.0, 1.0);
    });

    if (_dragValue > 0.5 && _dragValue < 0.55) {
      if (widget.haptics) HapticFeedback.selectionClick();
    }
  }

  Future<void> _onDragEnd(DragEndDetails details) async {
    if (_isConfirmed || _isProcessing || !widget.enabled) return;

    if (_dragValue >= 0.9) {
      setState(() {
        _dragValue = 1.0;
        _isProcessing = true;
      });
      if (widget.haptics) HapticFeedback.mediumImpact();

      bool success = true;
      try {
        if (widget.onConfirmAsync != null) {
          success = await widget.onConfirmAsync!();
        } else {
          widget.onConfirm?.call();
        }
      } catch (_) {
        success = false;
      }

      if (!mounted) return;

      if (success) {
        setState(() {
          _isConfirmed = true;
          _isProcessing = false;
        });
        if (widget.haptics) HapticFeedback.heavyImpact();
      } else {
        if (widget.haptics) HapticFeedback.vibrate();
        reset();
      }
    } else {
      _animateBack();
    }
  }

  void _animateBack() {
    _controller.duration = Duration(
      milliseconds: (300 * _dragValue).clamp(150, 300).toInt(),
    );
    final animation = Tween<double>(
      begin: _dragValue,
      end: 0.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    animation.addListener(() {
      if (mounted) {
        setState(() => _dragValue = animation.value);
      }
    });

    _controller.forward(from: 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        const double handleSize = 56.0;
        final double trackWidth = maxWidth - 8;
        final double slideRange = trackWidth - handleSize;
        final double currentPosition = _dragValue * slideRange;
        final displayText = _isProcessing
            ? (Localizations.of<AppLocalizations>(
                    context,
                    AppLocalizations,
                  )?.padProcessing ??
                  'PROCESSING...')
            : widget.text;

        return Opacity(
          opacity: widget.enabled ? 1 : 0.5,
          child: IgnorePointer(
            ignoring: !widget.enabled || _isProcessing,
            child: Container(
              height: 64,
              width: maxWidth,
              decoration: BoxDecoration(
                color: widget.containerColor,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Opacity(
                      opacity: (1.0 - _dragValue * 1.5).clamp(0.2, 1.0),
                      child: Text(
                        displayText,
                        style: GoogleFonts.plusJakartaSans(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontWeight: FontWeight.w800,
                          fontSize: 14,
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 4,
                    top: 4,
                    bottom: 4,
                    width: currentPosition + handleSize,
                    child: Container(
                      decoration: BoxDecoration(
                        color: widget.baseColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    start: 4 + currentPosition,
                    top: 4,
                    bottom: 4,
                    child: GestureDetector(
                      onHorizontalDragUpdate: (details) =>
                          _onDragUpdate(details, maxWidth),
                      onHorizontalDragEnd: _onDragEnd,
                      child: Container(
                        width: handleSize,
                        height: handleSize,
                        decoration: BoxDecoration(
                          color: widget.baseColor,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: widget.baseColor.withValues(alpha: 0.4),
                              blurRadius: 12,
                            ),
                          ],
                        ),
                        child: Icon(
                          _isConfirmed
                              ? Icons.check_rounded
                              : Icons.chevron_right_rounded,
                          color: Colors.black,
                          size: 32,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
