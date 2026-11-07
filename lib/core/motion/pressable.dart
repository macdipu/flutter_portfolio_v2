import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../design/tokens.dart';

/// Interaction state handed to [Pressable.builder].
class PressState {
  const PressState({
    required this.hovered,
    required this.focused,
    required this.pressed,
  });

  final bool hovered;
  final bool focused;
  final bool pressed;

  /// Hover, keyboard focus and touch-press all trigger the same visual state.
  bool get active => hovered || focused || pressed;
}

/// A tappable region with hover, keyboard focus and press feedback.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.onTap,
    required this.builder,
    this.semanticLabel,
    this.pressScale = 0.98,
    this.cursor = SystemMouseCursors.click,
  });

  final VoidCallback? onTap;
  final Widget Function(BuildContext context, PressState state) builder;
  final String? semanticLabel;
  final double pressScale;
  final MouseCursor cursor;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _hovered = false;
  bool _focused = false;
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final state = PressState(
      hovered: _hovered,
      focused: _focused,
      pressed: _pressed,
    );
    final reduced = Motion.reduced(context);
    return Semantics(
      button: true,
      link: false,
      label: widget.semanticLabel,
      enabled: widget.onTap != null,
      child: FocusableActionDetector(
        enabled: widget.onTap != null,
        mouseCursor: widget.cursor,
        onShowHoverHighlight: (v) => setState(() => _hovered = v),
        onShowFocusHighlight: (v) => setState(() => _focused = v),
        actions: {
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              widget.onTap?.call();
              return null;
            },
          ),
        },
        shortcuts: const {
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          child: AnimatedScale(
            scale: _pressed && !reduced ? widget.pressScale : 1,
            duration: Motion.press,
            curve: Motion.easeOut,
            child: widget.builder(context, state),
          ),
        ),
      ),
    );
  }
}

/// Focus ring used by every interactive element.
BoxDecoration focusRing(BuildContext context, bool focused,
    {double radius = Radii.sm}) {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(radius),
    border: Border.all(
      color: focused ? context.colors.signal : Colors.transparent,
      width: 2,
    ),
  );
}
