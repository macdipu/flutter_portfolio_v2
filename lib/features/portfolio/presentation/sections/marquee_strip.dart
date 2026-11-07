import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../content/portfolio_content.dart';
import '../../../../core/design/tokens.dart';
import '../../../../core/motion/scroll_scope.dart';

/// A full-width yellow band with two rows of skills.
///
/// The rows are still until the visitor scrolls. A wheel flick sends them
/// gliding in opposite directions, and they coast to a stop over a few
/// seconds, so the movement is easy to notice and never runs on its own.
/// Reduced motion keeps them still. The words are real content, so screen
/// readers get each row as one label instead of a moving ticker.
class MarqueeStrip extends StatelessWidget {
  const MarqueeStrip({super.key});

  /// Amber, matching the accent used on the project sites.
  static const yellow = Color(0xFFFFC83D);

  /// Deep navy, for text and dots on the yellow.
  static const onYellow = Color(0xFF0A1330);

  @override
  Widget build(BuildContext context) {
    final pad = fluid(context, 14, 26);
    return Padding(
      padding: EdgeInsets.only(top: sectionGap(context) * 0.5),
      child: Container(
        width: double.infinity,
        color: yellow,
        padding: EdgeInsets.symmetric(vertical: pad),
        child: Column(
          children: [
            const _Row(
              label: 'Engineering',
              words: engineeringSkills,
              direction: -1,
              strength: 1,
            ),
            SizedBox(height: fluid(context, 2, 8)),
            const _Row(
              label: 'AI and agentic engineering',
              words: aiSkills,
              direction: 1,
              strength: 0.62,
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatefulWidget {
  const _Row({
    required this.label,
    required this.words,
    required this.direction,
    required this.strength,
  });

  final String label;
  final List<String> words;

  /// -1 runs left when scrolling down, 1 runs right.
  final int direction;

  /// Text opacity. The second row is a little softer so the rows read apart.
  final double strength;

  @override
  State<_Row> createState() => _RowState();
}

class _RowState extends State<_Row> with SingleTickerProviderStateMixin {
  static const _gap = 40.0;

  /// How far the row moves per pixel of page scroll, immediately.
  static const _follow = 1.4;

  /// Extra glide, in pixels per second, per pixel-per-second of scroll.
  static const _impulse = 0.7;

  /// Fastest the glide can go.
  static const _maxVelocity = 2200.0;

  /// The glide's time constant in seconds. About three of these (a few
  /// seconds) and it has effectively stopped.
  static const _tau = 1.1;

  final ValueNotifier<double> _pos = ValueNotifier(0);
  late final Ticker _ticker = createTicker(_tick);
  ScrollController? _scroll;
  double _lastOffset = 0;
  double _velocity = 0;
  int _lastEventMicros = 0;
  Duration _lastTick = Duration.zero;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) return;
    final next = ScrollScope.of(context);
    if (next == _scroll) return;
    _scroll?.removeListener(_onScroll);
    _scroll = next..addListener(_onScroll);
    _lastOffset = next.hasClients ? next.offset : 0;
  }

  @override
  void dispose() {
    _scroll?.removeListener(_onScroll);
    _ticker.dispose();
    _pos.dispose();
    super.dispose();
  }

  void _onScroll() {
    final c = _scroll;
    if (c == null || !c.hasClients) return;
    final delta = c.offset - _lastOffset;
    _lastOffset = c.offset;
    if (delta == 0) return;

    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = ((now - _lastEventMicros) / 1e6).clamp(0.008, 0.12);
    _lastEventMicros = now;

    _pos.value += delta * _follow;
    _velocity = (_velocity * 0.7 + (delta / dt) * _impulse)
        .clamp(-_maxVelocity, _maxVelocity);
    if (!_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    }
  }

  void _tick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    _pos.value += _velocity * dt;
    _velocity *= math.exp(-dt / _tau);
    if (_velocity.abs() < 4) {
      _velocity = 0;
      _ticker.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    const ink = MarqueeStrip.onYellow;
    final style = AppType.display(context).copyWith(
      fontSize: fluid(context, 32, 64),
      letterSpacing: -fluid(context, 0.8, 2),
      color: ink.withValues(alpha: widget.strength),
    );
    final dot = fluid(context, 7, 12);

    double textWidth(String s) {
      final p = TextPainter(
        text: TextSpan(text: s, style: style),
        textDirection: TextDirection.ltr,
      )..layout();
      return p.width;
    }

    final cycle = widget.words
        .fold<double>(0, (sum, w) => sum + textWidth(w) + dot + _gap * 2);

    Widget cycleRow() => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final w in widget.words) ...[
              Text(w, style: style, softWrap: false),
              const SizedBox(width: _gap),
              Container(
                width: dot,
                height: dot,
                decoration:
                    const BoxDecoration(shape: BoxShape.circle, color: ink),
              ),
              const SizedBox(width: _gap),
            ],
          ],
        );

    final strip = OverflowBox(
      alignment: Alignment.centerLeft,
      minWidth: 0,
      maxWidth: double.infinity,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [cycleRow(), cycleRow(), cycleRow()],
      ),
    );

    return Semantics(
      label: '${widget.label}: ${widget.words.join(', ')}',
      child: ExcludeSemantics(
        child: ClipRect(
          child: SizedBox(
            height: style.fontSize! * 1.25,
            child: ValueListenableBuilder<double>(
              valueListenable: _pos,
              child: strip,
              builder: (context, pos, child) {
                // Wrap into one cycle, in both directions.
                final shift = ((pos % cycle) + cycle) % cycle;
                final x = widget.direction < 0 ? -shift : shift - cycle;
                return Transform.translate(offset: Offset(x, 0), child: child);
              },
            ),
          ),
        ),
      ),
    );
  }
}
