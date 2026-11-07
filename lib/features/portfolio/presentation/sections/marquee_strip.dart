import 'package:flutter/material.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/scroll_scope.dart';

/// Two strips of skills that slide sideways as the page scrolls, in opposite
/// directions. Driven by scroll offset only (no timers), so they stop when the
/// visitor stops. The words are real content, so screen readers get them as a
/// single label rather than as a moving ticker.
class MarqueeStrip extends StatelessWidget {
  const MarqueeStrip({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: sectionGap(context) * 0.5),
      child: Column(
        children: [
          _Row(
            label: 'Engineering',
            words: engineeringSkills,
            direction: -1,
            tint: false,
          ),
          SizedBox(height: fluid(context, 4, 12)),
          _Row(
            label: 'AI and agentic engineering',
            words: aiSkills,
            direction: 1,
            tint: true,
          ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.label,
    required this.words,
    required this.direction,
    required this.tint,
  });

  final String label;
  final List<String> words;

  /// -1 slides left as you scroll down, 1 slides right.
  final int direction;

  /// The AI row uses the accent colour so the two rows read as two groups.
  final bool tint;

  static const double _gap = 40;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final base = tint ? c.signal : c.ink;
    final style = AppType.display(context).copyWith(
      fontSize: fluid(context, 34, 72),
      letterSpacing: -fluid(context, 0.8, 2),
      color: base.withValues(alpha: tint ? 0.34 : 0.16),
    );
    final dot = fluid(context, 7, 12);

    double textWidth(String s) {
      final p = TextPainter(
        text: TextSpan(text: s, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      return p.width;
    }

    final cycle =
        words.fold<double>(0, (sum, w) => sum + textWidth(w) + dot + _gap * 2);

    Widget cycleRow() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final w in words) ...[
              Text(w, style: style, softWrap: false),
              const SizedBox(width: _gap),
              Container(
                width: dot,
                height: dot,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: c.signal,
                ),
              ),
              const SizedBox(width: _gap),
            ],
          ],
        );

    return Semantics(
      label: '$label: ${words.join(', ')}',
      child: ExcludeSemantics(
        child: ClipRect(
          child: SizedBox(
            height: style.fontSize! * 1.25,
            child: ScrollLinked(
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: 0,
                maxWidth: double.infinity,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [cycleRow(), cycleRow(), cycleRow()],
                ),
              ),
              builder: (context, offset, child) {
                final shift = (offset * 0.45) % cycle;
                final x = direction < 0 ? -shift : shift - cycle;
                return Transform.translate(offset: Offset(x, 0), child: child);
              },
            ),
          ),
        ),
      ),
    );
  }
}
