import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// Builds a perspective matrix with rotation about X and Y plus a Z-depth
/// shift expressed as scale (cheap and stable on the web renderer).
Matrix4 perspective({
  double rotateX = 0,
  double rotateY = 0,
  double rotateZ = 0,
  double dx = 0,
  double dy = 0,
  double scale = 1,
}) {
  return Matrix4.identity()
    ..setEntry(3, 2, 0.0011)
    ..translateByDouble(dx, dy, 0, 1)
    ..rotateX(rotateX)
    ..rotateY(rotateY)
    ..rotateZ(rotateZ)
    ..scaleByDouble(scale, scale, 1, 1);
}

/// Tracks the pointer over its child and reports a smoothed offset in
/// -1..1 on both axes. Touch devices never report hover, so they get zero.
class PointerTilt extends StatefulWidget {
  const PointerTilt({super.key, required this.builder});

  final Widget Function(BuildContext context, Offset tilt) builder;

  @override
  State<PointerTilt> createState() => _PointerTiltState();
}

class _PointerTiltState extends State<PointerTilt> {
  Offset _target = Offset.zero;

  void _update(PointerEvent e, Size size) {
    if (size.isEmpty) return;
    final nx = (e.localPosition.dx / size.width) * 2 - 1;
    final ny = (e.localPosition.dy / size.height) * 2 - 1;
    setState(() => _target = Offset(nx.clamp(-1.0, 1.0), ny.clamp(-1.0, 1.0)));
  }

  @override
  Widget build(BuildContext context) {
    final reduced = Motion.reduced(context);
    return LayoutBuilder(
      builder: (context, box) => MouseRegion(
        onHover: (e) => _update(e, box.biggest),
        onExit: (_) => setState(() => _target = Offset.zero),
        child: TweenAnimationBuilder<Offset>(
          tween: Tween(end: reduced ? Offset.zero : _target),
          duration: const Duration(milliseconds: 320),
          curve: Motion.easeOut,
          builder: (context, tilt, _) => widget.builder(context, tilt),
        ),
      ),
    );
  }
}

/// Card that leans toward the pointer. Used on interactive surfaces.
class TiltCard extends StatelessWidget {
  const TiltCard({super.key, required this.child, this.maxAngle = 0.08});

  final Widget child;
  final double maxAngle;

  @override
  Widget build(BuildContext context) {
    return PointerTilt(
      builder: (context, t) => Transform(
        alignment: Alignment.center,
        transform:
            perspective(rotateX: -t.dy * maxAngle, rotateY: t.dx * maxAngle),
        child: child,
      ),
    );
  }
}
