import 'package:flutter/material.dart';

class CustomCursorOverlay extends StatefulWidget {
  final Widget child;
  final double innerRadius;
  final double outerRadius;
  final double hoverScale;
  final Duration followDuration;
  final bool enabled;

  const CustomCursorOverlay({
    super.key,
    required this.child,
    required this.innerRadius,
    required this.outerRadius,
    required this.hoverScale,
    required this.followDuration,
    required this.enabled,
  });

  @override
  State<CustomCursorOverlay> createState() => _CustomCursorOverlayState();
}

class _CustomCursorOverlayState extends State<CustomCursorOverlay>
    with SingleTickerProviderStateMixin {
  Offset _cursorPosition = Offset.zero;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;

    return MouseRegion(
      onHover: (event) {
        setState(() {
          _cursorPosition = event.position;
        });
      },
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: Stack(
        children: [
          widget.child,
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: _CursorPainter(
                  position: _cursorPosition,
                  innerRadius: widget.innerRadius,
                  outerRadius: widget.outerRadius,
                  hoverScale: widget.hoverScale,
                  isHovering: _isHovering,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CursorPainter extends CustomPainter {
  final Offset position;
  final double innerRadius;
  final double outerRadius;
  final double hoverScale;
  final bool isHovering;

  _CursorPainter({
    required this.position,
    required this.innerRadius,
    required this.outerRadius,
    required this.hoverScale,
    required this.isHovering,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (position == Offset.zero) return;

    final outerPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final innerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final offset = Offset(position.dx, position.dy);

    canvas.drawCircle(
      offset,
      outerRadius * (isHovering ? hoverScale : 1),
      outerPaint,
    );

    canvas.drawCircle(
      offset,
      innerRadius,
      innerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CursorPainter oldDelegate) {
    return position != oldDelegate.position ||
        isHovering != oldDelegate.isHovering;
  }
}
