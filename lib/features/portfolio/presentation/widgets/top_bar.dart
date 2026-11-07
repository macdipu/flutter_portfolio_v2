import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/design/tokens.dart';
import '../../../../core/motion/pressable.dart';
import '../../../../core/navigation/scroll_controller.dart';
import '../../../../core/theme/theme_cubit.dart';
import '../../../../core/widgets/brand_logo.dart';
import '../../../../core/widgets/ui.dart';

/// Below this width the nav collapses into a menu button.
const double kTopBarCompactWidth = 760;

class TopBar extends StatelessWidget {
  const TopBar({super.key, required this.onMenu});

  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final compact = MediaQuery.sizeOf(context).width < kTopBarCompactWidth;
    final cubit = context.read<ScrollCubit>();
    final reduced = Motion.reduced(context);

    return Material(
      color: c.paper.withValues(alpha: 0.94),
      child: SizedBox(
        height: 64,
        child: Stack(
          children: [
            Frame(
              child: Row(
                children: [
                  Pressable(
                    semanticLabel: 'Back to top',
                    onTap: () => cubit.scrollTo(NavigationSection.hero,
                        reduced: reduced),
                    builder: (context, s) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      decoration: focusRing(context, s.focused),
                      child: BrandLogo(active: s.active),
                    ),
                  ),
                  const Spacer(),
                  if (!compact)
                    BlocBuilder<ScrollCubit, ScrollState>(
                      builder: (context, state) => Row(
                        children: [
                          for (final s in NavigationSection.navItems) ...[
                            _NavLink(
                              section: s,
                              active: state.currentSection == s,
                              onTap: () => cubit.scrollTo(s, reduced: reduced),
                            ),
                            const SizedBox(width: Space.l),
                          ],
                        ],
                      ),
                    ),
                  const _ThemeToggle(),
                  if (compact) ...[
                    const SizedBox(width: Space.xs),
                    _IconAction(
                      icon: Icons.menu,
                      label: 'Open menu',
                      onTap: onMenu,
                    ),
                  ],
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Stack(
                children: [
                  Container(height: 1, color: c.line),
                  ValueListenableBuilder<double>(
                    valueListenable: cubit.progress,
                    builder: (context, p, _) => FractionallySizedBox(
                      widthFactor: p,
                      alignment: Alignment.centerLeft,
                      child: Container(height: 2, color: c.signal),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavLink extends StatelessWidget {
  const _NavLink({
    required this.section,
    required this.active,
    required this.onTap,
  });

  final NavigationSection section;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: section.label,
      builder: (context, s) => Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
        decoration: focusRing(context, s.focused),
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: AnimatedDefaultTextStyle(
                duration: Motion.scaled(context, Motion.hover),
                style: AppType.ui14(context).copyWith(
                  color: (active || s.hovered) ? c.ink : c.muted,
                  fontWeight: active ? FontWeight.w700 : FontWeight.w500,
                ),
                child: Text(section.label),
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AnimatedFractionallySizedBox(
                duration: Motion.scaled(context, Motion.exit),
                curve: Motion.easeOut,
                alignment: Alignment.centerLeft,
                widthFactor: (active || s.hovered) ? 1 : 0.0,
                child: Container(
                  height: 2,
                  color: active ? c.signal : c.line,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IconAction extends StatelessWidget {
  const _IconAction(
      {required this.icon, required this.label, required this.onTap});

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Pressable(
      onTap: onTap,
      semanticLabel: label,
      builder: (context, s) => Container(
        width: 44,
        height: 44,
        decoration: focusRing(context, s.focused, radius: Radii.md),
        child: Icon(icon, color: s.hovered ? c.signal : c.ink, size: 22),
      ),
    );
  }
}

class _ThemeToggle extends StatelessWidget {
  const _ThemeToggle();

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return _IconAction(
      icon: dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
      label: dark ? 'Switch to light theme' : 'Switch to dark theme',
      onTap: () =>
          context.read<ThemeCubit>().toggle(Theme.of(context).brightness),
    );
  }
}

/// Full-screen menu for compact widths.
class MobileMenu extends StatelessWidget {
  const MobileMenu({super.key, required this.onClose, required this.onSelect});

  final VoidCallback onClose;
  final ValueChanged<NavigationSection> onSelect;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.paper,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 64,
              child: Frame(
                child: Row(
                  children: [
                    const BrandLogo(),
                    const Spacer(),
                    _IconAction(
                        icon: Icons.close, label: 'Close menu', onTap: onClose),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Frame(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (final s in NavigationSection.navItems)
                      Pressable(
                        onTap: () => onSelect(s),
                        semanticLabel: s.label,
                        builder: (context, st) => Padding(
                          padding:
                              const EdgeInsets.symmetric(vertical: Space.s),
                          child: Text(
                            s.label,
                            style: AppType.h1(context)
                                .copyWith(color: st.active ? c.signal : c.ink),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
