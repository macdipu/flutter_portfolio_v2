import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../design/tokens.dart';

/// Page sections, in page order.
enum NavigationSection {
  hero('Home'),
  projects('Projects'),
  experience('Experience'),
  about('About'),
  writing('Writing'),
  contact('Contact');

  const NavigationSection(this.label);
  final String label;

  /// Sections shown in the navigation bar.
  static const navItems = [projects, experience, about, contact];
}

class ScrollState extends Equatable {
  const ScrollState({required this.currentSection});
  final NavigationSection currentSection;

  @override
  List<Object> get props => [currentSection];
}

/// Owns the single page [ScrollController], section keys, active section and
/// scroll progress.
class ScrollCubit extends Cubit<ScrollState> {
  ScrollCubit()
      : super(const ScrollState(currentSection: NavigationSection.hero)) {
    controller.addListener(_onScroll);
  }

  final ScrollController controller = ScrollController();
  final Map<NavigationSection, GlobalKey> keys = {
    for (final s in NavigationSection.values) s: GlobalKey(debugLabel: s.name),
  };

  /// 0..1 progress through the page. Listened to by the top bar only.
  final ValueNotifier<double> progress = ValueNotifier(0);

  void _onScroll() {
    if (!controller.hasClients) return;
    final pos = controller.position;
    final max = pos.maxScrollExtent;
    progress.value = max <= 0 ? 0 : (pos.pixels / max).clamp(0.0, 1.0);

    final viewportH = pos.viewportDimension;
    final line = viewportH * 0.35;
    var active = NavigationSection.hero;
    for (final s in NavigationSection.values) {
      final ctx = keys[s]!.currentContext;
      final box = ctx?.findRenderObject();
      if (box is! RenderBox || !box.attached) continue;
      if (box.localToGlobal(Offset.zero).dy <= line) active = s;
    }
    if (pos.pixels >= max - 2 && max > 0) active = NavigationSection.contact;
    if (active != state.currentSection) {
      emit(ScrollState(currentSection: active));
    }
  }

  Future<void> scrollTo(NavigationSection section,
      {bool reduced = false}) async {
    final ctx = keys[section]?.currentContext;
    if (ctx == null) return;
    await Scrollable.ensureVisible(
      ctx,
      duration: reduced ? Duration.zero : Motion.scroll,
      curve: Motion.easeInOut,
    );
  }

  @override
  Future<void> close() {
    controller
      ..removeListener(_onScroll)
      ..dispose();
    progress.dispose();
    return super.close();
  }
}
