import 'package:flutter/material.dart';

/// Exposes the page [ScrollController] so scroll-linked widgets can read the
/// scroll offset without owning a controller.
class ScrollScope extends InheritedWidget {
  const ScrollScope(
      {super.key, required this.controller, required super.child});

  final ScrollController controller;

  static ScrollController of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ScrollScope>();
    assert(scope != null, 'ScrollScope missing above this widget');
    return scope!.controller;
  }

  @override
  bool updateShouldNotify(ScrollScope old) => controller != old.controller;
}

/// Rebuilds [builder] on every scroll tick with the current offset.
///
/// Keep the subtree small. Heavy children belong in [child], which is built
/// once and passed through.
class ScrollLinked extends StatelessWidget {
  const ScrollLinked({super.key, required this.builder, this.child});

  final Widget Function(BuildContext context, double offset, Widget? child)
      builder;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final controller = ScrollScope.of(context);
    return ListenableBuilder(
      listenable: controller,
      child: child,
      builder: (context, child) => builder(
        context,
        controller.hasClients ? controller.offset : 0,
        child,
      ),
    );
  }
}

/// Where [context]'s render box sits relative to the viewport, in pixels
/// from the viewport top. Null before the first layout.
double? viewportTop(BuildContext context) {
  final box = context.findRenderObject();
  if (box is! RenderBox || !box.attached || !box.hasSize) return null;
  return box.localToGlobal(Offset.zero).dy;
}
