import 'package:flutter/material.dart';

import '../design/tokens.dart';

/// How a [Reveal] enters.
enum RevealKind {
  /// Fade plus a small rise.
  rise,

  /// Opacity only. For long lists.
  fade,

  /// Content slides up inside a mask. For headings.
  mask,

  /// Clips open from the left with a slight scale settle. For images.
  wipe,
}

/// Plays once, when the child first scrolls into view.
///
/// With reduced motion the child is shown immediately. Content is never
/// hidden from semantics, so assistive tech is unaffected by the animation.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.kind = RevealKind.rise,
    this.delay = Duration.zero,
  });

  final Widget child;
  final RevealKind kind;
  final Duration delay;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c =
      AnimationController(vsync: this, duration: Motion.entrance);
  late final Animation<double> _t =
      CurvedAnimation(parent: _c, curve: Motion.easeOut);

  ScrollPosition? _position;
  bool _played = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_played) return;
    if (Motion.reduced(context)) {
      _played = true;
      _c.value = 1;
      return;
    }
    final next = Scrollable.maybeOf(context)?.position;
    if (next != _position) {
      _position?.removeListener(_check);
      _position = next;
      _position?.addListener(_check);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _check());
  }

  void _check() {
    if (_played || !mounted) return;
    final box = context.findRenderObject();
    if (box is! RenderBox || !box.attached || !box.hasSize) return;
    final viewport = MediaQuery.sizeOf(context).height;
    final top = box.localToGlobal(Offset.zero).dy;
    if (top < viewport * (1 - Motion.revealThreshold)) {
      _played = true;
      _position?.removeListener(_check);
      Future<void>.delayed(widget.delay, () {
        if (mounted) _c.forward();
      });
    }
  }

  @override
  void dispose() {
    _position?.removeListener(_check);
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      child: widget.child,
      builder: (context, child) {
        final t = _t.value;
        switch (widget.kind) {
          case RevealKind.fade:
            return Opacity(opacity: t, child: child);
          case RevealKind.rise:
            return Opacity(
              opacity: t,
              child: Transform.translate(
                offset: Offset(0, (1 - t) * Motion.entranceOffset),
                child: child,
              ),
            );
          case RevealKind.mask:
            return ClipRect(
              child: FractionalTranslation(
                translation: Offset(0, (1 - t) * 1.1),
                child: child,
              ),
            );
          case RevealKind.wipe:
            return ClipRect(
              clipper: _WipeClipper(t),
              child: Transform.scale(scale: 1.04 - 0.04 * t, child: child),
            );
        }
      },
    );
  }
}

class _WipeClipper extends CustomClipper<Rect> {
  _WipeClipper(this.t);
  final double t;

  @override
  Rect getClip(Size size) => Rect.fromLTWH(0, 0, size.width * t, size.height);

  @override
  bool shouldReclip(_WipeClipper old) => old.t != t;
}
