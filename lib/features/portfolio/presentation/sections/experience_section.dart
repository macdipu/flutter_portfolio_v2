import 'package:flutter/material.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/reveal.dart';
import '../../../../core/motion/scroll_scope.dart';
import '../../../../core/widgets/ui.dart';

class ExperienceSection extends StatelessWidget {
  const ExperienceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionShell(
      title: 'Experience',
      child: Column(
        children: [for (final e in experience) _Employer(employer: e)],
      ),
    );
  }
}

class _Employer extends StatelessWidget {
  const _Employer({required this.employer});
  final Employer employer;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final wide = MediaQuery.sizeOf(context).width >= 900;
    final roles = employer.roles;

    final name = Text(employer.name, style: AppType.h3(context));
    final list = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < roles.length; i++)
          _RoleRow(role: roles[i], isLast: i == roles.length - 1),
        if (employer.shipped.isNotEmpty) ...[
          const SizedBox(height: Space.l),
          Padding(
            padding: const EdgeInsets.only(left: 34),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Products shipped', style: AppType.caption(context)),
                const SizedBox(height: Space.s),
                for (final s in employer.shipped)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Space.s),
                    child: Text(s, style: AppType.body(context)),
                  ),
              ],
            ),
          ),
        ],
      ],
    );

    return Reveal(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: fluid(context, 24, 40)),
        decoration:
            BoxDecoration(border: Border(top: BorderSide(color: c.line))),
        child: wide
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 4, child: name),
                  const SizedBox(width: Space.l),
                  Expanded(flex: 8, child: list),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [name, const SizedBox(height: Space.m), list],
              ),
      ),
    );
  }
}

/// One role. Its connector line draws downward as the row scrolls into the
/// reading zone of the viewport, so the timeline fills in as you read.
class _RoleRow extends StatelessWidget {
  const _RoleRow({required this.role, required this.isLast});

  final Role role;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final vh = MediaQuery.sizeOf(context).height;

    return ScrollLinked(
      builder: (context, offset, _) {
        final top = viewportTop(context);
        final box = context.findRenderObject();
        final h = box is RenderBox && box.hasSize ? box.size.height : 1.0;
        final t = top == null
            ? 1.0
            : ((vh * 0.78 - top) / h).clamp(0.0, 1.0).toDouble();
        final reached = t > 0.02;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : Space.l),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: 18,
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      if (!isLast) ...[
                        Positioned(
                          top: 14,
                          bottom: -Space.l,
                          child: Container(width: 2, color: c.line),
                        ),
                        Positioned(
                          top: 14,
                          bottom: -Space.l,
                          child: FractionallySizedBox(
                            heightFactor: t,
                            alignment: Alignment.topCenter,
                            child: Container(width: 2, color: c.signal),
                          ),
                        ),
                      ],
                      Positioned(
                        top: 8,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 240),
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: reached ? c.signal : c.line,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: Space.m),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        role.position,
                        style: AppType.ui14(context).copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: fluid(context, 16, 18),
                        ),
                      ),
                      Text(role.period, style: AppType.caption(context)),
                      const SizedBox(height: Space.s),
                      Text(role.description, style: AppType.body(context)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
