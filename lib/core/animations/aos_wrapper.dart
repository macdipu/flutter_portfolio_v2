import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AosWrapper extends StatelessWidget {
  final Widget child;
  final bool enabled;
  final Duration delay;
  final Duration duration;
  final double verticalOffset;

  const AosWrapper({
    super.key,
    required this.child,
    required this.enabled,
    required this.delay,
    required this.duration,
    required this.verticalOffset,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;

    return child
        .animate()
        .fade(duration: duration, delay: delay)
        .slide(begin: Offset(0, verticalOffset), duration: duration);
  }
}

