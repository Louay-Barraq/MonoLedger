import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:monoledger/core/theme/app_theme.dart';

class SlideToConfirm extends StatefulWidget {
  final VoidCallback onConfirm;
  final String text;
  final Color baseColor;
  final Color containerColor;

  const SlideToConfirm({
    super.key,
    required this.onConfirm,
    this.text = 'SLIDE TO CONFIRM',
    this.baseColor = AppTheme.primaryColor,
    this.containerColor = const Color(0xFF14181F),
  });

  @override
  State<SlideToConfirm> createState() => _SlideToConfirmState();
}

class _SlideToConfirmState extends State<SlideToConfirm> with SingleTickerProviderStateMixin {
  double _dragValue = 0.0;
  bool _isConfirmed = false;
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

  void _onDragUpdate(DragUpdateDetails details, double maxWidth) {
    if (_isConfirmed) return;
    
    setState(() {
      _dragValue += details.primaryDelta! / (maxWidth - 64);
      _dragValue = _dragValue.clamp(0.0, 1.0);
    });
  }

  void _onDragEnd(DragEndDetails details) {
    if (_isConfirmed) return;

    if (_dragValue >= 0.9) {
      setState(() {
        _dragValue = 1.0;
        _isConfirmed = true;
      });
      widget.onConfirm();
      // Reset after a delay if needed, but usually we navigate away
    } else {
      _controller.duration = Duration(milliseconds: (300 * _dragValue).toInt());
      final Animation<double> animation = Tween<double>(
        begin: _dragValue,
        end: 0.0,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

      animation.addListener(() {
        setState(() {
          _dragValue = animation.value;
        });
      });

      _controller.forward(from: 0.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final double handleSize = 56.0;
        final double trackWidth = maxWidth - 8;
        final double slideRange = trackWidth - handleSize;
        final double currentPosition = _dragValue * slideRange;

        return Container(
          height: 64,
          width: maxWidth,
          decoration: BoxDecoration(
            color: widget.containerColor,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
          ),
          child: Stack(
            children: [
              // Shimmering text
              Center(
                child: Opacity(
                  opacity: (1.0 - _dragValue * 1.5).clamp(0.2, 1.0),
                  child: Text(
                    widget.text,
                    style: GoogleFonts.plusJakartaSans(
                      color: Colors.white.withValues(alpha: 0.5),
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
              
              // Neon fill
              Positioned(
                left: 4,
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

              // The Slider Handle
              Positioned(
                left: 4 + currentPosition,
                top: 4,
                bottom: 4,
                child: GestureDetector(
                  onHorizontalDragUpdate: (details) => _onDragUpdate(details, maxWidth),
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
                          offset: const Offset(0, 0),
                        ),
                      ],
                    ),
                    child: Icon(
                      _isConfirmed ? Icons.check_rounded : Icons.chevron_right_rounded,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
